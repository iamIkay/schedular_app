import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String name;
  final DateTime time;
  final String service;

  Appointment({required this.name, required this.time, required this.service});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        name: json['name'],
        time: (json['time']).toDate(),
        service: json['service']);
  }

  toJson() {
    return {'name': name, 'service': service, 'time': Timestamp.fromDate(time)};
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Name: ${this.name}\nservice: ${this.service}";
  }
}
