import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'pages/admin_screen.dart';
import 'appt_model.dart';

//Check if Date is Today
bool isToday(String date) {
  DateTime now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == today) {
    return true;
  }

  return false;
}

//Check if Date is Tomorrow
bool isTomorrow(String date) {
  DateTime now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == tomorrow) {
    return true;
  }

  return false;
}

///Function to check if date is today or tomorrow
checkDate(DateTime date) {
  if (isToday(getDate(date))) {
    return "Today";
  }

  if (isTomorrow(getDate(date))) {
    return "Tomorrow";
  }

  return getDate(date);
}

//Function to get Local time
getTime(date) {
  String hour = "${date.toLocal()}".split(' ')[1].split(':')[0];

  String min = "${date.toLocal()}".split(' ')[1].split(':')[1];
  return "$hour:$min";
}

//Function to get Local date
getDate(date) {
  String day = "${date.toLocal()}".split(' ')[0];

  return day;
}

///Send Appointment Notfification To Admin
sendNotificationToAdmin({required Appointment appointment}) async {
  //Our API Key
  var serverKey = dotenv.get('API_KEY');

  //Get our Admin token from Firesetore DB
  var token;
  await apptCollection
      .doc("tokens")
      .get()
      .then(((snapshot) => token = snapshot["admin-token"]));

  //Create Message with Notification Payload
  String constructFCMPayload(String token) {
    String day = checkDate(appointment.time);
    String time = getTime(appointment.time);
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': "You have a new appointment for $time $day",
          'title': "New Appointment",
        },
        'data': <String, dynamic>{
          'name': appointment.name,
          'time': appointment.time.toString(),
          'service': appointment.service,
          'status': appointment.status,
          'id': appointment.id
        },
        'to': token
      },
    );
  }

  if (token.isEmpty) {
    return log('Unable to send FCM message, no token exists.');
  }

  try {
    //Send  Message
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: constructFCMPayload(token));

    log("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    log("error push notification $e");
  }
}

///Send Confirmation Message to User
sendNotificationToUser({required Appointment appointment}) async {
  //Our API Key
  var serverKey = dotenv.get('API_KEY');

  //Get our Admin token from Firesetore DB
  var token;
  await apptCollection
      .doc("tokens")
      .get()
      .then(((snapshot) => token = snapshot["user-token"]));

  //Create Message with Notification Payload
  String constructFCMPayload(String token) {
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body':
              "Hi ${appointment.name}, Your ${appointment.service} appointment has been confirmed!",
          'title': "Appointment Confirmed",
        },
        'data': <String, dynamic>{'name': appointment.name},
        'to': token
      },
    );
  }

  if (token.isEmpty) {
    return log('Unable to send FCM message, no token exists.');
  }

  try {
    //Send  Message
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: constructFCMPayload(token));

    log("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    log("error push notification $e");
  }
}
