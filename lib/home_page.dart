import 'package:fcm_push_notification/firstPage.dart';
import 'package:fcm_push_notification/secondPage.dart';
import 'package:fcm_push_notification/thirdPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _notification;
  int notificationId=0;

  _getToken() async {
    print(await _messaging.getToken());
  }

  _initMessaging() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("App Onscreen notification Data -----"+message.notification.title);
      _showNotification(message.notification);
    });

    //When app running background, notification click call here
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      if(message!=null){
        print("Background App Notification Click-----:"+message.notification.title);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      }
    });

    //When app terminated, notification click call here
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if(message!=null){
        print("Terminated App Notification Click-----:"+ message.notification.title);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThirdPage()),
        );
      }
    });
  }

   _initNotification() {
     var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');
     var iosInit = IOSInitializationSettings();
     var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

     _notification = FlutterLocalNotificationsPlugin();
     _notification.initialize(initSetting);
   }
   _showNotification(RemoteNotification notification) async {
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('id', 'title', 'description',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: true);

    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);

    var platformspecific = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _notification.show(notificationId, notification.title, notification.body, platformspecific,
        payload: 'Notification');

    notificationId++;
  }
   _notitficationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    //_notitficationPermission();
    _initNotification();
    _initMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getToken();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ), body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          color: Colors.green,
          onPressed: () async {
            await _messaging.subscribeToTopic('151');
          },
          child: Text("Susbcribe To Topic"),
        ),
        MaterialButton(
          color: Colors.blue,
          onPressed: () async {
            await _messaging.unsubscribeFromTopic('151');
          },
          child: Text("UnSusbcribe To Topic"),
        ),

        MaterialButton(
          color: Colors.orange,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThirdPage()),
            );
          },
          child: Text("Go to Page"),
        )
      ],
    ),
    ),
    );
  }
}
