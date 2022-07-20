import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schedular_app/helper_functions.dart';
import 'appt_model.dart';

final db = FirebaseFirestore.instance;
final apptCollection = db.collection('appointments');
const haircutColor = Colors.brown;
const massageColor = Colors.grey;
const manicureColor = Colors.pink;
const pedicureColor = Colors.amber;

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("FCM ADMIN")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Schedule",
                style: TextStyle(fontSize: 24.0, letterSpacing: 1.5)),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Coming up:"),
                TextButton(
                    child: const Text("View all",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey)),
                    onPressed: () {}),
              ],
            ),
            const Schedule(),
            const SizedBox(height: 30.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ColorIdentifier(color: haircutColor, service: "Haircut"),
                  ColorIdentifier(color: massageColor, service: "Massage"),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ColorIdentifier(color: manicureColor, service: "Manicure"),
                ColorIdentifier(color: pedicureColor, service: "Pedicure"),
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
    return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: StreamBuilder(
          stream: getAppointments,
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return const SizedBox(
                height: 300.0,
                child: Center(
                    child: Text("You do not have any new appointments!")),
              );
            }

            if (snapshot.hasData) {
              List<Appointment> appts = [];

              for (var doc in snapshot.data!.docs) {
                final appt =
                    Appointment.fromJson(doc.data() as Map<String, dynamic>);

                appts.add(appt);
              }
              return SizedBox(
                height: 300.0,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appts.length,
                  itemBuilder: (context, index) {
                    return ScheduleCard(appts[index]);
                  },
                ),
              );
            }

            return const SizedBox();
          }),
        ));
  }
}

//Stream to get all future appointment
final Stream<QuerySnapshot> getAppointments = apptCollection
    .where('time', isGreaterThan: Timestamp.now())
    .snapshots();

class ScheduleCard extends StatelessWidget {
  final Appointment appointment;
  const ScheduleCard(this.appointment, {super.key});

  @override
  Widget build(BuildContext context) {
    var cardColor;

    switch (appointment.service.toLowerCase()) {
      case "haircut":
        cardColor = haircutColor;
        break;
      case "massage":
        cardColor = massageColor;
        break;
      case "manicure":
        cardColor = manicureColor;
        break;
      case "pedicure":
        cardColor = pedicureColor;
        break;
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 110.0,
                      child: Row(
                        children: [
                          //Service color tag
                          Container(
                            color: cardColor.withOpacity(0.8),
                            width: 5.0,
                          ),

                          const SizedBox(width: 15.0),

                          //Client name
                          Expanded(
                              child: Text(appointment.name,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      )),

                  //Appointmemt date
                  Text(
                      checkDate("${appointment.time.toLocal()}".split(' ')[0])),

                  //Appointment time
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
      ),
    );
  }
}

//Color Identify table
class ColorIdentifier extends StatelessWidget {
  final service;
  final color;
  const ColorIdentifier({this.service, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              color: color.withOpacity(0.8),
            ),
            const SizedBox(width: 20.0),
            Expanded(child: Text(service))
          ],
        ),
      ),
    );
  }
}
