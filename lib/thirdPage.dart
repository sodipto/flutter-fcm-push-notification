import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  _initMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Thir page notification Data -----" + message.notification.title);
      //_showNotification(message.notification);
    });

  }

  @override void initState() {
    //_initMessaging();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third  Page notification data"),
      ),
      body: Center(child: Text("Third Page")),
    );
  }
}

