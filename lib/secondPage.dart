import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("দ্বিতীয় পেইজ"),
      ),
      body: Center(child: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Text("যখন অ্যাপ টি Background অবস্থাই নটিফিকেশনে  ক্লিক করা হয়, তখন এই পেইজ এ চলে আসে | "),
      )),
    );
  }
}
