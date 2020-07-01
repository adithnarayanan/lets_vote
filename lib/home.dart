import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/ballot_page.dart';
import 'package:lets_vote/dashboard_page.dart';
import 'package:lets_vote/profile_page.dart';
import 'package:lets_vote/voting_page.dart';

import 'current_candidates_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _renderPage = <Widget>[
    CurrentCandidatesPage(),
    BallotPage(),
    DashboardPage(),
    VotingPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const bottomNavColor = Colors.black;

    return Scaffold(
      // backgroundColor: Colors.black,
      body: _renderPage.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            title: Text('Reps'),
            backgroundColor: bottomNavColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            title: Text('Ballot'),
            backgroundColor: bottomNavColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            backgroundColor: bottomNavColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumbs_up_down),
            title: Text('Voting'),
            backgroundColor: bottomNavColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            backgroundColor: bottomNavColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade700,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
