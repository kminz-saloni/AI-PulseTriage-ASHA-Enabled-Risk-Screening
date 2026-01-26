import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/ai/local_risk_engine.dart';
import '../../domain/risk_assessment.dart';
import '../../ui/widgets/risk_badge.dart';
import '../../l10n/app_localizations.dart';

class NewVisitWizard extends ConsumerStatefulWidget {
  final String? patientId;

  const NewVisitWizard({
    super.key,
    this.patientId,
  });

  @override
  ConsumerState<NewVisitWizard> createState() => _NewVisitWizardState();
}

class _NewVisitWizardState extends ConsumerState<NewVisitWizard> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Vitals
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();

  // Symptoms
  final List<String> _selectedSymptoms = [];
  final List<String> _availableSymptoms = [
    'chest_pain',
    'headache',
    'severe_headache',
    'breathlessness',
    'cough_2weeks',
    'fever',
    'weight_loss',
    'polyuria',
    'polydipsia',
  ];
  final _otherSymptomsController = TextEditingController();
  final _patientHistoryController = TextEditingController();
  final _familyHistoryController = TextEditingController();

  // Adherence
  int _missedDoses = 0;

  // AI Result
  RiskAssessment? _riskAssessment;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _otherSymptomsController.dispose();
    _patientHistoryController.dispose();
    _familyHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newVisit),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 4 ? l10n.save : l10n.next),
                ),
                const SizedBox(width: 8),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(l10n.back),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Vitals'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _systolicController,
                    decoration: const InputDecoration(labelText: 'Systolic BP (mmHg)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _diastolicController,
                    decoration: const InputDecoration(labelText: 'Diastolic BP (mmHg)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _heartRateController,
                    decoration: const InputDecoration(labelText: 'Heart Rate (bpm)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _temperatureController,
                    decoration: const InputDecoration(labelText: 'Temperature (°C)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Symptoms'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._availableSymptoms.map((symptom) {
                  return CheckboxListTile(
                    title: Text(symptom.replaceAll('_', ' ').toUpperCase()),
                    value: _selectedSymptoms.contains(symptom),
                    onChanged: (checked) {
                      setState(() {
                        if (checked ?? false) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherSymptomsController,
                  decoration: InputDecoration(
                    labelText: l10n.otherSymptoms,
                    hintText: l10n.otherSymptomsHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _patientHistoryController,
                  decoration: InputDecoration(
                    labelText: l10n.patientHistory,
                    hintText: l10n.patientHistoryHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _familyHistoryController,
                  decoration: InputDecoration(
                    labelText: l10n.familyHistory,
                    hintText: l10n.familyHistoryHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Adherence'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                Text(
                  'Number of missed doses in last 30 days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _missedDoses.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _missedDoses.toString(),
                  onChanged: (value) {
                    setState(() {
                      _missedDoses = value.toInt();
                    });
                  },
                ),
                Text(
                  '$_missedDoses doses',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('AI Result'),
            isActive: _currentStep >= 3,
            content: _riskAssessment == null
                ? const Text('Run assessment to view results')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: RiskBadge(riskLevel: _riskAssessment!.riskLevel, size: 48)),
                      const SizedBox(height: 24),
                      Text(
                        'Reasons:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ..._riskAssessment!.reasons.map((reason) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(child: Text(reason)),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),
                      Text(
                        'Recommended Action:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_riskAssessment!.recommendedAction),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Model: ${_riskAssessment!.modelVersion}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
          ),
          Step(
            title: const Text('Confirmation'),
            isActive: _currentStep >= 4,
            content: const Column(
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('Review the data and save the visit'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 2) {
      // Run AI assessment
      final assessment = LocalRiskEngine.assessRisk(
        systolicBp: int.parse(_systolicController.text),
        diastolicBp: int.parse(_diastolicController.text),
        symptoms: _selectedSymptoms,
        missedDoses: _missedDoses,
        hasTbHistory: false,
        hasDiabetes: false,
        hasHypertension: false,
      );
      setState(() {
        _riskAssessment = assessment;
        _currentStep++;
      });
    } else if (_currentStep == 4) {
      // Save visit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visit saved successfully')),
      );
      context.pop();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
}
