import 'package:flutter/material.dart';

import 'admin_screen.dart';
import 'main.dart';
import 'user_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("FCM LOGIN")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Who are you?",
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 30.0),
          
          InkWell(
            onTap: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AdminHomePage()));
              },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: MyApp.primaryColor)),
              child: const Center(
                child:  Text(
                    "ADMIN",
                    style: TextStyle(fontSize: 16.0),
                  ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          InkWell(
          
            onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserHomePage()));
              },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: MyApp.primaryColor)),
              child: const Center(
                child:  Text(
                    "USER",
                    style: TextStyle(fontSize: 16.0),
                  ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
