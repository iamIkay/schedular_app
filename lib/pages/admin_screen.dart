import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:schedular_app/helper_functions.dart';
import '../appt_model.dart';
import '../main.dart';

final db = FirebaseFirestore.instance;
final apptCollection = db.collection('appointments');
const haircutColor = Colors.brown;
const massageColor = Colors.green;
const manicureColor = Colors.blue;
const pedicureColor = Colors.amber;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

initializeAdminToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    apptCollection.doc("tokens").update({'admin-token': token});
  });
}

class _AdminHomePageState extends State<AdminHomePage> {
  //Update Admin token on Login
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAdminToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200.0,
              decoration: const BoxDecoration(
                  color: MyApp.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    const Text("Welcome Admin,",
                        style: TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 10.0),
                    const Text("Here are your upcoming appointments",
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          child: const Text(
                            "View all",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white70),
                          ),
                          onPressed: () {}),
                    ),
                    const Schedule(),
                    const SizedBox(height: 30.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          ColorIdentifier(
                              color: haircutColor, service: "Haircut"),
                          ColorIdentifier(
                              color: massageColor, service: "Massage"),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ColorIdentifier(
                            color: manicureColor, service: "Manicure"),
                        ColorIdentifier(
                            color: pedicureColor, service: "Pedicure"),
                      ],
                    )
                  ]),
            ),
          ],
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
                    return GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/details', arguments: appts[index]),
                        child: ScheduleCard(appts[index]));
                  },
                ),
              );
            }

            return const SizedBox();
          }),
        ));
  }
}

//Stream to get all appointments from today
DateTime now = DateTime.now();
DateTime today = DateTime(now.year, now.month, now.day);

final Stream<QuerySnapshot> getAppointments = apptCollection
    .orderBy('time')
    .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
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
    
    return Container(
      height: 50.0,
      margin: const EdgeInsets.only(bottom: 10.0),

      //width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //Service color tag
          Container(
            color: cardColor.withOpacity(0.8),
            width: 5.0,
          ),

          Expanded(
            child: SizedBox(
              height: 50.0,
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10.0, top: 10.0, left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110.0,
                                child: Text(appointment.name,
                                    overflow: TextOverflow.ellipsis)),

                            //Appointmemt date
                            Text(checkDate(appointment.time)),

                            //Appointment time
                            Text(getTime(appointment.time)),
                          ]),
                      Text(
                        appointment.status,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: appointment.status == 'pending'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
