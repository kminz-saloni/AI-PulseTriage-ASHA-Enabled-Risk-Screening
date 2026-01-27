import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Patient Model
class PatientInfo {
  final String id;
  final String name;
  final String nameHindi;
  final int age;
  final String category;
  final String categoryHindi;
  final String riskLevel; // 'high', 'medium', 'low'
  final String lastVisit;
  final String lastVisitHindi;

  PatientInfo({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.age,
    required this.category,
    required this.categoryHindi,
    required this.riskLevel,
    required this.lastVisit,
    required this.lastVisitHindi,
  });
}

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({Key? key}) : super(key: key);

  @override
  State<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  bool _isEnglish = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  
  // Draggable button positions
  Offset _voiceButtonOffset = const Offset(20, -120);
  Offset _sosButtonOffset = const Offset(20, -120);
  
  final List<PatientInfo> _allPatients = [
    PatientInfo(
      id: '1',
      name: 'Sunita Devi',
      nameHindi: 'सुनीता देवी',
      age: 28,
      category: 'Pregnant',
      categoryHindi: 'गर्भवती',
      riskLevel: 'high',
      lastVisit: '2 days ago',
      lastVisitHindi: '2 दिन पहले',
    ),
    PatientInfo(
      id: '2',
      name: 'Baby Rahul',
      nameHindi: 'बच्चा राहुल',
      age: 1,
      category: 'Child',
      categoryHindi: 'बच्चा',
      riskLevel: 'medium',
      lastVisit: '5 days ago',
      lastVisitHindi: '5 दिन पहले',
    ),
    PatientInfo(
      id: '3',
      name: 'Ram Lal',
      nameHindi: 'राम लाल',
      age: 68,
      category: 'Elderly',
      categoryHindi: 'बुजुर्ग',
      riskLevel: 'high',
      lastVisit: '1 week ago',
      lastVisitHindi: '1 सप्ताह पहले',
    ),
    PatientInfo(
      id: '4',
      name: 'Geeta Sharma',
      nameHindi: 'गीता शर्मा',
      age: 32,
      category: 'Pregnant',
      categoryHindi: 'गर्भवती',
      riskLevel: 'medium',
      lastVisit: '3 days ago',
      lastVisitHindi: '3 दिन पहले',
    ),
    PatientInfo(
      id: '5',
      name: 'Anita Singh',
      nameHindi: 'अनीता सिंह',
      age: 45,
      category: 'High-risk',
      categoryHindi: 'उच्च जोखिम',
      riskLevel: 'high',
      lastVisit: '1 day ago',
      lastVisitHindi: '1 दिन पहले',
    ),
    PatientInfo(
      id: '6',
      name: 'Baby Priya',
      nameHindi: 'बच्ची प्रिया',
      age: 2,
      category: 'Child',
      categoryHindi: 'बच्चा',
      riskLevel: 'low',
      lastVisit: '1 week ago',
      lastVisitHindi: '1 सप्ताह पहले',
    ),
    PatientInfo(
      id: '7',
      name: 'Shanti Devi',
      nameHindi: 'शांति देवी',
      age: 72,
      category: 'Elderly',
      categoryHindi: 'बुजुर्ग',
      riskLevel: 'medium',
      lastVisit: '4 days ago',
      lastVisitHindi: '4 दिन पहले',
    ),
    PatientInfo(
      id: '8',
      name: 'Radha Kumari',
      nameHindi: 'राधा कुमारी',
      age: 26,
      category: 'Pregnant',
      categoryHindi: 'गर्भवती',
      riskLevel: 'low',
      lastVisit: '6 days ago',
      lastVisitHindi: '6 दिन पहले',
    ),
  ];
  
  List<PatientInfo> get _filteredPatients {
    return _allPatients.where((patient) {
      // Apply search filter
      final searchMatch = _searchQuery.isEmpty ||
          patient.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          patient.nameHindi.contains(_searchQuery);
      
      // Apply category filter
      final categoryMatch = _selectedFilter == 'All' ||
          patient.category == _selectedFilter;
      
      return searchMatch && categoryMatch;
    }).toList();
  }

  
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _addNewPatient() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEnglish ? 'Add New Patient' : 'नया मरीज़ जोड़ें'),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // App Bar with Navigation and Language Toggle
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryTeal, AppTheme.accentTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        // Home Button
                        IconButton(
                          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
                          icon: const Icon(Icons.home, color: Colors.white, size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 16),
                        // Title
                        Expanded(
                          child: Text(
                            _isEnglish ? 'Patient Management' : 'रोगी प्रबंधन',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Profile Icon Button
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isEnglish ? 'Profile' : 'प्रोफ़ाइल'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person, color: Colors.white, size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        // Language Toggle
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _isEnglish = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _isEnglish ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'EN',
                                    style: TextStyle(
                                      color: _isEnglish ? AppTheme.primaryTeal : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _isEnglish = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: !_isEnglish ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'हिन्दी',
                                    style: TextStyle(
                                      color: !_isEnglish ? AppTheme.primaryTeal : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: _isEnglish ? 'Search patient name...' : 'मरीज़ का नाम खोजें...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryTeal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'सभी'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pregnant', 'गर्भवती'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Child', 'बच्चा'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Elderly', 'बुजुर्ग'),
                      const SizedBox(width: 8),
                      _buildFilterChip('High-risk', 'उच्च जोखिम'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Patient Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      _isEnglish
                          ? '${_filteredPatients.length} Patients'
                          : '${_filteredPatients.length} मरीज़',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Patient List
              Expanded(
                child: _filteredPatients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _isEnglish ? 'No patients found' : 'कोई मरीज़ नहीं मिला',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredPatients.length,
                        itemBuilder: (context, index) {
                          return _buildPatientCard(_filteredPatients[index]);
                        },
                      ),
              ),
            ],
          ),

          // Floating Add Button
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: _addNewPatient,
              backgroundColor: AppTheme.primaryTeal,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
              heroTag: 'add_patient_mgmt',
            ),
          ),

          // Draggable Voice Assistant Button (Bottom-Right)
          Positioned(
            right: _voiceButtonOffset.dx,
            bottom: _voiceButtonOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _voiceButtonOffset = Offset(
                    (_voiceButtonOffset.dx - details.delta.dx).clamp(20.0, size.width - 80),
                    (_voiceButtonOffset.dy - details.delta.dy).clamp(-size.height + 180, -20.0),
                  );
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEnglish ? 'Voice Assistant' : 'आवाज़ सहायक'),
                      backgroundColor: AppTheme.primaryTeal,
                    ),
                  );
                },
                backgroundColor: AppTheme.primaryTeal,
                child: const Icon(Icons.mic, color: Colors.white, size: 28),
                heroTag: 'voice_patient_mgmt',
              ),
            ),
          ),

          // Draggable SOS Button (Bottom-Left)
          Positioned(
            left: _sosButtonOffset.dx,
            bottom: _sosButtonOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _sosButtonOffset = Offset(
                    (_sosButtonOffset.dx + details.delta.dx).clamp(20.0, size.width - 80),
                    (_sosButtonOffset.dy - details.delta.dy).clamp(-size.height + 180, -20.0),
                  );
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEnglish ? 'SOS Emergency' : 'एसओएस आपातकाल'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.warning, color: Colors.white, size: 28),
                heroTag: 'sos_patient_mgmt',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String labelHindi) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryTeal : Colors.grey[300]!,
          ),
        ),
        child: Text(
          _isEnglish ? label : labelHindi,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(PatientInfo patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEnglish
                      ? 'Opening ${patient.name}'
                      : '${patient.nameHindi} खोल रहे हैं',
                ),
                backgroundColor: AppTheme.primaryTeal,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Risk Indicator Dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getRiskColor(patient.riskLevel),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Patient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        _isEnglish ? patient.name : patient.nameHindi,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Age and Category
                      Row(
                        children: [
                          Text(
                            '${patient.age} ${_isEnglish ? 'years' : 'वर्ष'}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _isEnglish ? patient.category : patient.categoryHindi,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.primaryTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Last Visit
                      Text(
                        '${_isEnglish ? 'Last visit: ' : 'अंतिम यात्रा: '}${_isEnglish ? patient.lastVisit : patient.lastVisitHindi}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
