import 'package:flutter/material.dart';
import 'package:schedular_app/appt_model.dart';
import 'package:schedular_app/pages/admin_screen.dart';
import 'package:schedular_app/pages/appt_details.dart';
import 'package:schedular_app/pages/login_page.dart';
import 'package:schedular_app/pages/user_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/user':
        return MaterialPageRoute(builder: (_) => const UserHomePage(), settings: settings);
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminHomePage(), settings: settings);
      case '/details':
        return MaterialPageRoute(builder: (_) => AppointmentDetails(args as Appointment));
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
