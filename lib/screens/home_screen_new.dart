import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/cards.dart';
import '../widgets/buttons.dart';
import '../widgets/input_components.dart';
import 'patient_list_screen.dart';
import 'ai_risk_result_screen.dart';
import 'settings_screen.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int _selectedIndex = 0;
  
  // SOS & Voice variables
  Timer? _sosTimer;
  bool _sosActive = false;
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);

  @override
  void dispose() {
    _sosTimer?.cancel();
    super.dispose();
  }

  void _showSOSDialog() {
    _sosTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _activateSOS();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Emergency Alert',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text(
          'Are you in emergency?\nSOS will activate if you don\'t respond in 5 seconds.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _sosActive = false;
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _activateSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Emergency!'),
          ),
        ],
      ),
    );
  }

  void _activateSOS() {
    if (_sosActive) return;
    _sosActive = true;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🚨 SOS Activated!\n📍 Location shared with emergency contact\n📞 Calling emergency contact...',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _openVoiceAssistant() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎤 Voice Assistant Activated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(context),
          const PatientListScreen(),
          const AiRiskResultScreen(),
          const SettingsScreen(),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'AI Status',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 72 + 20,
        right: 16,
        left: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SOS Button (Bottom-Left) - Always Red
          FloatingActionButton(
            onPressed: _handleSOS,
            backgroundColor: AppTheme.emergencyRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            heroTag: 'sos_button',
            child: const Icon(Icons.emergency, size: 28),
          ),
          
          // AI Assistant Button (Bottom-Right)
          FloatingActionButton(
            onPressed: _handleAIAssistant,
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            heroTag: 'ai_button',
            child: const Icon(Icons.mic, size: 28),
          ),
        ],
      ),
    );
  }

  void _handleSOS() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency SOS'),
        content: const Text('What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emergencyRed,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Call ambulance
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling nearest ambulance...')),
              );
            },
            child: const Text('Call Ambulance'),
          ),
        ],
      ),
    );
  }

  void _handleAIAssistant() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎤 Listening... "What should I do next?"')),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
          padding: EdgeInsets.zero,
        ),
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.mediumText,
                    ),
                  ),
                  const SizedBox(height: AppTheme.xs),
                  Text(
                    'Priya Sharma',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.xxl),

              // Quick Stats - Today's Tasks
              SectionHeader(
                title: "Today's Tasks",
                actionLabel: 'View All',
                onActionTap: () {
                  setState(() => _selectedIndex = 1);
                },
              ),
              const SizedBox(height: AppTheme.md),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppTheme.lg,
                mainAxisSpacing: AppTheme.lg,
                children: [
                  TaskCard(
                    title: 'New Visits',
                    count: '8',
                    description: 'Patients to meet',
                    icon: Icons.person_add,
                    color: AppTheme.primaryTeal,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                  TaskCard(
                    title: 'Follow-ups',
                    count: '3',
                    description: 'Pending reviews',
                    icon: Icons.assignment,
                    color: AppTheme.accentTeal,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                  TaskCard(
                    title: 'Pregnant',
                    count: '12',
                    description: 'Active cases',
                    icon: Icons.pregnant_woman,
                    color: AppTheme.primaryGreen,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                  TaskCard(
                    title: 'Children',
                    count: '15',
                    description: 'Under monitoring',
                    icon: Icons.child_care,
                    color: AppTheme.warningOrange,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.xxl),

              // Emergency Alerts
              SectionHeader(
                title: 'Emergency Alerts',
              ),
              const SizedBox(height: AppTheme.md),
              Card(
                color: AppTheme.emergencyRed.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: AppTheme.emergencyRed,
                            size: 28,
                          ),
                          const SizedBox(width: AppTheme.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mrs. Reena - High Risk',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pregnancy complications detected',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.mediumText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.lg),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: 'View Details',
                              onPressed: () {
                                setState(() => _selectedIndex = 2);
                              },
                              borderColor: AppTheme.emergencyRed,
                              textColor: AppTheme.emergencyRed,
                            ),
                          ),
                          const SizedBox(width: AppTheme.md),
                          Expanded(
                            child: LargeButton(
                              label: 'Call Doctor',
                              onPressed: () {},
                              backgroundColor: AppTheme.emergencyRed,
                              icon: Icons.phone,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.xxl),

              // Incentives Preview
              SectionHeader(
                title: 'Incentives',
                actionLabel: 'Details',
                onActionTap: () {
                  setState(() => _selectedIndex = 3);
                },
              ),
              const SizedBox(height: AppTheme.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    children: [
                      ProgressIndicatorWithLabel(
                        label: 'This Month Earned',
                        value: '₹8,500',
                        progress: 0.7,
                        color: AppTheme.successGreen,
                      ),
                      const SizedBox(height: AppTheme.xl),
                      ProgressIndicatorWithLabel(
                        label: 'Pending Payment',
                        value: '₹3,200',
                        progress: 0.4,
                        color: AppTheme.warningOrange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.xl),
            ],
          ),
        ),
      ),
    );
  }
}
