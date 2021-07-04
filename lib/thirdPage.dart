import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Third Page notification Data -----" + message.notification.title);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("তৃতীয় পেইজ"),
      ),
      body: Center(child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("যখন অ্যাপ টি Terminated অবস্থাই নটিফিকেশনে  ক্লিক করা হয়, তখন এই পেইজ এ চলে আসে |"),
      )),
    );
  }
}

