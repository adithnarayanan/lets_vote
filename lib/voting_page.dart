import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VotingPage extends StatefulWidget {
  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  String stateCode;
  int status = 0;
  //0 -> YesOrNo
  //1 -> MailInOrInPerson
  //2 -> Webview Vote.org
  //3 -> Map View
  //4 -> Something else

  Future<String> getStateCode() async {
    String keyName = 'stateCode';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = (prefs.getString(keyName));
    //print(address);
    print(code);
    code = code.toLowerCase();
    return code;
  }

  void getPreferences() async {
    String temp_code;
    try {
      temp_code = await getStateCode();
    } catch (error) {
      print(error);
    } finally {
      stateCode = temp_code;
    }
  }

  TextStyle topStyle = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.bold,
  );
  TextStyle messageText = TextStyle(
    fontSize: 14,
    color: Colors.grey.shade800,
  );
  TextStyle headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  TextStyle internalFontStyle = TextStyle(
    fontSize: 20,
    color: Colors.orange.shade400,
    //fontWeight: FontWeight.bold,
  );

  _url(stateCodeInput) {
    if (stateCodeInput != null) {
      return 'https://www.vote.gov/register/' + stateCodeInput;
    }
    return 'https://www.vote.gov/';
  }

  renderYesOrNo() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                'Have you Registered to Vote?',
                style: headerStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                child: Center(
                  child: Container(
                    width: double.maxFinite,
                    //height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.orange.shade400, spreadRadius: 3),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Yes',
                        textAlign: TextAlign.center,
                        style: internalFontStyle,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    status = 1;
                  });
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     'OR',
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                child: Container(
                  width: double.maxFinite,
                  //height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.orange.shade400, spreadRadius: 3),
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: internalFontStyle,
                      )),
                ),
                onPressed: () {
                  setState(() {
                    status = 2;
                    print('setState 2');
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                  'If you are not sure, please press no to check your registration status'),
            )
          ],
        ),
      ),
    );
  }

  renderWebView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: _url(
                    stateCode), //'https://www.vote.gov/register/$stateCode/',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('setState 2');
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Voter Registeration'),
              content: Text('Have you finished registering'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    setState(() {
                      status = 1;
                      print('setting status');
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //do something
                  },
                )
              ],
            ),
            barrierDismissible: true,
          );
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }

  renderInPersonorMailIn() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                'How do you Plan on Voting?',
                style: headerStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                child: Center(
                  child: Container(
                    width: double.maxFinite,
                    //height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.orange.shade400, spreadRadius: 3),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'In-Person',
                        textAlign: TextAlign.center,
                        style: internalFontStyle,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    //render Map-View
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                child: Container(
                  width: double.maxFinite,
                  //height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.orange.shade400, spreadRadius: 3),
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Mail-In',
                        textAlign: TextAlign.center,
                        style: internalFontStyle,
                      )),
                ),
                onPressed: () {
                  setState(() {
                    //render something
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  renderMainPage() {}

  render(int render_input) {
    if (render_input == 0) {
      return renderYesOrNo();
    } else if (render_input == 1) {
      return renderInPersonorMailIn();
    } else if (render_input == 2) {
      return renderWebView();
    } else if (render_input == 3) {
      return renderMainPage();
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
    return render(status);
  }
}
