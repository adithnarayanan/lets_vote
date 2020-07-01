import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const _kGoogleApiKey = 'AIzaSyAoMEzR-M4-xZ2DyRWi8eYa-xMPlQVpHf8';

class CandidatesCacheManager extends BaseCacheManager {
  static const key = 'customCache';

  static CandidatesCacheManager _instance;

  factory CandidatesCacheManager() {
    if (_instance == null) {
      _instance = new CandidatesCacheManager();
    }
    return _instance;
  }

  CandidatesCacheManager._() : super(key, maxAgeCacheObject: Duration(days: 7));

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }
}

class Candidate {
  String name;
  String officeName;
  String photoUrl;
  String party;

  Candidate(this.name, this.officeName, this.photoUrl, this.party);
}

class CurrentCandidatesPage extends StatefulWidget {
  @override
  _CurrentCandidatesPageState createState() => _CurrentCandidatesPageState();
}

//TODO use cached images?
//TODO use ListView.builder
//TODO cache manager default - 7 days
class _CurrentCandidatesPageState extends State<CurrentCandidatesPage> {
  List<Candidate> candidates = [];
  String response;
  String address;

  Future<String> getAddress() async {
    String keyName = 'address';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = (prefs.getString(keyName));
    //print(address);
    return address;
  }

  sendGetRequest(String address_input) async {
    //String address = await getAddress();
    String formatted_address = address_input.replaceAll(new RegExp(' '), '%20');
    String url =
        'https://www.googleapis.com/civicinfo/v2/representatives?key=' +
            _kGoogleApiKey +
            '&address=' +
            formatted_address;
    //address;
    print(url + 'url');
    var file = await CandidatesCacheManager._().getSingleFile(url);
    //print(response.body);
    var res = file.readAsString();
    return res;
  }

  _photoUrlExists(photoUrl) {
    if (photoUrl != null) {
      return NetworkImage(photoUrl);
    }
    return AssetImage('assets/AmericanFlagStar.png');
  }

  _buildListView(String response_input) {
    // print('response' + response_input.toString());

    if (response_input != null) {
      //print('response' + response.body.toString());
      var offices = jsonDecode(response_input)['offices'];
      var offices_length = offices.length;
      var officialsBody = jsonDecode(response_input)['officials'];
      int length = officialsBody.length;
      print(length.toString() + 'length');

      //List<Card> representativeCards = new List<Card>();

      for (var i = 0; i < offices_length; i++) {
        String officeName = offices[i]['name'];
        var officials = offices[i]['officialIndices'];
        //int officials_length = officials.length;
        for (var x = 0; x < officials.length; x++) {
          int index = officials[x];
          String name = officialsBody[index]['name'];
          String party = officialsBody[index]['party'];
          if (party == 'Republican Party') {
            party = 'R';
          } else if (party == 'Democratic Party') {
            party = 'D';
          }
          String photoUrl = officialsBody[index]['photoUrl'];
          //print(officeName + ': ' + name + ' ' + ' ' + party + ' ');

          candidates.add(new Candidate(name, officeName, photoUrl, party));
          // representativeCards.add(
          //   Card(
          //     child: ListTile(
          //       leading: CircleAvatar(
          //         radius: 20.0,
          //         backgroundImage: _photoUrlExists(photoUrl),
          //       ),
          //       title: Text(name),
          //       subtitle: Text(officeName + ' - ' + party),
          //     ),
          //   ),
          // );
        }
      }

      return new ListView.builder(
        shrinkWrap: true,
        itemCount: candidates.length,
        itemBuilder: (BuildContext context, int index) {
          Candidate candidate = candidates[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.amber.shade700,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: _photoUrlExists(candidate.photoUrl),
                ),
                title: Text(
                  candidate.name,
                  //style: TextStyle(color: Colors.grey),
                ),
                subtitle: Text('${candidate.officeName} - ${candidate.party}'),
              ),
            ),
          );
        },
      );

      // return ListView(
      //   shrinkWrap: true,
      //   padding: const EdgeInsets.all(8),
      //   children: <Widget>[
      //     ...representativeCards,
      //   ],
      // );
    }
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 5,
    ));
  }

  void setAddress() async {
    address = await getAddress().then((value) {
      setResponse(value);
      return value;
    });
  }

  void setResponse(address_input) async {
    String httpResponse;
    try {
      httpResponse = await sendGetRequest(address_input);
      print(httpResponse);
    } catch (error) {
      print('error: + $error');
    } finally {
      print('exeucting finally');
      setState(() {
        response = httpResponse;
        print(response);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setAddress();

    //response = sendGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle topStyle = TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
    );
    TextStyle messageText = TextStyle(
      fontSize: 14,
      color: Colors.grey.shade800,
    );
    const TextStyle headerStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    const TextStyle locationStyle = TextStyle(
      fontSize: 16,
    );

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(00, 40, 0, 0),
            child: Text(
              'Your Representatives',
              style: topStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: 20.0,
              width: 150.0,
              child: Divider(
                thickness: 3,
                color: Colors.teal.shade100,
              ),
            ),
          ),
          //buildCurrentRepresentativesView(),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
          //   child: Card(
          //     child: ListTile(
          //       leading: CircleAvatar(
          //         radius: 20.0,
          //         backgroundImage: AssetImage('assets/Republican.png'),
          //       ),
          //       title: Text('Donald J. Trump'),
          //       subtitle: Text('President of the United States - R'),
          //     ),
          //   ),
          // ),
          Expanded(
            child: _buildListView(response),
          ),
        ],
      ),
    );
  }
}
