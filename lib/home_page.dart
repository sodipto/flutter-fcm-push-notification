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
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = IOSInitializationSettings();

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    _notification = FlutterLocalNotificationsPlugin();

    _notification.initialize(initSetting);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification.title);
      _showNotification(message.notification);
    });
  }

  _showNotification(RemoteNotification notification) async {
    // var androidDetails =
    // AndroidNotificationDetails('1', 'channelName', 'channel Description');
    //
    // var iosDetails = IOSNotificationDetails();
    //
    // var generalNotificationDetails =
    // NotificationDetails(android: androidDetails, iOS: iosDetails);
    //
    // await _notification.show(0, 'title', 'body', generalNotificationDetails,
    //     payload: 'Notification');

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
    _initMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getToken();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'HomePage',
            ),
          ],
        ),
      ),
    );
  }
}