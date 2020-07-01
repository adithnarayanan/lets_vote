import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'candidate.dart';

class CandidatePage extends StatefulWidget {
  Candidate candidate;
  CandidatePage({Key key, this.candidate}) : super(key: key);

  @override
  _CandidatePageState createState() => _CandidatePageState(candidate);
}

class _CandidatePageState extends State<CandidatePage> {
  Candidate candidate;
  _CandidatePageState(this.candidate);

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
              CircleAvatar(
                radius: 50.0,
                backgroundImage: _photoUrlExists(candidate.photoUrl),
              ),
              Text(
                candidate.name,
                style: TextStyle(
                  //fontFamily: 'Pacifico',
                  fontSize: 30.0,
                  //color: Colors.white,
                ),
              ),
              Text(
                candidate.party,
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 20.0,
                  // color: Colors.teal.shade900,
                  //letterSpacing: 2.5,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                  thickness: 3,
                  color: Colors.teal.shade100,
                ),
              ),
              // Card(
              //   color: Colors.white,
              //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              //   //padding: EdgeInsets.all(10.0),
              //   child: ListTile(
              //     // leading: Icon(
              //     //   Icons.account_box,
              //     //   //color: Colors.teal,
              //     // ),
              //     title:
              Text(
                _descriptionExists(candidate.description),
                style: TextStyle(
                  //color: Colors.teal.shade900,
                  fontFamily: 'SourceSansPro',
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
