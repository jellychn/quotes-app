import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes By Master Hsing Yun',
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
  String quote = '';
  String chinese = '';
  String traditional = '';
  String type = '';
  int day = 0;
  String month = '';
  bool toggleTraditional = false;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  int selectedIndex = 0;

  @override
  void initState() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => getQuote());
    super.initState();
  }

  void getDate() {
    var now = DateTime.now();
    String m = '';
    if (now.month == 1) {
      m = 'Jan';
    } else if (now.month == 2) {
      m = 'Feb';
    } else if (now.month == 3) {
      m = 'Mar';
    } else if (now.month == 4) {
      m = 'Apr';
    } else if (now.month == 5) {
      m = 'May';
    } else if (now.month == 6) {
      m = 'Jun';
    } else if (now.month == 7) {
      m = 'Jul';
    } else if (now.month == 8) {
      m = 'Aug';
    } else if (now.month == 9) {
      m = 'Sep';
    } else if (now.month == 10) {
      m = 'Oct';
    } else if (now.month == 11) {
      m = 'Nov';
    } else if (now.month == 12) {
      m = 'Dec';
    }
    setState(() {
      day = now.day;
      month = m;
      hours = now.hour;
      minutes = now.minute;
      seconds = now.second;
    });
  }

  void getQuote() async {
    getDate();
    String data = await rootBundle.loadString('assets/quotes.json');
    dynamic quotes = json.decode(data);
    if (quotes != null) {
      for (var i = 0; i < quotes.length; i++) {
        var q = quotes[i];
        if (q['month'] == month && q['day'] == day) {
          setState(() {
            quote = q['quote'];
            chinese = q['chinese'];
            traditional = q['traditional'];
            type = q['type'];
          });
        }
      }
    }
  }

  void changeIndex(int index, bool traditional) {
    setState(() {
      selectedIndex = index;
      toggleTraditional = traditional;
    });
  }

  Widget customRadio(String text, int index, bool traditional) {
    return FlatButton(
      onPressed: () => changeIndex(index, traditional),
      color: selectedIndex == index ? Color(0xffeeeeee) : Color(0xFFF8F9FB),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Righteous',
            color:
                selectedIndex == index ? Color(0xff1C1B20) : Color(0xffa9a8a8)),
      ),
    );
  }

  String chineseText() {
    if (toggleTraditional == true) {
      return '$traditional';
    } else {
      return '$chinese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      padding: EdgeInsets.all(20.0),
      color: Color(0xFFF8F9FB),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              '$hours : $minutes : $seconds',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xffd3d3d5),
                  fontFamily: 'Righteous'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Text(
              '$month. $day ~ $type',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xffa9a8a8),
                  fontFamily: 'Righteous'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
            child: Text(
              '$quote',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xff1C1B20),
                  fontFamily: 'Lobster'),
            ),
          ),
          Row(
            children: [
              customRadio('SIMPLIFIED', 0, false),
              customRadio('TRADITIONAL', 1, true)
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Text(
              chineseText(),
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xff1C1B20),
                  fontFamily: 'NotoSansTC'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              '星雲',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xff1C1B20),
                  fontFamily: 'NotoSansTC'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              '366 Days With Wisdom, \nBy Master Hsing Yun',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xffa9a8a8),
                  fontFamily: 'Righteous'),
            ),
          ),
        ],
      ),
    ));
  }
}
