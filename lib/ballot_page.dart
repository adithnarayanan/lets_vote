import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'candidate.dart';
import 'election.dart';
import 'election_page.dart';

class BallotCacheManager extends BaseCacheManager {
  static const key = 'customCache';

  static BallotCacheManager _instance;

  factory BallotCacheManager() {
    if (_instance == null) {
      _instance = new BallotCacheManager();
    }
    return _instance;
  }

  BallotCacheManager._() : super(key, maxAgeCacheObject: Duration(days: 7));

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }
}

// class Election {
//   String name;
//   int id;
//   String officeLevel;
//   List<Candidate> candidates;

//   Election(this.name, this.id, this.officeLevel, this.candidates);
// }

class BallotPage extends StatefulWidget {
  @override
  _BallotPageState createState() => _BallotPageState();
}

class _BallotPageState extends State<BallotPage> {
  List<Election> elections;
  String deviceId;

  Future<String> sendBallotRequest(String voterId) async {
    var response;
    try {
      String sendUrl =
          'https://api.wevoteusa.org/apis/v1/voterBallotItemsRetrieve/?&voter_device_id=' +
              voterId;

      print(sendUrl + 'url');
      var file = await BallotCacheManager._().getSingleFile(sendUrl);
      response = file;
      //var res = file.readAsString();
    } catch (error) {
      print(error);
    } finally {
      String res = await response.readAsString();
      organizeElections(res);
    }
  }

  void organizeElections(String response) {
    var jsonParsed = jsonDecode(response);

    if (jsonParsed['success'] == true) {
      int ballotItemLength = jsonParsed['ballot_item_list'].length;

      List<Election> returnElections = [];

      for (var x = 0; x < ballotItemLength; x++) {
        var election = jsonParsed['ballot_item_list'][x];
        int candidateListLength = election['candidate_list'].length;
        if (candidateListLength > 20) {
          candidateListLength = 20;
        }
        List<Candidate> electionCandidates = [];

        List<int> nonRepeatIndexes = [];
        List<String> stringNames = [];

        for (var y = 0; y < candidateListLength; y++) {
          var candidate = election['candidate_list'][y];
          var candidateName = candidate['ballot_item_display_name'];

          if (!stringNames.contains(candidateName)) {
            nonRepeatIndexes.add(y);
            stringNames.add(candidateName);
            // print(stringNames);
          }
        }

        for (var y = 0; y < nonRepeatIndexes.length; y++) {
          var index = nonRepeatIndexes[y];

          var candidate = election['candidate_list'][index];

          if (candidate['withdrawn_from_election'] == false) {
            Candidate addCandidate = new Candidate(
                candidate['ballot_item_display_name'],
                candidate['ballotpedia_candidate_summary'],
                candidate['party'],
                candidate['candidate_photo_url_large'],
                candidate['ballotpedia_candidate_url'],
                candidate['candidate_url'],
                candidate['facebook_url'],
                candidate['twitter_url']);

            electionCandidates.add(addCandidate);
          }
        }

        electionCandidates = electionCandidates.toSet().toList();

        Election addElection = new Election(
            election['ballot_item_display_name'],
            election['id'],
            election['race_office_level'],
            electionCandidates);

        returnElections.add(addElection);
      }
      setState(() {
        elections = returnElections;
        print(elections[0].candidates[0].name);
      });
    }
  }

  _buildElectionsView(List<Election> electionsInput) {
    if (electionsInput != null) {
      // return Center(
      //   child: Text('ELECTIONS RETRIEVED'),
      // );
      return new ListView.builder(
        shrinkWrap: true,
        itemCount: electionsInput.length,
        itemBuilder: (BuildContext context, int index) {
          Election election = electionsInput[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FlatButton(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.amber.shade700,
                child: ListTile(
                  // leading: CircleAvatar(
                  //   radius: 20.0,
                  //   backgroundImage: _photoUrlExists(candidate.photoUrl),
                  // ),
                  title: Text(
                    election.name,
                    //style: TextStyle(color: Colors.grey),
                  ),
                  //subtitle: Text('{$election.officeLevel} Office'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              onPressed: () {
                //open Election Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ElectionPage(election: election)),
                );
              },
            ),
          );
        },
      );
    }
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 5,
    ));
  }

  Future<String> getDeviceId() async {
    String keyName = 'DeviceId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString(keyName));
    //prefs.setElection('Election', new Election('hello', 12, 'Federal', new List<Candidate>() ));
    //print(address);
    print(id);
    return id;
  }

  void getPreferences() async {
    String temp_id;
    try {
      temp_id = await getDeviceId();
    } catch (error) {
      print(error);
    } finally {
      deviceId = temp_id;
      sendBallotRequest(deviceId);
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildElectionsView(elections)),
    );
  }
}
