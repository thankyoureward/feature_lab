import 'package:flutter/material.dart';

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
  String message = '';
  Color _color = Colors.white;

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      entries.add('New ${entries.length.toString()}');
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      setState(() {
        _color = Colors.cyan;
      });
      if (!_controller.position.outOfRange) {
        setState(() {
          message = "reach the bottom";
          _color = Colors.amber;
        });
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent) {
      setState(() {
        _color = Colors.cyan;
      });
      if (!_controller.position.outOfRange) {
        setState(() {
          message = "reach the top";
          _color = Colors.amber;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            height: 50.0,
            color: _color,
            child: Center(
              child: Text(message),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildElement(context, index);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildElement(BuildContext context, int index) {
    return Container(
      height: 50,
      color: Colors.amber[colorCodes[index % colorCodes.length]],
      child: Center(child: Text('Entry ${entries[index]}')),
    );
  }
}
