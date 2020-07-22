import 'package:flutter/material.dart';
import 'package:overlay/overlay.dart';

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
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Overlay.of(context).insert(
            buildOverlayEntry(
              context,
              [
                'test',
                'test',
                'test',
                'test',
                'test',
                'test',
                'test',
              ],
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

OverlayEntry buildOverlayEntry(BuildContext context, List<String> logs) {
  OverlayEntry entry;

  return entry = OverlayEntry(
    opaque: false,
    maintainState: true,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black54.withOpacity(0.75),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Text(
                        logs[index],
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                            ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container();
                    },
                    itemCount: logs.length),
              ),
              RaisedButton(
                onPressed: () {
                  entry.remove();
                },
                child: Text('close'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
