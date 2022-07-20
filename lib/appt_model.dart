import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String name;
  final DateTime time;
  final String service;
  final String id;

  Appointment({required this.name, required this.time, required this.service, required this.id});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        name: json['name'],
        time: (json['time']).toDate(),
        service: json['service'],
        id: json['id']
        );
  }

  toJson() {
    return {'name': name, 'service': service, 'time': Timestamp.fromDate(time), 'id': id};
  }
}
