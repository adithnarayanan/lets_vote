import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lets_vote/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'address_initialization_page.dart';
import 'party_initialization_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String party;
  String address;
  bool isSwitched = false;
  int firstAlert = 7;
  int secondAlert = 7;

  Future<String> getAddress() async {
    String keyName = 'address';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = (prefs.getString(keyName));
    //print(address);
    return address;
  }

  Future<String> getParty() async {
    String keyName = 'partyAffiliation';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String party = (prefs.getString(keyName));
    //print(address);
    return party;
  }

  Future<String> getDeviceId() async {
    String keyName = 'DeviceId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String party = (prefs.getString(keyName));
    //print(address);
    print(party);
    return party;
  }

  Future<int> getFirstAlert() async {
    String keyName = 'firstAlert';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int firstAlert = (prefs.getInt(keyName) ?? 7);
    return firstAlert;
  }

  Future<int> getSecondAlert() async {
    String keyName = 'secondAlert';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int secondAlert = (prefs.getInt(keyName) ?? 7);
    return secondAlert;
  }

  setFirstAlert(int value) async {
    String keyName = 'firstAlert';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyName, value);
  }

  setSecondAlert(int value) async {
    String keyName = 'secondAlert';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyName, value);
  }

  void getPreferences() async {
    String temp_party;
    String temp_address;
    String temp_id;
    bool temp_switch;
    try {
      temp_party = await getParty();
      temp_address = await getAddress();
      temp_id = await getDeviceId();
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        party = temp_party;
        address = temp_address;
      });
    }
  }

  void initAlerts() async {
    firstAlert = await getFirstAlert();
    secondAlert = await getSecondAlert();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
    initAlerts();
  }

  Future _showDialog1() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 30,
            title: new Text("Select Number of Days Before"),
            initialIntegerValue: firstAlert,
            infiniteLoop: true,
          );
        }).then((int value) async {
      if (value != null) {
        setState(() => firstAlert = value);
        await setFirstAlert(value);
        cancelAllNotifications();
        createBallotNotifications();
      }
    });
  }

  Future _showDialog2() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 60,
            title: new Text("Select Number of Days Before"),
            initialIntegerValue: secondAlert,
            infiniteLoop: true,
          );
        }).then((int value) async {
      if (value != null) {
        setState(() => secondAlert = value);
        await setSecondAlert(value);
        cancelAllNotifications();
        createBallotNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle topStyle = TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                'Your Profile',
                style: topStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                  thickness: 3,
                  color: Colors.teal.shade100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: ListTile(
                    leading: Icon(Icons.group),
                    title: Text(
                      'Party: $party',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    //trailing: Icon(Icons.arrow_forward_ios),
                    trailing: FlatButton(
                      child: Text('Edit',
                          style: TextStyle(fontSize: 15, color: Colors.blue)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PartyInitializationPage()),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(
                      'Address: $address',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    //trailing: Icon(Icons.arrow_forward_ios),
                    trailing: FlatButton(
                      child: Text('Edit',
                          style: TextStyle(fontSize: 15, color: Colors.blue)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddressIntitializationPage()),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
              child: Text(
                'NOTIFICATION SETTINGS',
                style: TextStyle(
                  fontSize: 16.0,
                  //color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Card(
                //color: Colors.green,
                child: ListTile(
                  leading: Icon(Icons.notifications_active),
                  title: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      if (!value) {
                        cancelAllNotifications();
                      } else {
                        createBallotNotifications();
                      }
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                // TODO: Fix padding issue between info cards
                children: <Widget>[
                  Card(
                    //margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      enabled: isSwitched,
                      trailing: FlatButton(
                        color: Colors.green.shade200,
                        disabledColor: Colors.white,
                        child: Text(
                          '$firstAlert days',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        padding: EdgeInsets.all(0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: !isSwitched ? null : _showDialog1,
                      ),
                      title: Text(
                        'Days before Registration Deadline Notification',
                        style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //color: Color.fromARGB(35000, 0, 168, 243),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 6.0),
                    child: Text(
                      'Set the number of days before your election registration deadline, that Let\'s Vote will send you a reminder',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Card(
                    //margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      enabled: isSwitched,
                      trailing: FlatButton(
                        disabledTextColor: Colors.grey,
                        color: Colors.green.shade200,
                        disabledColor: Colors.white,
                        child: Text(
                          '$secondAlert days',
                          style: TextStyle(
                            //color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        padding: EdgeInsets.all(0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: !isSwitched ? null : _showDialog2,
                      ),
                      title: Text(
                        'Election Notification',
                        style: TextStyle(
                            // color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //color: Color.fromARGB(35000, 0, 168, 243),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 6.0),
                    child: Text(
                      'Set the number of days before your next election, that Let\'s Vote will send you a reminder',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
