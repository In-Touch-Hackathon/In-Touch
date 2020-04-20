import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intouch/ui/homePage.dart';
import 'dart:math';
import 'package:intouch/constants.dart';

import 'phoneNumberPage.dart';
import 'homePage.dart';
import 'shared/components.dart';

class LoginModel {
  String email;
  String password;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _model = new LoginModel();

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final _messaging = FirebaseMessaging();


  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var message;
      var verified = true;
      try {
        var result = await _auth.signInWithEmailAndPassword(email: _model.email, password: _model.password);
        var uid = result.user.uid;

        var userDoc = await _firestore.document('users/$uid').get();
        if (!userDoc.data['verified']) {
          verified = false;
          message = 'Redirecting to phone verification';
        } else {
          var registrationToken = await _messaging.getToken();
          await _firestore.document('users/$uid').updateData({
            'fcmTokens': FieldValue.arrayUnion([registrationToken])
          });
          message = 'Logged in';
        }

      } on PlatformException catch (e) {
        switch (e.code) {
          case 'ERROR_USER_NOT_FOUND':
          case 'ERROR_WRONG_PASSWORD':
            message = 'Invalid email or password';
            break;

          case 'ERROR_INVALID_EMAIL':
            message = 'Invalid email';
            break;

          case 'ERROR_TOO_MANY_REQUESTS':
            message = 'There have been too many failed sign in attempts, please try again later';
            break;

          case 'ERROR_USER_DISABLED':
            message = 'Your account is locked';
            break;

          default:
            message = 'An unexpected error has occurred';
            break;
        }
      }

      print(verified);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(message),
        onVisible: () {
          if (message == 'Logged in' ||
              message == 'Redirecting to phone verification') {
            Navigator.of(
              context,
            ).push(
              new PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    _,
                    __,) {
                  return verified ? HomeScreen() : PhoneNumberPage();
                },
                transitionsBuilder: (_,
                    Animation<double> animation,
                    __,
                    Widget child,) {
                  return new FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Form(
          key: _formKey,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              left: 40.0,
              right: 40,
            ),
            children: <Widget>[
              header(),
              entryField("Email",
                  onSaved: (value) => _model.email = value.trim()),
              entryField("Password",
                  onSaved: (value) => _model.password = value,
                  isPassword: true),
              login(),
            ],
          ),
        ),
      ),
    );
  }

  Widget login() {
    return Container(
      width: MediaQuery.of(
        context,
      ).size.width,
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 30,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(
              context,
            ).focusColor,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Constants.secondaryColor,
            Constants.mainColor,
          ],
        ),
      ),
      child: InkWell(
        onTap: _submitForm,
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
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
          Center(
            child: Icon(
              Icons.group,
              size: min(
                _media.width / 2,
                _media.height / 2,
              ),
            ),
          ),
          Text(
            "LOG-IN TO " + Constants.name + "!",
            style: TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
