import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lets_vote/ballot.dart';
import 'package:lets_vote/candidate.dart';
import 'package:lets_vote/election.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lets_vote/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'initialization_page.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const electionBoxName = 'electionBox';
const ballotBoxName = 'ballotBox';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Election>(ElectionAdapter());
  Hive.registerAdapter<Candidate>(CandidateAdapter());
  Hive.registerAdapter<Ballot>(BallotAdapter());
  await Hive.openBox<Election>(electionBoxName);
  await Hive.openBox<Ballot>(ballotBoxName);
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
      return HomePage(
        selectedIndex: 2,
      );
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

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
