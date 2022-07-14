import 'package:flutter/material.dart';

import 'appt_model.dart';

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
              children:  [
               const Text("Today:"),
                TextButton(
                    child: const Text("View all",
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.grey)),
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
    final appointments = [
      Appointment(
          name: "Mark", date: "2022-12-31", time: "12:30", service: "haircut"),
      Appointment(
          name: "Mark Odogwu Abulori",
          date: "2022-12-31",
          time: "12:30",
          service: "massage"),
      Appointment(
          name: "Mercy Adibe",
          date: "2022-12-31",
          time: "12:30",
          service: "manicure"),
      Appointment(
          name: "Mark", date: "2022-12-31", time: "12:30", service: "massage"),
      Appointment(
          name: "Mark", date: "2022-12-31", time: "12:30", service: "haircut"),
    ];
    return Container(
      height: 400.0,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ScheduleCard(appointments[index]);
        },
      ),
    );
  }
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
      color: cardColor.withOpacity(0.4),
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
            Text(appointment.date),
            Text(appointment.time)
          ]),
        ),
      ),
    );
  }
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
            color: color.withOpacity(0.4),
          ),
          const SizedBox(width: 20.0),
          Text(service)
        ],
      ),
    );
  }
}
