import 'package:flutter/material.dart';

import 'admin_screen.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FCM LOGIN")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Who are you?",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30.0),
          Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(15),
              color: Colors.black45,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminHomePage()));
                },
                child: const Text(
                  "Admin",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          const SizedBox(height: 30.0),
          Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserHomePage()));
                },
                child: const Text(
                  "User",
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ]),
      ),
    );
  }
}
