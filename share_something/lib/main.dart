import 'package:flutter/material.dart';
import 'package:share/share.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatefulWidget {
  @override
  DemoAppState createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  String text = '';
  String subject = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Plugin Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Share Plugin Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Share text:',
                  hintText: 'Enter some text and/or link to share',
                ),
                maxLines: 2,
                onChanged: (String value) => setState(() {
                  text = value;
                }),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Share subject:',
                  hintText: 'Enter subject to share (optional)',
                ),
                maxLines: 2,
                onChanged: (String value) => setState(() {
                  subject = value;
                }),
              ),
              const Padding(padding: EdgeInsets.only(top: 24.0)),
              RaisedButton(
                onPressed: () {
                  Share.share('https://thankyoureward.co.kr/coupon');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.share,
                    ),
                    Text(
                      'Coupons',
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Share.share('https://thankyoureward.co.kr/how');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.share,
                    ),
                    Text(
                      'How',
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Share.share('https://thankyoureward.co.kr/store_apply');
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.share,
                    ),
                    Text(
                      'Come Come',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
