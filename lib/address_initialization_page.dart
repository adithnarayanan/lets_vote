import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:lets_vote/animations.dart';
import 'package:lets_vote/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'ballot.dart';
import 'election.dart';

const _kGoogleApiKey = 'AIzaSyAoMEzR-M4-xZ2DyRWi8eYa-xMPlQVpHf8';

class AddressIntitializationPage extends StatefulWidget {
  @override
  _AddressIntitializationPageState createState() =>
      _AddressIntitializationPageState();
}

class _AddressIntitializationPageState extends State<AddressIntitializationPage>
    with SingleTickerProviderStateMixin {
  //TODO Highlights added, however, 1st container loses value after - Either use bottom container for both address output or use Text editing controller - DONE
  //TODO add Shared Preferences - DONE
  //TODO add circular progress indicator when loading - DONE

  bool validation = true;
  bool isLoading = false;
  Animation<double> animation1;
  AnimationController controller;
  bool moveToNextPage = false;
  String address = '';
  String deviceId;
  int whichAddress =
      0; // 0 is neither, 1 is top(form), 2 is using current location button

  setAddress(String addressInput) async {
    String keyName = 'address';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, addressInput).then((value) async {
      String formattedAddress = addressInput.replaceAll(new RegExp(' '), '+');

      String saveUrl =
          'https://api.wevoteusa.org/apis/v1/voterAddressSave/?voter_device_id=' +
              deviceId +
              '&text_for_map_search=' +
              formattedAddress +
              '&simple_save=true';
      print(saveUrl);
      var response = await http.get(saveUrl);
      print(response.body);
      print('finished saving address');
    });
  }

  setStateCode(String stateCode) async {
    String keyName = 'stateCode';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, stateCode);
  }

  Future<String> getDeviceId() async {
    String keyName = 'DeviceId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString(keyName));
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
    }
  }

  void onNextPressed() {
    setAddress(address);
    print('setting address');
  }

  void validate(String addressInput) async {
    bool status;
    String stateCode;
    String formattedAddress = addressInput.replaceAll(new RegExp(' '), '%20');
    String addressNew;

    String url =
        'https://www.googleapis.com/civicinfo/v2/representatives?key=' +
            _kGoogleApiKey +
            '&address=' +
            formattedAddress;
    print(url);

    try {
      http.Response response = await http.get(url);
      //print(response.headers);
      // var officialsBody = jsonDecode(response.body)['officials'];
      // int length = officialsBody.length;
      // print(length);
      //var officialOneName = jsonDecode(response.body)['officials'][13]['name'];
      //print(officialOneName);
      // for (var i = 0; i < length; i++) {
      //   String name = officialsBody[i]['name'];

      //   print(name);
      // }
      if (response.statusCode == 200) {
        status = true;
        var body = jsonDecode(response.body);
        stateCode = body['normalizedInput']['state'];
        //print(stateCode);
        //print(body['normalizedInput']['line1']);
        addressNew = body['normalizedInput']['line1'] +
            ' ' +
            body['normalizedInput']['city'] +
            ', ' +
            body['normalizedInput']['state'];
        print(addressNew);
      } else {
        status = false;
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        validation = status;
        if (!moveToNextPage) {
          moveToNextPage = status;
        }
        if (status) {
          address = addressNew;
          whichAddress = 1;
          setAddress(addressNew);
          print(stateCode);
          setStateCode(stateCode);
        }
        isLoading = false;
      });
    }
  }

  Widget renderAddressBox(bool loading) {
    if (!loading) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 40, 30, 0),
        child: Container(
          decoration: bottomContainerDeocration(whichAddress),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              address,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 5,
      )),
    );
  }

  Widget renderNextButton(bool move) {
    if (move) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                // onNextPressed();
              },
              child: NextPartyAnimation(
                animation: animation1,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Decoration bottomContainerDeocration(int a) {
    if (a == 2 || a == 1) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 2),
        ],
      );
    }
    return null;
  }

  @override
  void initState() {
    Box<Election> electionsBox = Hive.box<Election>('electionBox');
    Box<Ballot> ballotsBox = Hive.box<Ballot>('ballotBox');
    ballotsBox.clear();
    electionsBox.clear();
    DefaultCacheManager().emptyCache();
    //BallotCacheManager().getFilePath()
    super.initState();
    getPreferences();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation1 = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle topStyle = TextStyle(
      fontSize: 50,
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 15, 0),
              child: Text(
                '1. Address',
                style: topStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 15, 20),
              child: Text(
                'In order to give you the most accurate voter information, we require your address of residence. Let\'s Vote will never store this information',
                style: messageText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 15, 0),
              child: Text(
                'Enter Your Address:',
                style: headerStyle,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 30, 15),
              child: Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '123 E. Madison Drive New York, NY',
                    errorText: !validation ? 'Address not valid' : null,
                  ),
                  onFieldSubmitted: (value) {
                    validate(value);
                    print('submitted');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 30, 0),
              child: Text(
                'OR',
                style: headerStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Row(
                      children: <Widget>[
                        Text('Use Current Location',
                            style: TextStyle(fontSize: 18)),
                        Icon(Icons.location_on)
                      ],
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      Position position = await Geolocator().getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      List<Placemark> placemark = await Geolocator()
                          .placemarkFromCoordinates(
                              position.latitude, position.longitude);

                      Placemark place = placemark[0];
                      print(place.subThoroughfare);
                      String fetchedAddress = place.subThoroughfare +
                          ' ' +
                          place.thoroughfare +
                          ' ' +
                          place.locality +
                          ', ' +
                          place.administrativeArea;
                      setState(() {
                        //address = fetched_address;
                        validate(fetchedAddress);
                      });
                    },
                  ),
                ],
              ),
            ),
            renderAddressBox(isLoading),
            renderNextButton(moveToNextPage)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
