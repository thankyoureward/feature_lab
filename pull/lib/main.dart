import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  final _controller = ScrollController();
  Color _color = Colors.white;
  // bool _releaseStart = false;
  // bool _releasing = false;
  bool _processing = false;
  double prevOffset = 0.0;
  String message = '';

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _incrementCounter(int count) {
    setState(
      () {
        for (int i = 0; i < count; ++i) {
          entries.add('New ${entries.length.toString()}');
        }
      },
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      debugPrint(_controller.offset.toString() + ' ' + prevOffset.toString());
      if (prevOffset > _controller.offset) {
        if (!_processing) {
          setState(
            () {
              _incrementCounter(10);
              _processing = true;
              _color = Colors.cyan;
              message = "create elements";
            },
          );
        }
      }
      if (!_controller.position.outOfRange) {
        setState(
          () {
            message = "reach the bottom";
            _color = Colors.pinkAccent;
            _processing = false;
          },
        );
      }
      // if (_controller.position.userScrollDirection == ScrollDirection.forward) {

      // }
      // if (_releasing) {
      //   _color = Colors.cyan;
      //   if (!_processing) {
      //     _incrementCounter(1);
      //     _processing = true;
      //   }
      // }
      // if (!_controller.position.outOfRange) {
      //   setState(() {
      //     message = "reach the bottom";
      //     _color = Colors.amber;
      //     _processing = false;
      //   });
      // }
    }
    if (_controller.offset <= _controller.position.minScrollExtent) {
      // setState(() {
      //   if (_releasing) {
      //     _color = Colors.cyan;
      //     _incrementCounter(1);
      //     _releasing = false;
      //   }
      // });
      // if (!_controller.position.outOfRange) {
      //   setState(() {
      //     message = "reach the top";
      //     _color = Colors.amber;
      //   });
      // }
    }
    prevOffset = _controller.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        child: Column(
          children: [
            Container(
              height: 50.0,
              color: _color,
              child: Center(
                child: Text(message),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildElement(context, index);
                },
                separatorBuilder: (context, index) => Container(
                  height: 10.0,
                ),
              ),
            ),
          ],
        ),
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            debugPrint('scroll start');
          } else if (notification is ScrollUpdateNotification) {
            debugPrint('scroll update');
          } else if (notification is ScrollEndNotification) {
            debugPrint('scroll end');
          }
          // debugPrint(notification.toString());
          // if (notification is ScrollStartNotification) {
          //   _releaseStart = true;
          // }
          // if (notification is ScrollUpdateNotification &&
          //     null == notification.dragDetails) {
          //   _releasing = true;
          // }
          return true;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(1),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // body: Column(
      //   children: [
      //     Container(
      //       height: 50.0,
      //       color: _color,
      //       child: Center(
      //         child: Text(message),
      //       ),
      //     ),
      //     Expanded(
      //       // child: Listener(
      //       //   onPointerUp: (event) {
      //       //     debugPrint('onPointerUp');
      //       //   },
      //       //   child: ListView.builder(
      //       //     controller: _controller,
      //       //     physics: BouncingScrollPhysics(),
      //       //     padding: const EdgeInsets.all(8),
      //       //     itemCount: entries.length,
      //       //     itemBuilder: (BuildContext context, int index) {
      //       //       return _buildElement(context, index);
      //       //     },
      //       //   ),
      //       // ),

      //       child: GestureDetector(
      //         onVerticalDragStart: (details) {
      //           _pullEnd = false;
      //           debugPrint('onVerticalDragStart false');
      //         },
      //         onVerticalDragEnd: (details) {
      //           _pullEnd = true;
      //           debugPrint('onVerticalDragStart true');
      //         },
      //         child: ListView.builder(
      //           // controller: _controller,
      //           physics: BouncingScrollPhysics(),
      //           padding: const EdgeInsets.all(8),
      //           itemCount: entries.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return _buildElement(context, index);
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // onTap: () => debugPrint('onVerticalDragStart false'),
      // onVerticalDragStart: (details) {
      //   _pullEnd = false;
      //   debugPrint('onVerticalDragStart false');
      // },
      // onVerticalDragEnd: (details) {
      //   _pullEnd = true;
      //   debugPrint('onVerticalDragStart true');
      // },
      // onVerticalDragUpdate: (details) {
      //   debugPrint('onVerticalDragUpdate');
      // },
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _incrementCounter(1),
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildElement(BuildContext context, int index) {
    return Container(
      height: 300,
      color: Colors.amber[colorCodes[index % colorCodes.length]],
      child: Center(child: Text('Entry ${entries[index]}')),
    );
  }
}
