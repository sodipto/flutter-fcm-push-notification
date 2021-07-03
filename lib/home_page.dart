import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:fcm_push_notification/firstPage.dart';
import 'package:fcm_push_notification/secondPage.dart';
import 'package:fcm_push_notification/thirdPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'observer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final bloc = Bloc();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _notification;
  int _notificationId = 0;

  _getToken() async {
    print(await _messaging.getToken());
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  _initMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("App Onscreen notification Data -----" + message.notification.title);
      _showNotification(message);
    });

    //When app running background, notification click call here
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message != null) {
        print("Background App Notification Click-----:" +
            message.notification.title);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      }
    });

    //When app terminated, notification click call here
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("Terminated App Notification Click-----:" +
            message.notification.title);
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
    _notification.initialize(initSetting,onSelectNotification: onSelectNotification);
  }

  _showNotification(RemoteMessage payload) async {
    print("Call notification----------------");
    bool hasImage= payload.data['hasImage']!=null? payload.data['hasImage']=='true'?true:false:false;
    String largeIconPath="https://via.placeholder.com/48x48";
    BigPictureStyleInformation bigPictureStyleInformation;
    hasImage=hasImage && payload.notification.android.imageUrl!=null && payload.notification.android.imageUrl.isNotEmpty?true:false;

    if(hasImage){
      largeIconPath = await _downloadAndSaveFile (payload.notification.android.imageUrl, 'largeIcon');
      String bigPicturePath = await _downloadAndSaveFile(payload.notification.android.imageUrl, 'bigPicture');
      bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true,
          contentTitle: payload.notification.title,
          htmlFormatContentTitle: true,
          summaryText: payload.notification.body,
          htmlFormatSummaryText: true);
    }

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'id', 'title', 'description',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: true,
        //ongoing: true,
        //enableLights: true,
        //enableVibration: true,
        largeIcon: hasImage?FilePathAndroidBitmap(largeIconPath) : null, //for image show when notification not expand state
        styleInformation: hasImage?bigPictureStyleInformation:BigTextStyleInformation('') //for Large image show when notification expand
    );

    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);

    var platformspecific = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _notification.show(
        _notificationId, payload.notification.title, payload.notification.body, platformspecific,
        payload: jsonEncode(payload.data));

    _notificationId++;
  }

  //When app running onscreen notification click call here
  Future onSelectNotification (String payload) {
    Map<String, dynamic> data = jsonDecode(payload);
    print("App running notification click call--------------------------");
    print(data['id']);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstPage()),
    );
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
    print("Call-----------------------------------------------------");
  }

  @override
  Widget build(BuildContext context) {
    //_getToken();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
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
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdPage()),
                );
              },
              child: Text("Go to Real Time Update Page"),
            ),
          ],
        ),
      ),
    );
  }
}
