import 'dart:io';
import 'package:Logistic/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:lbn_flutter_project/SplashScreen.dart';
// import 'package:lbn_flutter_project/lists/EditLeadershipTeam.dart';
// import 'package:lbn_flutter_project/singletons/userdata_singleton.dart';
// import 'package:lbn_flutter_project/utils/push_notification_service.dart';
// import 'package:lbn_flutter_project/widgets/app_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
  HttpOverrides.global = new MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MyApp> {
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  SharedPreferences? prefs;

  @override
  void initState() {
    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('@mipmap/launcher_icon');
    // var initializationSettingsIOS = new DarwinInitializationSettings();
    // var initializationSettings = new InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (payload) {
    //     showDialog(
    //       context: context,
    //       builder: (_) {
    //         return new AlertDialog(
    //           title: Text("PayLoad"),
    //           content: Text("Payload : $payload"),
    //         );
    //       },
    //     );
    //   },
    //   // onSelectNotification:
    // );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // UserDataService().userPic = prefs.getString("pic") ?? '';
      // UserDataService().imgPath = prefs.getString("imagePath") ?? '';
      // UserDataService().userID = prefs.getString("personid") ?? '';
    });

    super.initState();
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_ID', 'channel name',
            importance: Importance.max,
            playSound: true,
            // sound: 'sound',
            showProgress: true,
            priority: Priority.high,
            ticker: 'test ticker');

    var iOSChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    // await flutterLocalNotificationsPlugin
    //     .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  @override
  Widget build(BuildContext context) {
    // PushNotificationService().initialise();
    // FirebaseMessaging.instance.getToken().then((value) async {
    //   String token = value!;
    //   print('fcm token-->' + token.toString());
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setString('token', token);
    // });
    // FirebaseMessaging.onMessage.listen((message) async {
    //   showNotification(
    //       message.notification!.title!, message.notification!.body!);
    //   print("onMessage: $message");
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.notification!.body}');
    //   // ignore: unrelated_type_equality_checks
    //   final prefs = await SharedPreferences.getInstance();
    //   if (message.notification!.body == 'Your Account is disable now.') {
    //     prefs.remove('personid');
    //     prefs.remove('firstname');
    //     prefs.remove('lastname');
    //     prefs.remove('pic');
    //     prefs.setBool('islogin', false);
    //     prefs.remove('versionMesssage');
    //     prefs.remove('versionNo');
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (BuildContext context) => Welcomepage()),
    //         (Route<dynamic> route) => false);
    //   }
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Logistic App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
