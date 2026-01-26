import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/home_screen.dart';
import '../features/patients/patient_list_screen.dart';
import '../features/patients/patient_detail_screen.dart';
import '../features/referrals/referral_tracker_screen.dart';
import '../features/tasks/task_list_screen.dart';
import '../features/incentives/incentive_tracker_screen.dart';
import '../features/visits/new_visit_wizard.dart';
import '../features/emergency/emergency_create_screen.dart';
import '../features/emergency/emergency_list_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/auth/login_screen.dart' show LoginScreen, authStateProvider;

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      
      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/patients',
                builder: (context, state) => const PatientListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/referrals',
                builder: (context, state) => const ReferralTrackerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TaskListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/incentives',
                builder: (context, state) => const IncentiveTrackerScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/patient/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PatientDetailScreen(patientId: id);
        },
      ),
      GoRoute(
        path: '/new-visit',
        builder: (context, state) {
          final patientId = state.uri.queryParameters['patientId'];
          return NewVisitWizard(patientId: patientId);
        },
      ),
      GoRoute(
        path: '/emergency-create',
        builder: (context, state) {
          final patientId = state.uri.queryParameters['patientId'];
          return EmergencyCreateScreen(patientId: patientId);
        },
      ),
      GoRoute(
        path: '/emergency-list',
        builder: (context, state) => const EmergencyListScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Patients'),
          NavigationDestination(icon: Icon(Icons.local_hospital), label: 'Referrals'),
          NavigationDestination(icon: Icon(Icons.task), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.attach_money), label: 'Incentives'),
        ],
      ),
    );
  }
}
