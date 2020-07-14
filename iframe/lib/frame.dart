import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class WebFrame extends StatefulWidget {
  @override
  _WebFrameState createState() => _WebFrameState();
}

class _WebFrameState extends State<WebFrame> {
  final String _elementName = 'iFrameElement';
  final IFrameElement _iFrameElement = IFrameElement();
  Widget _iFrameWidget;

  @override
  void initState() {
    super.initState();

    _iFrameElement.height = '500';
    _iFrameElement.width = '500';
    _iFrameElement.src = 'https://www.youtube.com/embed/RQzhAQlg2JQ';
    _iFrameElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _elementName,
      (int viewId) => _iFrameElement,
    );

    _iFrameWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: _elementName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('test'),
          Container(
            child: _iFrameWidget,
          ),
        ],
      ),
    );
  }
}
