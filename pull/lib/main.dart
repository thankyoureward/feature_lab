import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
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
  Color _color = Colors.green;
  bool _processing = false;
  double prevOffset = 0.0;
  String message = 'start';
  bool _loading = false;

  @override
  void initState() {
    _controller.addListener(
      _scrollListener,
    );
    super.initState();
  }

  _incrementCounter(int count) async {
    setState(() {
      _loading = true;
      debugPrint('loading $_loading');
    });

    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () {
        for (int i = 0; i < count; ++i) {
          entries.add('New ${entries.length.toString()}');
        }
      },
    ).then(
      (value) {
        setState(() {
          _loading = false;
          debugPrint('loading $_loading');
        });
      },
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
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
            _color = Colors.greenAccent;
            _processing = false;
          },
        );
      }
    }
    prevOffset = _controller.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: _loading
            ? PreferredSize(
                child: LinearProgressIndicator(
                  backgroundColor: Colors.deepOrangeAccent,
                  minHeight: 2.0,
                ),
                preferredSize: Size(
                  double.infinity,
                  2.0,
                ),
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size(
                  double.infinity,
                  2.0,
                ),
              ),
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
          // if (notification is ScrollStartNotification) {
          //   debugPrint('scroll start');
          // } else if (notification is ScrollUpdateNotification) {
          //   debugPrint('scroll update');
          // } else if (notification is ScrollEndNotification) {
          //   debugPrint('scroll end');
          // }
          return true;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.amberAccent,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.hotel,
              color: Colors.amberAccent,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.https,
              color: Colors.amberAccent,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inbox,
              color: Colors.amberAccent,
            ),
            title: Text(''),
          ),
        ],
      ),
      bottomSheet: _loading
          ? Container(
            height: 2.0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.deepOrangeAccent,
              ),
            )
          : Container(
              height: 0.0,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              entries.clear();
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
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
