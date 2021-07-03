import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("প্রথম পেইজ"),
      ),
      body: Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("যখন অ্যাপ টি ওপেন অবস্থাই নটিফিকেশনে ক্লিক করা হয়, তখন এই পেইজ এ চলে আসে |"),
      )),
    );
  }
}
