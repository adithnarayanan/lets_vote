import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/candidate.dart';

import 'candidate_page.dart';
import 'election.dart';

class ElectionPage extends StatefulWidget {
  Election election;
  ElectionPage({Key key, this.election}) : super(key: key);

  @override
  _ElectionPageState createState() => _ElectionPageState(election);
}

class _ElectionPageState extends State<ElectionPage> {
  Election election;
  _ElectionPageState(this.election);

  _photoUrlExists(photoUrl) {
    if (photoUrl != null || photoUrl == '') {
      return CachedNetworkImageProvider(
        photoUrl,
        //scale: ,
        //placeholder: (context, url) => CircularProgressIndicator(),
        //errorWidget: (context, url, error) => Icon(Icons.error)
      );
    }
    return AssetImage('assets/AmericanFlagStar.png');
  }

  _buildCandidateListView() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: election.candidates.length,
      itemBuilder: (BuildContext context, int index) {
        Candidate candidate = election.candidates[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FlatButton(
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
                subtitle: Text(candidate.party),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CandidatePage(candidate: candidate)),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildCandidateListView()));
  }
}
