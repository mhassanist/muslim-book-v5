import 'dart:async';
import 'dart:io';

import 'package:base_app/islamic_feature/views/islamic_post_details_from_notification.dart';
import 'package:base_app/models/push_notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin flutterNotification =
      FlutterLocalNotificationsPlugin();

   //PushNotificationModel notificationModel = PushNotificationModel();
    static Data data = Data();

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> massage) async {
    String title = massage['data']['title'];
    String body = massage['data']['body'];
    String postId = massage['data']['post_id'];
    data.title = title;
    data.body = body;
    data.postId = postId;
      //LocalDataStore().saveNotificationType(notificationModel.data.notificationType);
    try {
      await _showNotification(data);
    }catch(e){
      print(e);
    }

    // Or do other work.
  }

  Future initialise() async {
    await _fcm.requestNotificationPermissions();
    if (Platform.isIOS) {
      //_fcm.requestPermission();
    }
    await _fcm.subscribeToTopic('muslim').then((value) {
      print('value');
    }).catchError((error){
      print('subscribeToTopic Errorrrrrrrr: '+ error.toString());
    });
    await _fcm.getToken().then((value) {
      print('Android token:  $value');
    });

    _fcm.configure(
      onBackgroundMessage: myBackgroundMessageHandler,

      onMessage: (Map<String, dynamic> massage)  async{
        String title = massage['data']['title'];
        String body = massage['data']['body'];
        String postId = massage['data']['post_id'];
          print("onMessage: $massage");
        data.title = title;
        data.body = body;
        data.postId = postId;

        _showNotification(data);
      },
      onLaunch: (Map<String, dynamic> massage) async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Timer(const Duration(seconds: 7), () {
            print("onLaunch");
          });
        });
        String title = massage['data']['title'];
        String body = massage['data']['body'];
        String postId = massage['data']['post_id'];
        data.title = title;
        data.body = body;
        data.postId = postId;
          print("onLaunch");

        //LocalDataStore().saveNotificationType(notificationModel.data.notificationType);
        _showNotification(data);
      },
      onResume: (Map<String, dynamic> massage) async {
        String title = massage['data']['title'];
        String body = massage['data']['body'];
        String postId = massage['data']['post_id'];
        data.title = title;
        data.body = body;
        data.postId = postId;
          print("onResume");


        _showNotification(data);
      },
    );
  }

  Future initNotification(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
         AndroidInitializationSettings('app_not_logo');
    final IOSInitializationSettings iOSInitialize =  IOSInitializationSettings(onDidReceiveLocalNotification:onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationsSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: iOSInitialize,
        macOS: initializationSettingsMacOS);
    await flutterNotification
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    await flutterNotification.initialize(initializationsSettings,
        onSelectNotification: (String payload)=>
            notificationSelected(payload, context));
  }

  void _handleNavigation(BuildContext context, String payload) {
    try{
      Navigator.push(context, MaterialPageRoute(builder: (context) => IslamicPostDetailsFromNotification(payload)));
      flutterNotification.cancelAll();

    }catch(e){
      print(e);
    }

        //Navigator.push(
            //context, MaterialPageRoute(builder: (context) => ReceiverScreen()));

  }

  static Future _showNotification(
      Data notificationModel
      ) async {
    AndroidNotificationDetails androidDetails = new AndroidNotificationDetails("channelId",
        notificationModel.title, notificationModel.body,
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        autoCancel: false,
        ongoing: true);

    var iosDetails = new IOSNotificationDetails(presentSound: true);
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterNotification.show(0, notificationModel.title,
        notificationModel.body, generalNotificationDetails,
        payload: notificationModel.postId);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    //notificationModel.data = data;
    //notificationModel.data.title = title;
    //notificationModel.data.description = body;
    print("IOS: $payload");
    //_handleNavigation(context,notificationModel.data.notificationType);
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  Future notificationSelected(String payload, BuildContext context, ) async{
    if (payload != null) {
      debugPrint('notification payload: $payload');

        //await Navigator.push(context, MaterialPageRoute(
          //  builder: (context) => IslamicPostDetailsFromNotification(payload)));
  }
    _handleNavigation(context,payload);
  }
}
