import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_number/phone_number.dart';
import 'dart:math';
import 'package:intouch/constants.dart';
import 'phoneNumberPage.dart';
import 'shared/components.dart';
import 'shared/validators.dart';

class SignUpModel {
  String username;
  String email;
  String password;
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  final _model = new SignUpModel();

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var message;

      try {
        var authResult = await _auth.createUserWithEmailAndPassword(email: _model.email, password: _model.password);
        var user = authResult.user;

        await _firestore.document('users/${user.uid}').setData({
          'displayName': _model.username,
          'verified': false
        });

        Navigator.of(
          context,
        ).push(
          new PageRouteBuilder(
            pageBuilder: (
                BuildContext context,
                _,
                __,
                ) {
              return new PhoneNumberPage();
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
        switch (e.code) {
          case 'ERROR_WEAK_PASSWORD':
            message = 'Password is too weak';
            break;

          case 'ERROR_INVALID_EMAIL':
            message = 'Invalid email';
            break;

          case 'ERROR_EMAIL_ALREADY_IN_USE':
            message = 'Email is already in use';
            break;
        }
      }

      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(message))
      );
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
            children: [
              header(),
              entryField(
                "Email", onSaved: (value) => _model.email = value.trim(),
                validator: emailValidator,
              ),
              entryField(
                "Password",
                isPassword: true, onSaved: (value) => _model.password = value,
              ),
              entryField(
                "Display Name", onSaved: (value) => _model.username = value.trim(),
                validator: displayNameValidator,
              ),
              register(),
            ],
          ),
        ),
      ),
    );
  }


  Widget register() {
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
          'Next',
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
            "SIGN-UP TO " + Constants.name + "!",
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
