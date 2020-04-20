import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class CallHistoryScreen extends StatefulWidget {
  @override
  _CallHistoryScreenState createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  List<Call> _calls = List();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  List<MaterialColor> callColors = <MaterialColor>[];
  final random = Random();

  @override
  void initState() {
    createCallingColors();
    super.initState();
  }

  Future<List<DocumentSnapshot>> getData() async {
    List<Call> calls;
    var currentUser = await _auth.currentUser();
    var uid = currentUser.uid;

    return _firestore.collection('users/$uid/calls').getDocuments().then((x) => x.documents);
  }

  void createCallingColors() {
    callColors.add(Colors.orange);
    callColors.add(Colors.purple);
    callColors.add(Colors.blue);
    callColors.add(Colors.deepOrange);
    callColors.add(Colors.lightGreen);
    callColors.add(Colors.lightBlue);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          final children = <Widget>[];
          final dbCalls = snapshot.data;


          for (final call in dbCalls) {
            print(call.data['number']);
            _calls.add(
                Call(
                    from: call.data['number'],
                    callTime: new DateTime.fromMillisecondsSinceEpoch(call.data['time'].millisecondsSinceEpoch)
                      .toString()
                )
            );
          }

          children.add(header());

          for (var i = 0; i < _calls.length; i++) {
            children.add(buildCall(i));
          }

          return Scaffold(
            body: Container(
              child: Center(
                child: new ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  children: children,
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }

  Widget buildCall(int index) {
    return InkWell(
      onTap: () => launch("tel://" + _calls[index].from),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                '${_calls[index].from}',
              ),
              subtitle: Text(
                '${_calls[index].callTime}',
              ),
            ),
          ),
          Icon(
            Icons.add_call,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget header() {
    final _media = MediaQuery.of(
      context,
    ).size;

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Center(
            child: Icon(
              Icons.call,
              size: min(
                _media.width / 3,
                _media.height / 3,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'CALL HISTORY',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              fontSize: _media.width / 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class Call {
  String from;
  String callTime;
  MaterialColor backgroundColor;

  Call({this.from, this.callTime, this.backgroundColor});
}
