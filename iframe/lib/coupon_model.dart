import 'dart:convert';

enum DayOfTheWeek {
  none,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class CouponMarketeResponse {
  final List<CouponModel> results;
  final bool fetchMoreCoupon;

  CouponMarketeResponse({
    this.results,
    this.fetchMoreCoupon,
  });

  factory CouponMarketeResponse.fromJson(
      Map<String, dynamic> json, bool fetchMore) {
    List<CouponModel> resultsTemp = List<CouponModel>();
    if (null != json) {
      var message = json['message'] as List;
      resultsTemp.addAll(
          message.map((coupon) => CouponModel.fromJson(coupon)).toList());
    }
    return CouponMarketeResponse(
      results: resultsTemp,
      fetchMoreCoupon: fetchMore,
    );
  }
}

/// coupon 정보
class CouponModel {
  final String createdDate;
  final String modifiedDate;
  final int couponId;
  final String storeNum;
  final String name;
  final String description;
  final String storePhoneNumber;
  final int price;
  final int neededCoins;
  final List<String> limits;
  final int status;
  final List<CouponPicture> pictures;
  final String storeName;
  final String storeDescription;
  final String storeSimpleDescription;
  final double latitude;
  final double longitude;
  final List<String> openTime;
  final String storeAddress;
  final String storeAddressDetail;
  bool heart;
  int heartCount;
  double distanceInMeters;

  CouponModel({
    this.createdDate,
    this.modifiedDate,
    this.couponId,
    this.storeNum,
    this.name,
    this.description,
    this.storePhoneNumber,
    this.price,
    this.neededCoins,
    this.limits,
    this.status,
    this.pictures,
    this.storeName,
    this.storeDescription,
    this.storeSimpleDescription,
    this.heart,
    this.latitude,
    this.longitude,
    this.openTime,
    this.storeAddress,
    this.storeAddressDetail,
    this.heartCount,
  });

  factory CouponModel.fromJson(Map<String, dynamic> jsonContent) {
    var pictureList = json.decode(jsonContent['pictures']);
    List<CouponPicture> pictureInfos = List<CouponPicture>();

    if (pictureList != null) {
      pictureList.forEach((element) {
        CouponPicture couponPictureInfo = CouponPicture.fromJson(element);
        if (PictureType.qr != PictureType.values[couponPictureInfo.type]) {
          pictureInfos.add(CouponPicture.fromJson(element));
        }
      });

      // sort by order
      pictureInfos.sort((a, b) => a.order.compareTo(b.order));
    }

    return CouponModel(
      createdDate: jsonContent['createdDate'],
      modifiedDate: jsonContent['modifiedDate'],
      couponId: jsonContent['couponId'],
      storeNum: jsonContent['storeNum'],
      name: jsonContent['name'],
      description: jsonContent['description'],
      storePhoneNumber: jsonContent['storePhoneNumber'],
      price: jsonContent['price'],
      neededCoins: jsonContent['neededCoins'],
      limits: List<String>.from(json.decode(jsonContent['limits'])),
      status: jsonContent['status'],
      pictures: pictureInfos,
      storeName: jsonContent['storeName'],
      storeDescription: jsonContent['storeDescription'],
      storeSimpleDescription: jsonContent['storeSimpleDescription'],
      heart: jsonContent['heart'],
      latitude: jsonContent['latitude'],
      longitude: jsonContent['longitude'],
      openTime:
          List<String>.from(jsonContent['openTime'].toString().split('\n')),
      storeAddress: jsonContent['storeAddress'],
      storeAddressDetail: jsonContent['storeAddressDetail'],
      heartCount: jsonContent['heartCount'],
    );
  }

  factory CouponModel.dummy() {
    return CouponModel(
      createdDate: '2020-07-15',
      modifiedDate: '2020-07-15',
      couponId: 20200715,
      storeNum: '278678',
      name: '공깃밥 무료',
      description: '함께 먹어요, 공깃밥 추가요.',
      storePhoneNumber: '010-7537-1643',
      price: 10000,
      neededCoins: 1,
      limits: ['남기면 듀금', '으앙 듀금'],
      status: 0,
      pictures: [
        CouponPicture(
          id: 0,
          type: 0,
          url:
              'https://th4.tmon.kr/thumbs/image/fd3/937/378/6e5b18ace_700x700_95_FIT.jpg',
          order: 0,
        ),
        CouponPicture(
          id: 0,
          type: 0,
          url:
              'https://th4.tmon.kr/thumbs/image/fd3/937/378/6e5b18ace_700x700_95_FIT.jpg',
          order: 1,
        ),
        CouponPicture(
          id: 0,
          type: 0,
          url:
              'https://th4.tmon.kr/thumbs/image/fd3/937/378/6e5b18ace_700x700_95_FIT.jpg',
          order: 2,
        ),
      ],
      storeName: '플러딩딩',
      storeDescription: '언제나 배고품이 가득한 그 곳',
      storeSimpleDescription: '우리도 고기 좋아하는데...',
      heart: true,
      latitude: 37.561628,
      longitude: 126.925967,
      openTime: ['우린 평일에도 출근하고', '주말에도 출근해요'],
      storeAddress: '서울시 마포구 동교로38길 33-9',
      storeAddressDetail: '202호',
      heartCount: 153,
    );
  }

  List<String> getPictureUrls() {
    List<String> urls = List<String>();
    pictures.forEach((item) {
      urls.add(item.url);
    });

    return urls;
  }
}

// [{"closeTime":23,"closeMinute":0,"openMinute":0,"id":78,"openTime":7,"day":1},
class Openinghours {
  Openinghours({
    this.openTime,
    this.openMinute,
    this.closeTime,
    this.closeMinute,
    this.day,
  });

  final int openTime;
  final int openMinute;
  final int closeTime;
  final int closeMinute;
  final DayOfTheWeek day;

  static const Map<DayOfTheWeek, String> _dayOfTheWeeks = {
    DayOfTheWeek.monday: '월요일',
    DayOfTheWeek.tuesday: '화요일',
    DayOfTheWeek.wednesday: '수요일',
    DayOfTheWeek.thursday: '목요일',
    DayOfTheWeek.friday: '금요일',
    DayOfTheWeek.saturday: '토요일',
    DayOfTheWeek.sunday: '일요일',
  };

  factory Openinghours.fromJson(Map<String, dynamic> json) {
    return Openinghours(
      openTime: json['openTime'],
      openMinute: json['openMinute'],
      closeTime: json['closeTime'],
      closeMinute: json['closeMinute'],
      day: DayOfTheWeek.values[json['day']],
    );
  }

  @override
  String toString() {
    int _closeTime = closeTime > 24 ? closeTime - 24 : closeTime;
    return _dayOfTheWeeks[day] +
        ' ${twoDigits(openTime)}:${twoDigits(openMinute)} ~ ${twoDigits(_closeTime)}:${twoDigits(closeMinute)}';
  }

  twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }
}

enum PictureType {
  product,
  store,
  qr,
}

/// coupon picture info
class CouponPicture {
  final int id;
  final int type;
  final String url;
  final int order;

  CouponPicture({this.id, this.type, this.url, this.order});

  factory CouponPicture.fromJson(Map<String, dynamic> json) {
    return CouponPicture(
      id: json['id'],
      type: json['type'],
      url: json['url'],
      order: json['order'],
    );
  }
}
