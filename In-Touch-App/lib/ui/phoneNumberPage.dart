import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:intouch/ui/otpVerification.dart';
import 'package:phone_number/phone_number.dart';
import 'package:intouch/constants.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class PhoneNumberModel {
  String code;
  String number;
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _model = PhoneNumberModel();
  final _phoneNumber = PhoneNumber();

  void _submitForm() async {
    _formKey.currentState.save();
    if (_model.number.startsWith('0')) {
      _model.number = _model.number.substring(1);
    }

    var phoneNumber = _model.code + _model.number;
    var message;

    try {
      var parsedPhoneNumber = await _phoneNumber.parse(phoneNumber, region: 'NZ');
      var currentUser = await _auth.currentUser();
      await _firestore.document('users/${currentUser.uid}')
          .setData({ 'phoneNumber': parsedPhoneNumber['e164'] }, merge: true);

      Navigator.of(
        context,
      ).push(
        new PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              _,
              __,
              ) {
            return OTPVerification();
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
      var message;
      switch (e.code) {
        case 'InvalidNumber':
          message = 'Invalid Phone Number';
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                ),
              ),
              phoneNumber(),
              SizedBox(
                height: 40,
              ),
              getVerification(),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneNumber() {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Flexible(
            child: new Container(),
            flex: 1,
          ),
          Flexible(
            child: new TextFormField(
              textAlign: TextAlign.center,
              autofocus: false,
              enabled: false,
              initialValue: "+64",
              onSaved: (value) => _model.code = value,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            flex: 3,
          ),
          Flexible(
            child: new Container(),
            flex: 1,
          ),
          Flexible(
            child: new TextFormField(
              textAlign: TextAlign.start,
              autofocus: false,
              enabled: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSaved: (value) => _model.number = value,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            flex: 9,
          ),
          Flexible(
            child: new Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget getVerification() {
    return InkWell(
      onTap: _submitForm,
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
          'Get Verification Code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              Icons.phonelink_setup,
              size: min(
                _media.width / 2,
                _media.height / 2,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "ENTER YOUR PHONE NUMBER",
            style: TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
