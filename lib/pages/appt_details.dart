import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:schedular_app/appt_model.dart';
import 'package:schedular_app/pages/admin_screen.dart';
import '../helper_functions.dart';
import '../main.dart';

class AppointmentDetails extends StatefulWidget {
  final Appointment appointment;
  const AppointmentDetails(this.appointment, {super.key});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    void editAppointment(Appointment appt) {
      setState(() {
        widget.appointment.status = appt.status;
      });
    }

    log(widget.appointment.status);

    const txtHeader = Center(
        child: Text("Appointment Details", style: TextStyle(fontSize: 24.0)));

    final confirmBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: widget.appointment.status == "confirmed"
            ? Colors.grey
            : MyApp.primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () => widget.appointment.status == "confirmed"
              ? null
              : confirmAppointment(widget.appointment, editAppointment),
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ),
        ));

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          txtHeader,
          const SizedBox(height: 20.0),
          BuildRow(title: "Name", details: widget.appointment.name),
          BuildRow(title: "Service", details: widget.appointment.service),
          BuildRow(title: "Date", details: getDate(widget.appointment.time)),
          BuildRow(
              title: "Time", details: "${getTime(widget.appointment.time)}"),
          BuildRow(title: "Status", details: widget.appointment.status),
          const SizedBox(height: 20.0),
          confirmBtn
        ]),
      ),
    );
  }
}

confirmAppointment(
    Appointment appointment, ValueChanged<Appointment> update) async {
  appointment.status = "confirmed";

  await apptCollection
      .doc(appointment.id)
      .set(appointment.toJson())
      .then((value) {
    sendNotificationToUser(appointment: appointment);
    update(appointment);
  });
}

class BuildRow extends StatelessWidget {
  final title;
  final details;
  const BuildRow({this.title, this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10.0),
          Text("$details"),
        ],
      ),
    );
  }
}
