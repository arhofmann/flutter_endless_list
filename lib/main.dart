import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Endless List"),
        ),
        body: MyList(),
      ),
    );
  }
}

class MyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  bool _showLoadIndicator = false;
  List<String> data = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      data.addAll([
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "17",
        "18",
        "19",
        "20",
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints.tight(Size(22, 22)),
                margin: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ));
        }
        return _visibleDetector(index.toString());
      },
    );
  }

  Widget _card(String data) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Text(data),
      ),
    );
  }

  Widget _visibleDetector(String data) {
    return VisibilityDetector(
      key: Key(data),
      child: _card(data),
      onVisibilityChanged: _onVisibilityChanged,
    );
  }

  Future<List<String>> _loadMore() async {
    return Future.delayed(const Duration(seconds: 2), () {
      List<String> list = [];
      for (int i = 0; i < 20; i++) {
        list.add("" + (i).toString());
      }
      return list;
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) async {
    var key = info.key.toString();
    int currentIndex = int.parse(key.substring(3, key.length - 3));

    if (currentIndex >= data.length - 1) {
      setState(() {
        _showLoadIndicator = true;
      });
      final more = await _loadMore();
      setState(() {
        data.addAll(more);
        _showLoadIndicator = false;
      });
    }
  }
}
