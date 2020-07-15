import 'dart:io' show Platform;
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:launch_review/launch_review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iframe/coupon_model.dart';
import 'package:iframe/store_location_in_map.dart';

class Coupon extends StatelessWidget {
  final CouponModel info;
  final String _notMyFalut =
      '(주)플러디는 상품거래에 대한 중개자이며, 판매의 당사자가 아닙니다. 따라서 (주)플러디는 상품 거래정보 및 거래에 대하여 책임을 지지 않습니다.';
  final Color _mainContrastColor = Color(0xffff8787);
  final Color _mainAccentColor = Color(0xffffe082);
  final Color _textColor = Color(0xff3c3c3b);

  Coupon({
    this.info,
  }) {
    callJS(info);
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    final imageHeight = MediaQuery.of(context).size.width;

    return Material(
      child: NotificationListener<ScrollNotification>(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildCouponImagesPageView(
                  context,
                  urls: info.getPictureUrls(),
                  pageController: _pageController,
                  imageHeight: imageHeight,
                  isBackButton: false,
                ),
                // 이미지 인디케이터
                buildImageIndicator(
                  context,
                  pageController: _pageController,
                  imageCount: info.getPictureUrls().length,
                ),
                buildCouponTitleDetail(
                  context,
                  title: info.name,
                  description: info.description,
                  couponValue: addCommaToStringNumber(info.price),
                  coinCount: addCommaToStringNumber(info.neededCoins),
                ),
                buildParagraphLimitation(
                  context: context,
                  title: '사용 조건',
                  content: info.limits,
                ),
                buildParagraph(
                  context,
                  title: info.storeName,
                  content: [
                    info.storeDescription,
                  ],
                  image: Image.asset('assets/icon/icon_thank_you_store.png'),
                  imageHeight: 40.0,
                  imageWidth: 40.0,
                ),
                buildDivider(),
                buildParagraph(
                  context,
                  title: '전화번호',
                  content: [
                    info.storePhoneNumber,
                  ],
                  image: Image.asset('assets/icon/icon_phone.png'),
                  imageHeight: 24.0,
                  imageWidth: 24.0,
                ),
                buildDivider(),
                buildParagraph(
                  context,
                  title: '영업시간',
                  content: info.openTime,
                  image: Image.asset('assets/icon/icon_clock.png'),
                  imageHeight: 24.0,
                  imageWidth: 24.0,
                ),
                buildDivider(),
                buildParagraph(
                  context,
                  title: '주소',
                  content: [
                    info.storeAddress + ' ' + info.storeAddressDetail,
                  ],
                  image: Image.asset('assets/icon/icon_marker.png'),
                  imageHeight: 36.0,
                  imageWidth: 20.0,
                ),
                Container(
                  height: 250.0,
                  child: StoreLocation(
                    storeName: info.storeName,
                    storeDescription: info.storeSimpleDescription,
                    latitude: info.latitude,
                    longitude: info.longitude,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  child: buildParagraphContent(
                    context: context,
                    content: [
                      _notMyFalut,
                    ],
                    textStyle: Theme.of(context).textTheme.caption,
                  ),
                ),

                // web 환경인지 확인한다.
                _buildButtonVisitThankYouWebpage(context),

                Column(
                  children: [
                    _buildButtonVisitStore(
                      context,
                      'assets/coin.png',
                      'https://play.google.com/store/apps/details?id=com.facebook.katana',
                    ),
                    _buildButtonVisitStore(
                      context,
                      'assets/coin.png',
                      'https://apps.apple.com/us/app/facebook/id284882215',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCouponImagesPageView(
    BuildContext context, {
    @required List<String> urls,
    @required PageController pageController,
    @required double imageHeight,
    bool isBackButton = false,
  }) {
    return Stack(
      children: <Widget>[
        Container(
          height: imageHeight,
          child: (null == urls || urls.isEmpty)
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Theme.of(context).accentColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/coupon_image_place_holder.png',
                        width: 150,
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Text(
                          '매너, 혜택이 되다',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                )
              : PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  children: urls
                      .map((url) => buildCouponImage(context, url: url))
                      .toList(),
                ),
        ),
        isBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Container(),
      ],
    );
  }

  Container buildCouponImage(
    BuildContext context, {
    String url,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) {
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              width: 20,
              height: 20,
            ),
          );
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildImageIndicator(
    context, {
    @required PageController pageController,
    @required int imageCount,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        alignment: Alignment(0, 0),
        child: (1 >= imageCount)
            ? Container()
            : SmoothPageIndicator(
                controller: pageController,
                count: imageCount,
                effect: SlideEffect(
                  spacing: 5.0,
                  radius: 10.0,
                  dotWidth: 5.0,
                  dotHeight: 5.0,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 0,
                  dotColor: Colors.grey[300],
                  activeDotColor: Theme.of(context).accentColor,
                ),
              ),
      ),
    );
  }

  Widget buildCouponTitleDetail(
    BuildContext _context, {
    @required String title,
    @required String description,
    @required String couponValue,
    @required String coinCount,
  }) {
    final EdgeInsetsGeometry marginParagraph = EdgeInsets.fromLTRB(
      20.0,
      20.0,
      20.0,
      10.0,
    );

    final double coinSize = 25.0;

    return Container(
      margin: marginParagraph,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(_context).textTheme.headline6.copyWith(
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                width: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'assets/coin.png',
                    width: coinSize,
                    height: coinSize,
                  ),
                  // Container(
                  //   height: columnGap,
                  // ),
                  Text(
                    '환산가치',
                    style: Theme.of(_context).textTheme.bodyText2,
                  ),
                ],
              ),
              Container(
                width: 5.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: coinSize,
                    child: RichText(
                      text: TextSpan(
                        text: coinCount,
                        style: Theme.of(_context).textTheme.headline6.copyWith(
                              height: 1.0,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '개',
                            style: Theme.of(_context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '$couponValue원',
                    style: Theme.of(_context).textTheme.bodyText2,
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: buildParagraphContent(
              context: _context,
              content: [
                description,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildParagraphContent({
    BuildContext context,
    List<String> content,
    double lineMargin = 0,
    TextStyle textStyle,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          content.length,
          (index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsetsDirectional.only(bottom: lineMargin),
                child: Text(
                  content[index],
                  style: null != textStyle
                      ? textStyle
                      : Theme.of(context).textTheme.bodyText2.copyWith(
                            height: 1.5,
                          ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildParagraphLimitation({
    @required BuildContext context,
    @required String title,
    @required List<String> content,
    List<String> informContent = const [
      '쿠폰의 유효기간은 구매일로부터 14일입니다',
      '쿠폰 구매 후 땡큐코인 환불은 불가합니다',
    ],
  }) {
    return Container(
      color: Color(0xffe7e7e7),
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildParagraphTitle(context, title),
            Container(
              height: 5.0,
            ),
            buildParagraphContentWithIcon(
              context: context,
              content: content,
              color: _mainContrastColor,
            ),
            buildDivider(
              color: Colors.grey[500],
            ),
            buildParagraphContentWithIcon(
              context: context,
              content: informContent,
              color: _mainContrastColor,
            ),
            // buildParagraphContent(_context, content),
          ],
        ),
      ),
    );
  }

  Widget buildParagraphTitle(BuildContext _context, String content) {
    TextStyle textStyle = Theme.of(_context).textTheme.subtitle2;
    return Text(
      content,
      style: textStyle.copyWith(
        fontSize: textStyle.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildParagraphContentWithIcon({
    @required BuildContext context,
    @required List<String> content,
    Color color,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return Container(
      child: Column(
        children: List.generate(
          content.length,
          (index) {
            return Container(
              margin: EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: ClipOval(
                          child: Container(
                            width: 5.0,
                            height: 5.0,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      content[index],
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: overflow,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDivider({
    Color color = const Color(0xffd6d6d6),
  }) {
    return Divider(
      color: color,
    );
  }

  Widget buildParagraph(
    BuildContext _context, {
    @required String title,
    @required List<String> content,
    Image image,
    double imageWidth,
    double imageHeight,
    bool isCouponTitle = false,
    double vertical = 20.0,
    double horizontal = 20.0,
  }) {
    final EdgeInsetsGeometry marginParagraph = EdgeInsets.symmetric(
      vertical: vertical,
      horizontal: horizontal,
    );
    return Container(
      margin: marginParagraph,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isCouponTitle
              ? Text(
                  title,
                  style: Theme.of(_context).textTheme.subtitle2,
                )
              : Row(
                  children: <Widget>[
                    Container(
                      child: buildParagraphTitle(
                        _context,
                        title,
                      ),
                    ),
                  ],
                ),
          Container(
            height: 10.0,
          ),
          buildParagraphContent(
            context: _context,
            content: content,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonVisitStore(
      BuildContext context, String imagePath, String url) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      width: 185.0,
      height: 45.0,
      child: RaisedButton(
        onPressed: () async {
          if (kIsWeb) {
            // https://play.google.com/store/apps/details?id=com.floody.thank_you_reward
            bool _canLaunch = await canLaunch(url);
            if (_canLaunch) {
              await launch(url);
            }
          } else {
            // LaunchReview.launch(
          //   androidAppId: "com.floody.thank_you_reward",
          //   iOSAppId: "1516566788",
          // );
          }
        },
        color: _mainAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: Image.asset(
            imagePath,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonVisitThankYouWebpage(BuildContext context) {
    String url = 'https://thankyoureward.co.kr/';

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      width: 185.0,
      height: 45.0,
      child: RaisedButton(
        onPressed: () async {
          bool _canLaunch = await canLaunch(url);
          if (_canLaunch) {
            await launch(url);
          }
        },
        color: _mainAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: Text(
            '땡큐리워드 홈으로 가기',
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  String addCommaToStringNumber(int number) {
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  void callJS(CouponModel coupon) {
    html.Node headNode = html.document.getElementsByTagName('head')[0];
    html.Element elementUrl = html.document.createElement('meta');
    elementUrl.setAttribute('property', 'og:url');
    elementUrl.setAttribute('content', 'https://thankyoureward.co.kr');

    headNode.append(elementUrl);

    html.Element elementType = html.document.createElement('meta');
    elementType.setAttribute('property', 'og:type');
    elementType.setAttribute('content', 'website');

    headNode.append(elementType);

    html.Element elementTitle = html.document.createElement('meta');
    elementTitle.setAttribute('property', 'og:title');
    elementTitle.setAttribute(
        'content', '${coupon.name} - 땡큐리워드 THANK YOU Reward');

    headNode.append(elementTitle);

    html.Element elementDescription = html.document.createElement('meta');
    elementDescription.setAttribute('property', 'og:description');
    elementDescription.setAttribute('content', '${coupon.description}');

    headNode.append(elementDescription);

    html.Element elementImage = html.document.createElement('meta');
    elementImage.setAttribute('property', 'og:image');
    elementImage.setAttribute('content', coupon.getPictureUrls()[0]);

    headNode.append(elementImage);
  }
}
