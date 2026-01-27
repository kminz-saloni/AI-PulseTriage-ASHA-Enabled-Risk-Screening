import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/todays_task_screen.dart';
import 'screens/emergency_alert_screen.dart';
import 'screens/patient_management_screen.dart';
import 'screens/incentive_tracker_screen.dart';
import 'screens/monthly_summary_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AASHA Sathi',
      theme: AppTheme.theme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        '/home': (context) => const HomeScreen(),
        '/todays_task': (context) => const TodaysTaskScreen(),
        '/emergency_alert': (context) => const EmergencyAlertScreen(),
        '/patient_management': (context) => const PatientManagementScreen(),
        '/incentive_tracker': (context) => const IncentiveTrackerScreen(),
        '/monthly_summary': (context) => const MonthlySummaryScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}