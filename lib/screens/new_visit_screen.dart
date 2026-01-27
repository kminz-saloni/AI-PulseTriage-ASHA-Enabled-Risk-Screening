import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/cards_buttons.dart';
import '../models/models.dart';
import 'ai_risk_result_screen.dart';

class NewVisitScreen extends StatefulWidget {
  const NewVisitScreen({Key? key}) : super(key: key);

  @override
  State<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends State<NewVisitScreen> {
  int currentStep = 0;
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? systolic;
  String? diastolic;
  String? weight;
  String? temperature;
  
  // SOS & Voice variables
  Timer? _sosTimer;
  bool _sosActive = false;
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);
  
  final symptoms = <String, bool>{
    'Fever': false,
    'Cough': false,
    'Breathlessness': false,
    'Chest Pain': false,
    'Headache': false,
    'Fatigue': false,
  };

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _weightController = TextEditingController();
  final _temperatureController = TextEditingController();

  @override
  void dispose() {
    _sosTimer?.cancel();
    _nameController.dispose();
    _ageController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _weightController.dispose();
    _temperatureController.dispose();
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

  void _submitVisit() {
    final result = RiskResult(
      level: RiskLevel.medium,
      explanation: 'Moderate risk based on vitals and symptoms',
      action: 'Schedule follow-up within 7 days',
      reasons: [
        'Blood pressure elevated',
        'Multiple symptoms reported',
        'Age over 45',
      ],
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AiRiskResultScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
          padding: EdgeInsets.zero,
        ),
        title: const Text('New Visit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'EN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
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
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: List.generate(4, (index) {
                      return Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: index <= currentStep ? AppTheme.primaryTeal : AppTheme.borderColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: index <= currentStep ? Colors.white : AppTheme.mediumText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (index < 3)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: index < currentStep ? AppTheme.primaryTeal : AppTheme.borderColor,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentStep == 0) _buildPatientDetailsStep(),
                      if (currentStep == 1) _buildVitalsStep(),
                      if (currentStep == 2) _buildSymptomsStep(),
                      if (currentStep == 3) _buildReviewStep(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SOS Button
          Positioned(
            left: _sosPosition.dx,
            bottom: _sosPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _sosPosition = Offset(
                    (_sosPosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 60),
                    (_sosPosition.dy - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
                  );
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showSOSDialog,
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.sos, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),
          // Voice Assistant Button
          Positioned(
            left: _voicePosition.dx,
            bottom: _voicePosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _voicePosition = Offset(
                    (_voicePosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 60),
                    (_voicePosition.dy - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
                  );
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentTeal.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openVoiceAssistant,
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.mic, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: LargeButton(
                  label: 'Back',
                  onPressed: () {
                    setState(() => currentStep--);
                  },
                  isOutlined: true,
                ),
              ),
            if (currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child: LargeButton(
                label: currentStep == 3 ? 'Submit' : 'Next',
                onPressed: () {
                  if (currentStep == 3) {
                    _submitVisit();
                  } else {
                    setState(() => currentStep++);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Text('Full Name', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter patient name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Age (years)', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            hintText: 'Enter age',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Text('Gender', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          children: ['Male', 'Female', 'Other'].map((gender) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => patientGender = gender);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: patientGender == gender ? AppTheme.primaryTeal : Colors.transparent,
                    side: BorderSide(
                      color: patientGender == gender ? AppTheme.primaryTeal : AppTheme.borderColor,
                    ),
                  ),
                  child: Text(
                    gender,
                    style: TextStyle(
                      color: patientGender == gender ? Colors.white : AppTheme.darkText,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVitalsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vital Signs',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Systolic (mmHg)', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _systolicController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 120',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diastolic (mmHg)', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _diastolicController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 80',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Weight (kg)', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _weightController,
          decoration: InputDecoration(
            hintText: 'Enter weight',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Text('Temperature (°C)', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _temperatureController,
          decoration: InputDecoration(
            hintText: 'Enter temperature',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSymptomsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptoms',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'Select all that apply',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mediumText),
        ),
        const SizedBox(height: 20),
        ...symptoms.keys.map((symptom) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => symptoms[symptom] = !symptoms[symptom]!);
              },
              child: Card(
                color: symptoms[symptom]! ? AppTheme.primaryTeal.withOpacity(0.1) : AppTheme.cardBg,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Checkbox(
                        value: symptoms[symptom],
                        onChanged: (value) {
                          setState(() => symptoms[symptom] = value ?? false);
                        },
                        activeColor: AppTheme.primaryTeal,
                      ),
                      Text(
                        symptom,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review & Submit',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        _buildReviewCard('Patient', [
          'Name: ${_nameController.text}',
          'Age: ${_ageController.text} years',
          'Gender: $patientGender',
        ]),
        const SizedBox(height: 12),
        _buildReviewCard('Vitals', [
          'BP: ${_systolicController.text}/${_diastolicController.text} mmHg',
          'Weight: ${_weightController.text} kg',
          'Temp: ${_temperatureController.text}°C',
        ]),
        const SizedBox(height: 12),
        _buildReviewCard('Symptoms', [
          symptoms.entries.where((e) => e.value).map((e) => e.key).join(', '),
        ]),
      ],
    );
  }

  Widget _buildReviewCard(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
