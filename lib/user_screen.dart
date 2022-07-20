import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:schedular_app/appt_model.dart';
import 'package:schedular_app/main.dart';

import 'admin_screen.dart';

String _user = "";
bool _editForm = false;
String _editApptId = "";

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String? _service;
  DateTime time = DateTime.now();
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
                  time = value;
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
            Text("${time.toLocal()}".split(' ')[0]),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            const Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10.0),
            Text("${time.toLocal()}".split(' ')[1].split(':')[0]),
            const Text(':'),
            Text("${time.toLocal()}".split(' ')[1].split(':')[1]),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );

    const txtHeader = Center(
        child: Text("BOOK APPOINTMENT",
            style: TextStyle(fontSize: 24.0, letterSpacing: 1.5)));

    final btnShowDate = Material(
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
              !_editForm
                  ? bookSession(
                      name: _nameController.text, service: _service, time: time)
                  : updateAppointment(Appointment(
                      name: _nameController.text,
                      service: _service!,
                      time: time,
                      id: _editApptId));
              setState(() {
                _user = _nameController.text;
                _nameController.clear();
                _service = null;
                time = DateTime.now();
              });
            } else {
              log("Please enter all fields!");
            }
          },
          child: Text(
            !_editForm ? "Book" : "Update",
            style: const TextStyle(color: Colors.white),
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

    void editAppointment(Appointment appt) {
      setState(() {
        _nameController.text = appt.name;
        _service = appt.service;
        time = appt.time;
        _editForm = true;
        _editApptId = appt.id;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(centerTitle: true, title: const Text("FCM USER")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
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
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 20.0),
                  btnSearch
                ],
              ),
              const SizedBox(height: 20.0),
              GetMyAppointments(user: _user, update: editAppointment),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

bookSession({name, service, time}) async {
  final docRef = apptCollection.doc();
  Appointment appt =
      Appointment(name: name, time: time, service: service, id: docRef.id);

  await docRef.set(appt.toJson()).then(
      (value) => log("Appointment booked successfully!"),
      onError: (e) => log("Error booking appointment: $e"));
}

void updateAppointment(appt) {
  //Set updated data for selected appointment
  apptCollection.doc(appt.id).set(appt.toJson()).then(
      (value) => log("Appointment updated Successfully!"),
      onError: (e) => log("Error updating appointment: $e"));

  _editForm = false;
}

void deleteAppointment(appt) {
  //Delete selected appointment
  apptCollection.doc(appt.id).delete().then(
      (value) => log("Appointment deleted successfully!"),
      onError: (e) => "Error deleting appointment: $e");
}

class GetMyAppointments extends StatelessWidget {
  final String user;
  final ValueChanged<Appointment> update;
  const GetMyAppointments(
      {required this.user, required this.update, super.key});

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
              return const SizedBox();
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

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appts.length,
                itemBuilder: (context, index) {
                  return UserScheduleCard(appts[index], update: update);
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

class UserScheduleCard extends StatelessWidget {
  final Appointment appointment;
  final ValueChanged<Appointment> update;
  const UserScheduleCard(this.appointment, {required this.update, super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => update(appointment),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => deleteAppointment(appointment),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ScheduleCard(appointment));
  }
}
