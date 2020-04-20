import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch/ui/homePage.dart';
import 'package:intouch/ui/signUpPage.dart';
import 'package:intouch/ui/loginPage.dart';
import 'dart:math';
import 'package:intouch/constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  Future<bool> future;

  void initState() {
    future = _auth.currentUser().then((user) {
      if (user == null) {
        return false;
      }
      return _firestore.document('users/${user.uid}').get()
        .then((doc) {
          if (!doc.exists) {
            return false;
          }
          if (doc.data['verified'] == false) {
            return false;
          }
          return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return HomeScreen();
          } else {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      Constants.secondaryColor,
                      Constants.mainColor,
                    ],
                  ),
                ),
                child: Center(
                  child: new ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40,
                    ),
                    children: [
                      header(),
                      signInButton(),
                      signUpButton()
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return new CircularProgressIndicator();
        }
      });
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
              color: Colors.black87,
            ),
          ),
          Text(
            "WELCOME TO " + Constants.name + "!",
            style: TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget signInButton() {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(
          new PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              _,
              __,
            ) {
              return new LoginPage();
            },
            transitionsBuilder: (
              _,
              Animation<double> animation,
              __,
              Widget child,
            ) {
              return new FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 13,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              5,
            ),
          ),
          color: Colors.white,
        ),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Constants.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(
          new PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              _,
              __,
            ) {
              return new SignUpPage();
            },
            transitionsBuilder: (
              _,
              Animation<double> animation,
              __,
              Widget child,
            ) {
              return new FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 13,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              5,
            ),
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
