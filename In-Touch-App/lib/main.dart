import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intouch/constants.dart';
import 'package:intouch/messageHandler.dart';
import 'package:intouch/constants.dart';
import 'package:intouch/ui/welcomePage.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(InTouchApp());

class InTouchApp extends StatefulWidget {
  @override
  InTouchAppState createState() {
    return new InTouchAppState();
  }
}

class InTouchAppState extends State<InTouchApp> {
  final _messaging = FirebaseMessaging();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  Future<void> _onNotification (Map<String, dynamic> message) async {
    await http.post('${Constants.baseURL}connect/${message['data']['id']}',
        headers: { 'Authorization': 'Bearer ' + ((await (await _auth.currentUser()).getIdToken()).token),
          'Content-Type': 'application/json' });
  }

  @override
  void initState() {
    super.initState();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // not sure what we're doing here
      },
      onBackgroundMessage: messageHandler,
      onLaunch: _onNotification,
      onResume: _onNotification
    );

    _messaging.onTokenRefresh.listen((String token) async {
      print('new token: $token');
      var currentUser = await _auth.currentUser();
      if (currentUser == null) return;

      var uid = currentUser.uid;

      var userDoc = await _firestore.document('users/$uid').get();
      if (!(userDoc.data['verified'] ?? false)) return;

      await _firestore.document('users/$uid').updateData({
        'fcmtokens': FieldValue.arrayUnion([token])
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.indigo,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: Constants.name,
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: WelcomeScreen(),
        );
      },
    );
  }
}
