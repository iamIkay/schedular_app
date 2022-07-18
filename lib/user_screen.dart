import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedular_app/appt_model.dart';
import 'package:schedular_app/main.dart';

import 'admin_screen.dart';

String _user = "";

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String? _service;
  DateTime date = DateTime.now();
  bool showDate = false;

  final _serviceList = ["Haircut", "Massage", "Manicure", "Pedicure"];

  final _nameController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nameField = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _nameController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Name",
              border: InputBorder.none),
        ));

    final searchField = Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _searchController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Search for",
              border: InputBorder.none),
        ));

    final serviceDropDown = SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 50.0,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: DropdownButton(
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 28,
          hint: const Text("Select Service"),
          disabledHint: const Text("Select Service"),
          underline: const SizedBox(),
          isExpanded: true,
          value: _service,
          onChanged: (newValue) {
            setState(() {
              _service = newValue.toString();
            });
          },
          items: _serviceList.map((valueItem) {
            return DropdownMenuItem(value: valueItem, child: Text(valueItem));
          }).toList(),
        ),
      ),
    ]));

    final datePicker = Visibility(
      visible: showDate,
      child: SizedBox(
        height: 220.0,
        child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            onDateTimeChanged: ((value) => setState(() {
                  date = value;
                }))),
      ),
    );

    final selectedDateAndTime = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10.0),
            Text("${date.toLocal()}".split(' ')[0]),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            const Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10.0),
            Text("${date.toLocal()}".split(' ')[1].split(':')[0]),
            const Text(':'),
            Text("${date.toLocal()}".split(' ')[1].split(':')[1]),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );

    final txtHeader = Center(
        child: Text("BOOK APPOINTMENT",
            style: TextStyle(fontSize: 24.0, letterSpacing: 1.5)));

    final btnShowDate = Material(
        // elevation: 5.0,
        color: Colors.transparent,
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              showDate = !showDate;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Say when",
                style: TextStyle(
                    color: MyApp.primaryColor,
                    decoration: TextDecoration.underline),
              ),
              SizedBox(width: 10.0),
              Icon(Icons.alarm, color: MyApp.primaryColor)
            ],
          ),
        ));

    final btnSubmit = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: MyApp.primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_nameController.text.isNotEmpty && _service != null) {
              bookSession(
                  name: _nameController.text,
                  service: _service!.toLowerCase(),
                  time: date);

              setState(() {
                _user = _nameController.text;
                _nameController.clear();
                _service = null;
              });
            } else {
              log("Please enter all fields!");
            }
          },
          child: const Text(
            "Book",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final btnSearch = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: MyApp.primaryColor,
        child: MaterialButton(
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              setState(() {
                _user = _searchController.text;
              });
            }
          },
          child: const Text(
            "Search",
            style: TextStyle(color: Colors.white),
          ),
        ));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(centerTitle: true, title: const Text("FCM USER")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txtHeader,
              const SizedBox(height: 20.0),
              nameField,
              const SizedBox(height: 30.0),
              serviceDropDown,
              const SizedBox(height: 30.0),
              selectedDateAndTime,
              datePicker,
              btnShowDate,
              const SizedBox(height: 60.0),
              btnSubmit,
              const SizedBox(height: 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 20.0),
                  btnSearch
                ],
              ),
              const SizedBox(height: 20.0),
              GetMyAppointments(user: _user),
              const SizedBox(height: 30.0)
            ],
          ),
        ),
      ),
    );
  }
}

bookSession({name, service, time}) async {
  Appointment appt = Appointment(name: name, time: time, service: service);
  await apptCollection.add(appt.toJson());

  log("Appointment Booked Successfully!");
}

class GetMyAppointments extends StatelessWidget {
  final String user;
  const GetMyAppointments({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300.0,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: StreamBuilder(
          stream: getMyAppointments(user),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              return SizedBox();
            }

            if (snapshot.data!.docs.isEmpty) {
              return SizedBox(
                child: Center(
                    child:
                        Text("You haven't booked any appointment for $_user!")),
              );
            }

            if (snapshot.hasData) {
              List<Appointment> appts = [];

              for (var doc in snapshot.data!.docs) {
                final appt =
                    Appointment.fromJson(doc.data() as Map<String, dynamic>);

                appts.add(appt);
              }

              log("Number: ${appts.length}");
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appts.length,
                itemBuilder: (context, index) {
                  return ScheduleCard(appts[index]);
                },
              );
            }

            return const SizedBox();
          }),
        ));
  }
}

getMyAppointments(String user) {
  if (user.isEmpty) {
    return null;
  }
  return apptCollection.where('name', isEqualTo: _user).snapshots();
}
