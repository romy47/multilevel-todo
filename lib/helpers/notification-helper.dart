import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  static BuildContext context;

  NotificationHelper() {
    initializedNotification();
  }

  initializedNotification() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payLoad) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OKay'),
                  onPressed: () {
                    // do something here
                  },
                )
              ],
            ));
  }

  Future<void> showNotificationBtweenInterval(String title, String body) async {
    // await initSharedPrefs();
    // await notificationCompare();

    var now = DateTime.now();
    var currentTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    // var a = sharedPreferences.getString('startTime');
    // var b = sharedPreferences.getString('endTime');
    // print(a);
    // print(b);
    // print(currentTime);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_Id',
      'Channel Name',
      'Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      ticker: 'test ticker',
      playSound: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // if (DateTime.parse(a).millisecondsSinceEpoch >
    //     currentTime.millisecondsSinceEpoch) {
    //   print(
    //       "current Time is less than startTime so  , Cannot play notification");
    //   await flutterLocalNotificationsPlugin.cancel(0);
    // }

    // if (currentTime.millisecondsSinceEpoch >=
    //         DateTime.parse(a).millisecondsSinceEpoch &&
    //     currentTime.millisecondsSinceEpoch <=
    //         DateTime.parse(b).millisecondsSinceEpoch) {
    print('play notification');
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
    // }

    // if (currentTime.millisecondsSinceEpoch >
    //     DateTime.parse(b).millisecondsSinceEpoch) {
    //   print(
    //       "current time is greater than end time so, cannto play notification");
    //   await flutterLocalNotificationsPlugin.cancel(0);
    // }
  }

  // Future notificationCompare() async {
  //   await initSharedPrefs();
  //   var now = DateTime.now();
  //   var currentTime =
  //       DateTime(now.year, now.month, now.day, now.hour, now.minute);

  //   // var a = sharedPreferences.getString('startTime');
  //   // var b = sharedPreferences.getString('endTime');

  //   // var onlyCurrentDate = currentTime.toString().substring(0, 10);
  //   // var onlyStartDate = a.toString().substring(0, 10);
  //   // var onlyEndDate = b.toString().substring(0, 10);

  //   if (onlyEndDate == onlyCurrentDate && onlyStartDate == onlyCurrentDate) {
  //     print("same date");
  //     print(a.substring(11, 13));
  //   } else {
  //     print('date different');
  //     String startHour = a.substring(11, 13);
  //     String endHour = b.substring(11, 13);
  //     var setStart =
  //         DateTime(now.year, now.month, now.day, int.parse(startHour), 00);
  //     await setStartTime(setStart);
  //     var setEnd =
  //         DateTime(now.year, now.month, now.day, int.parse(endHour), 00);
  //     await setEndTime(setEnd);
  //   }
  // }

  // Future initSharedPrefs() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  // }
}
