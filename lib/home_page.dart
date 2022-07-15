import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  /* showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          lastDate: DateTime(2022, 12),
          firstDate: DateTime.now()); */

  /*     if (selectedDate != null && selectedDate != date) {
        setState(() {
          date = selectedDate;
        }); */

  @override
  Widget build(BuildContext context) {
    final textField = Container(
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
      child: Expanded(
        child: CupertinoDatePicker(
            onDateTimeChanged: ((value) => setState(() {
                  date = value;
                }))),
      ),
    );

    final selectedDateAndTime = Column(
      mainAxisSize: MainAxisSize.max,
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

    final btnShowDate = Material(
        // elevation: 5.0,
        color: Colors.amber,
        child: MaterialButton(
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
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 10.0),
              Icon(Icons.alarm, color: Colors.white)
            ],
          ),
        ));

    final btnSubmit = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: Colors.green,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {},
          child: const Text(
            "Book",
            style: TextStyle(color: Colors.white),
          ),
        ));

    return Scaffold(
      appBar: AppBar(title: const Text("FCM USER")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textField,
            const SizedBox(height: 30.0),
            serviceDropDown,
            const SizedBox(height: 30.0),
            selectedDateAndTime,
            datePicker,
            btnShowDate,
            const SizedBox(height: 60.0),
            btnSubmit,
            const SizedBox(height: 30.0),
          ],
        )),
      ),
    );
  }
}
