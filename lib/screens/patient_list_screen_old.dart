import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/buttons.dart';
import '../widgets/input_components.dart';
import '../models/models.dart';
import 'patient_detail_screen.dart';

class PatientListScreen extends StatefulWidget {
  final String? initialFilterLevel;

  const PatientListScreen({Key? key, this.initialFilterLevel}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late List<Patient> patients;
  late List<Patient> filteredPatients;
  String searchQuery = '';
  List<String> selectedFilters = [];
  String? filterLevel;

  @override
  void initState() {
    super.initState();
    filterLevel = widget.initialFilterLevel;
    patients = _getMockPatients();
    filteredPatients = patients;
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _onFilterChanged(List<String> filters) {
    setState(() {
      selectedFilters = filters;
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredPatients = patients.where((patient) {
      // Search filter
      final matchesSearch = searchQuery.isEmpty ||
          patient.name.toLowerCase().contains(searchQuery) ||
          patient.village.toLowerCase().contains(searchQuery);

      // Category filter
      final matchesCategory = selectedFilters.isEmpty ||
          _matchesCategory(patient, selectedFilters);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  bool _matchesCategory(Patient patient, List<String> filters) {
    // This would be extended based on patient data like category
    return true;
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return AppTheme.riskHigh;
      case RiskLevel.medium:
        return AppTheme.riskMedium;
      case RiskLevel.low:
        return AppTheme.riskLow;
    }
  }

  String _getRiskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return 'High';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.low:
        return 'Low';
    }
  }

  List<Patient> _getMockPatients() {
    return [
      Patient(
        id: '1',
        name: 'Savitri Devi',
        age: 52,
        gender: 'Female',
        village: 'Nandpur',
        riskLevel: RiskLevel.high,
        lastVisit: '2 days ago',
      ),
      Patient(
        id: '2',
        name: 'Reena Sharma',
        age: 28,
        gender: 'Female',
        village: 'Nandpur',
        riskLevel: RiskLevel.high,
        lastVisit: '5 days ago',
      ),
      Patient(
        id: '3',
        name: 'Anita Singh',
        age: 38,
        gender: 'Female',
        village: 'Vijaynagar',
        riskLevel: RiskLevel.medium,
        lastVisit: '1 week ago',
      ),
      Patient(
        id: '4',
        name: 'Ramesh Patel',
        age: 60,
        gender: 'Male',
        village: 'Shaktipur',
        riskLevel: RiskLevel.medium,
        lastVisit: '3 days ago',
      ),
      Patient(
        id: '5',
        name: 'Sunita Verma',
        age: 48,
        gender: 'Female',
        village: 'Lakhanpur',
        riskLevel: RiskLevel.medium,
        lastVisit: '4 days ago',
      ),
      Patient(
        id: '6',
        name: 'Deepak Sharma',
        age: 35,
        gender: 'Male',
        village: 'Nandpur',
        riskLevel: RiskLevel.low,
        lastVisit: '1 day ago',
      ),
      Patient(
        id: '7',
        name: 'Priya Gupta',
        age: 24,
        gender: 'Female',
        village: 'Vijaynagar',
        riskLevel: RiskLevel.low,
        lastVisit: '6 days ago',
      ),
      Patient(
        id: '8',
        name: 'Vikram Singh',
        age: 55,
        gender: 'Male',
        village: 'Shaktipur',
        riskLevel: RiskLevel.high,
        lastVisit: '1 week ago',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        elevation: 0,
      ),
      backgroundColor: AppTheme.bgLight,
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(
                  hintText: 'Search patients by name or village',
                  onSearch: _onSearch,
                  prefixIcon: Icons.search,
                ),
                const SizedBox(height: AppTheme.lg),
                Text(
                  'Filter by Category',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppTheme.md),
                FilterChips(
                  options: const ['Pregnant', 'Children', 'Elderly'],
                  selectedOptions: selectedFilters,
                  onSelectionChanged: _onFilterChanged,
                ),
              ],
            ),
          ),

          // Patient list
          Expanded(
            child: filteredPatients.isEmpty
                ? EmptyState(
                    icon: Icons.people_outline,
                    title: 'No Patients Found',
                    description: 'Try adjusting your search or filters',
                    actionLabel: 'Clear Filters',
                    onActionTap: () {
                      setState(() {
                        searchQuery = '';
                        selectedFilters = [];
                        _applyFilters();
                      });
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.lg,
                      vertical: AppTheme.md,
                    ),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.lg),
                        child: PatientCard(
                          name: patient.name,
                          age: patient.age.toString(),
                          category: 'General',
                          riskColor: _getRiskColor(patient.riskLevel),
                          riskLevel: _getRiskLabel(patient.riskLevel),
                          location: patient.village,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PatientDetailScreen(patient: patient),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
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
          FloatingActionButton(
            onPressed: () {
              // SOS
            },
            backgroundColor: AppTheme.emergencyRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            heroTag: 'sos_button_patients',
            child: const Icon(Icons.emergency, size: 28),
          ),
          FloatingActionButton(
            onPressed: () {
              // AI
            },
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            heroTag: 'ai_button_patients',
            child: const Icon(Icons.mic, size: 28),
          ),
        ],
      ),
    );
  }
}
    ];
  }

  List<Patient> get _filteredPatients {
    if (filterLevel == null) {
      return patients;
    } else if (filterLevel == 'high') {
      return patients.where((p) => p.riskLevel == RiskLevel.high).toList();
    } else if (filterLevel == 'medium') {
      return patients.where((p) => p.riskLevel == RiskLevel.medium).toList();
    }
    return patients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: filterLevel == null,
                        onSelected: (selected) {
                          setState(() => filterLevel = null);
                        },
                      ),
                      FilterChip(
                        label: const Text('High Risk'),
                        selected: filterLevel == 'high',
                        onSelected: (selected) {
                          setState(() => filterLevel = 'high');
                        },
                      ),
                      FilterChip(
                        label: const Text('Medium'),
                        selected: filterLevel == 'medium',
                        onSelected: (selected) {
                          setState(() => filterLevel = 'medium');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredPatients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          size: 64,
                          color: AppTheme.lightText,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No patients found',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.mediumText,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredPatients[index];
                      final Color riskColor;
                      final String riskLevelText;
                      
                      switch(patient.riskLevel) {
                        case RiskLevel.high:
                          riskColor = AppTheme.riskHigh;
                          riskLevelText = 'High Risk';
                          break;
                        case RiskLevel.medium:
                          riskColor = AppTheme.riskMedium;
                          riskLevelText = 'Medium Risk';
                          break;
                        case RiskLevel.low:
                          riskColor = AppTheme.riskLow;
                          riskLevelText = 'Low Risk';
                          break;
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PatientCard(
                          name: patient.name,
                          age: '${patient.age} years',
                          category: patient.gender.isEmpty ? 'Adult' : patient.gender,
                          riskColor: riskColor,
                          riskLevel: riskLevelText,
                          location: patient.village,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PatientDetailScreen(
                                  patient: patient,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
