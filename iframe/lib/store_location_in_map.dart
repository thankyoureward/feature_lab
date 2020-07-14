import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class StoreLocation extends StatefulWidget {
  StoreLocation({
    @required this.storeName,
    @required this.storeDescription,
    @required this.latitude,
    @required this.longitude,
  });

  final String storeName;
  final String storeDescription;
  final double latitude;
  final double longitude;

  @override
  _StoreLocationState createState() => _StoreLocationState();
}

class _StoreLocationState extends State<StoreLocation> {
  static const String _baseUrl = 'd3rpi9907nkgxk.cloudfront.net';
  final IFrameElement _iFrameElement = IFrameElement();
  Widget _iFrameWidget;

  @override
  void initState() {
    super.initState();

    Map<String, String> params = {
      'lat': widget.latitude.toString(),
      'lon': widget.longitude.toString(),
      'storeName': widget.storeName,
    };

    String uri = Uri.https(_baseUrl, '', params).toString();

    _iFrameElement.height = '500';
    _iFrameElement.width = '500';
    _iFrameElement.style.border = 'none';
    _iFrameElement.src = uri;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iFrameElement',
      (int viewId) => _iFrameElement,
    );

    _iFrameWidget = HtmlElementView(viewType: 'iFrameElement');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _iFrameWidget,
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('map disposed');
  }
}
