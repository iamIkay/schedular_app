import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'appt_model.dart';

//List<Appointment> appts = [];
final db = FirebaseFirestore.instance;

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FCM ADMIN")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Welcome Admin!",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Today:"),
                TextButton(
                    child: const Text("View all",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey)),
                    onPressed: () {}),
              ],
            ),
            const SizedBox(height: 15.0),
            const Schedule(),
            const SizedBox(height: 30.0),
            /* const Text("Tomorrow:"),
            const Schedule(), */
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ColorIdentifier(color: Colors.brown, service: "Haircut"),
                  ColorIdentifier(color: Colors.grey, service: "Massage"),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ColorIdentifier(color: Colors.pink, service: "Manicure"),
                ColorIdentifier(color: Colors.amber, service: "Pedicure"),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.0,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: StreamBuilder(
          stream: getAppointments(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              List<Appointment> appts = [];

              for (var doc in snapshot.data!.docs) {
                appts.add(
                    Appointment.fromJson(doc.data() as Map<String, dynamic>));
              }
              return ListView.builder(
                itemCount: appts.length,
                itemBuilder: (context, index) {
                  return ScheduleCard(appts[index]);
                },
              );
            }

            return SizedBox();
          }),
        )

        /*  ListView.builder(
        itemCount: appts.length,
        itemBuilder: (context, index) {
          return ScheduleCard(appts[index]);
        },
      ), */
        );
  }
}

Stream<QuerySnapshot> getAppointments() {
  return db.collection('appointments').orderBy('time').snapshots();
}

class ScheduleCard extends StatelessWidget {
  final Appointment appointment;
  const ScheduleCard(this.appointment, {super.key});

  @override
  Widget build(BuildContext context) {
    var cardColor;

    switch (appointment.service) {
      case "haircut":
        cardColor = Colors.brown;
        break;
      case "massage":
        cardColor = Colors.grey;
        break;
      case "manicure":
        cardColor = Colors.pink;
        break;
      case "pedicure":
        cardColor = Colors.amber;
        break;
    }
    return Container(
      height: 50.0,
      color: cardColor.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
                width: 100.0,
                child: Text(appointment.name, overflow: TextOverflow.ellipsis)),
            Text(checkDate("${appointment.time.toLocal()}".split(' ')[0])),
            Row(
              children: [
                Text("${appointment.time.toLocal()}"
                    .split(' ')[1]
                    .split(':')[0]),
                const Text(':'),
                Text("${appointment.time.toLocal()}"
                    .split(' ')[1]
                    .split(':')[1]),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

checkDate(date) {
  DateTime now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = DateTime(now.year, now.month, now.day+1);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == today) {
    return "Today";
  }

  if (checkDate == tomorrow) {
    return "Tomorrow";
  }

  return date;
}

class ColorIdentifier extends StatelessWidget {
  final service;
  final color;
  const ColorIdentifier({this.service, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            color: color.withOpacity(0.5),
          ),
          const SizedBox(width: 20.0),
          Text(service)
        ],
      ),
    );
  }
}
