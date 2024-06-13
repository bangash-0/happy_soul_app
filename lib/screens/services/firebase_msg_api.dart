import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:happy_soul/main.dart';
import 'package:happy_soul/screens/comfort_box.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    /*
    final fCMTOken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMTOken');
     */

    initPushNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    navigatorKey.currentState!.pushNamed(ComfortBox.id);
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
  }
}

// call this method from where you want to send notification to other device, this only require the fcm token of the device
void sendFCMNotification(String token, String msg) async {
  String accessToken = await getAccessToken();
  var url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/happysoul-bb5a3/messages:send');

  var headers = {
    'Authorization':
    'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  var body = jsonEncode({
    "message": {
      "token": token,
      "notification": {
        "title": "Consultation Request",
        "body": msg
      }
    }
  });

  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print("FCM notification sent successfully.");
  } else {
    print(
        "Failed to send FCM notification. Status code: ${response.statusCode}");
  }
}

Future<String> getAccessToken() async {
  var accountCredentails = {};
  String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";
  final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(accountCredentails),
      [firebaseMessagingScope]);


  final accessToken = await client.credentials.accessToken.data;

  return accessToken;
}
