import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_initialization_page.dart';
import 'party_initialization_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String party;
  String address;

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

  void getPreferences() async {
    String temp_party;
    String temp_address;
    String temp_id;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle topStyle = TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
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
          Card(
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text('Party: $party'),
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
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Address: $address'),
              //trailing: Icon(Icons.arrow_forward_ios),
              trailing: FlatButton(
                child: Text('Edit',
                    style: TextStyle(fontSize: 15, color: Colors.blue)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddressIntitializationPage()),
                  );
                },
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          //   child: Card(
          //     child: ListTile(
          //       leading: Icon(Icons.bookmark),
          //       title: Text('Favorite Candidates'),
          //       trailing: Icon(Icons.arrow_forward_ios),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
