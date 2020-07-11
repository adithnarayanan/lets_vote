import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lets_vote/election.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'candidate.dart';
import 'election_page.dart';

class CandidatePage extends StatefulWidget {
  Candidate candidate;
  int electionIndex;
  int candidateIndex;
  CandidatePage(
      {Key key, this.candidate, this.electionIndex, this.candidateIndex})
      : super(key: key);

  @override
  _CandidatePageState createState() =>
      _CandidatePageState(candidate, electionIndex, candidateIndex);
}

class _CandidatePageState extends State<CandidatePage> {
  Candidate candidate;
  int electionIndex;
  int candidateIndex;
  _CandidatePageState(this.candidate, this.electionIndex, this.candidateIndex);

  Box<Election> electionsBox;
  Election election;

  _photoUrlExists(photoUrl) {
    if (photoUrl != null) {
      return NetworkImage(photoUrl);
    }
    return AssetImage('assets/AmericanFlagStar.png');
  }

  _descriptionExists(input) {
    if (input != null) {
      return input;
    }
    return '';
  }

  _trailingButton() {
    if (candidateIndex == election.chosenIndex) {
      return FlatButton(
        child: Icon(Icons.remove_circle_outline),
        onPressed: () {
          setState(() {
            election.chosenIndex = null;
            election.save();
          });
        },
      );
    }
    return FlatButton(
      child: Icon(Icons.add_circle_outline),
      onPressed: () {
        setState(() {
          election.chosenIndex = candidateIndex;
          election.save();
        });
      },
    );
  }

  _color(int index) {
    if (candidateIndex == election.chosenIndex) {
      return Colors.green;
    }
    return Colors.amber.shade700;
  }

  @override
  void initState() {
    super.initState();
    electionsBox = Hive.box('electionBox');
    election = electionsBox.getAt(electionIndex);
  }

  _candidateListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
      child: Card(
        color: _color(candidateIndex),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: _photoUrlExists(candidate.photoUrl),
          ),
          title: Text(
            candidate.name,
            //style: TextStyle(color: Colors.grey),
          ),
          subtitle: Text('${candidate.party}'),
          // isThreeLine: true,
          trailing: _trailingButton(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _candidateListTile(),
              // CircleAvatar(
              //   radius: 50.0,
              //   backgroundImage: _photoUrlExists(candidate.photoUrl),
              // ),
              // Text(
              //   candidate.name,
              //   style: TextStyle(
              //     //fontFamily: 'Pacifico',
              //     fontSize: 30.0,
              //     //color: Colors.white,
              //   ),
              // ),
              // Text(
              //   candidate.party,
              //   style: TextStyle(
              //     fontFamily: 'SourceSansPro',
              //     fontSize: 20.0,
              //     // color: Colors.teal.shade900,
              //     //letterSpacing: 2.5,
              //     //fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(
              //   height: 20.0,
              //   width: 150.0,
              //   child: Divider(
              //     thickness: 3,
              //     color: Colors.teal.shade100,
              //   ),
              // ),
              // // Card(
              // //   color: Colors.white,
              // //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              // //   //padding: EdgeInsets.all(10.0),
              // //   child: ListTile(
              // //     // leading: Icon(
              // //     //   Icons.account_box,
              // //     //   //color: Colors.teal,
              // //     // ),
              // //     title:
              // Text(
              //   _descriptionExists(candidate.description),
              //   style: TextStyle(
              //     //color: Colors.teal.shade900,
              //     fontFamily: 'SourceSansPro',
              //     fontSize: 15.0,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              //   ),
              // ),
              Expanded(
                child: WebView(
                  initialUrl: candidate.ballotopediaUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              )
              // Card(
              //   color: Colors.white,
              //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              //   // padding: EdgeInsets.all(10.0),
              //   child: ListTile(
              //     leading: Icon(
              //       Icons.email,
              //       color: Colors.teal,
              //     ),
              //     title: Text(
              //       'adith85086@gmail.com',
              //       style: TextStyle(
              //         color: Colors.teal.shade900,
              //         fontFamily: 'SourceSansPro',
              //         fontSize: 18.0,
              //       ),
              //     ),
              //   ),
              // ),
              ,
              FlatButton(
                child: Row(children: [
                  Icon(Icons.arrow_back_ios),
                  Text('Back to Election')
                ]),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ElectionPage(
                              election: election,
                              electionIndex: electionIndex,
                            )),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
