import 'package:flutter/material.dart';
import 'package:lets_vote/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'initialization_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool introCompleted;
  bool setupCompleted;

  Future<bool> getIntroductionStatus() async {
    String keyName = 'introCompleted';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introCompleted = (prefs.getBool(keyName));
    return introCompleted;
  }

  Future<bool> getSetupStatus() async {
    String keyName = 'address';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = (prefs.getString(keyName));
    if (address != null) {
      return true;
    }
    return false;
  }

  void getStatus() async {
    //introCompleted = await getIntroductionStatus();
    bool isSetupCompleted;
    try {
      isSetupCompleted = await getSetupStatus();
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        setupCompleted = isSetupCompleted;
      });
    }
  }

  Widget returnPage(bool isSetupCompleted) {
    // if (!introCompleted) {
    //   //Load Introduction Page
    // } else
    if (isSetupCompleted == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'Let\s Vote',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else if (isSetupCompleted) {
      return HomePage();
    }
    return InitializationPage();
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Vote',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //primarySwatch: Colors.blue,
      ),
      home: returnPage(setupCompleted),
    );
  }
}
