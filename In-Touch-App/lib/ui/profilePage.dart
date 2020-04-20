import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:intouch/constants.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:intouch/ui/loginPage.dart';
import 'package:intouch/ui/welcomePage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final _messaging = FirebaseMessaging();
  Future<Map<String, dynamic>> future;

  void _delete() async {
    var currentUser = await _auth.currentUser();
    try {
      await currentUser.delete();
      await _messaging.deleteInstanceID();

      Navigator.of(
        context,
      ).push(
        new PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              _,
              __,
              ) {
            return WelcomeScreen();
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
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('This action requires extra verification, please login and try again'),
          )
        );
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(
          context,
        ).push(
          new PageRouteBuilder(
            pageBuilder: (
                BuildContext context,
                _,
                __,
                ) {
              return LoginPage();
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
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    await _messaging.deleteInstanceID();

    Navigator.of(
      context,
    ).push(
      new PageRouteBuilder(
        pageBuilder: (
            BuildContext context,
            _,
            __,
            ) {
          return WelcomeScreen();
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
  }

  @override
  void initState() {
    super.initState();

    future = _auth.currentUser().then((user) async {
      return _firestore.document('users/${user.uid}').get().then((db) {
        var name = db.data['displayName'] ?? 'Unnamed';
        return { 'user': user, 'name': name };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(
      context,
    ).size;

    return FutureBuilder<Map<String, dynamic>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            body: Container(
              child: Center(
                child: new ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  children: [
                    header(snapshot.data),
                    changeTheme(),
                    disableButton(),
                    logOutButton(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Constants.secondaryColor
            ),
          );
        }
      }
    );
  }

  Widget header(data) {
    final _media = MediaQuery.of(
      context,
    ).size;

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: Icon(
              Icons.person,
              size: min(
                _media.width / 2,
                _media.height / 2,
              ),
            ),
          ),
          Text(
            data['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              fontSize: _media.width / 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            data['user'].email,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 2,
              fontSize: _media.width / 24,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget changeTheme() {
    return Container(
      width: MediaQuery.of(
        context,
      ).size.width,
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 20,
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
            Colors.blueGrey[300],
            Colors.blueGrey
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
        },
        child: Text(
          'Change Theme',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget disableButton() {
    return Container(
      width: MediaQuery.of(
        context,
      ).size.width,
      padding: EdgeInsets.symmetric(
        vertical: 15,
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
            Colors.redAccent[100],
            Colors.red[400],
          ],
        ),
      ),
      child: InkWell(
        onTap: _delete,
        child: Text(
          'Permanently Delete Account',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget logOutButton() {
    return Container(
      width: MediaQuery.of(
        context,
      ).size.width,
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 20,
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
        onTap: _logout,
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
