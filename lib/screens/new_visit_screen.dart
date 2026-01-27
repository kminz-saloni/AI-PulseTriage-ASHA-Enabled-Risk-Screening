import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_action_buttons.dart';

class NewVisitScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientAge;
  final String patientCategory;
  final String patientRisk;

  const NewVisitScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientCategory,
    required this.patientRisk,
  }) : super(key: key);

  @override
  State<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends State<NewVisitScreen> {
  bool _isEnglish = true;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _symptomsController = TextEditingController();
  final _notesController = TextEditingController();
  final _temperatureController = TextEditingController();
  
  // Form state
  DateTime _visitDate = DateTime.now();
  String _selectedVisitType = '';
  String _symptomDuration = '';
  String _aiPriority = '';
  String _aiRecommendation = '';
  bool _aiCheckPerformed = false;
  
  // Actions taken
  bool _homeCareAdvised = false;
  bool _telemedicineConsulted = false;
  bool _referredToHospital = false;
  
  // Follow-up
  bool _followUpRequired = false;
  DateTime? _followUpDate;
  
  final List<String> _visitTypes = [
    'Antenatal care',
    'Immunization',
    'Follow-up',
    'Emergency',
    'Other',
  ];
  
  final Map<String, String> _visitTypesHindi = {
    'Antenatal care': 'प्रसवपूर्व देखभाल',
    'Immunization': 'टीकाकरण',
    'Follow-up': 'अनुवर्ती',
    'Emergency': 'आपातकाल',
    'Other': 'अन्य',
  };
  
  final List<String> _durations = [
    'Less than 24 hours',
    '1-3 days',
    '3-7 days',
    'More than a week',
  ];
  
  final Map<String, String> _durationsHindi = {
    'Less than 24 hours': '24 घंटे से कम',
    '1-3 days': '1-3 दिन',
    '3-7 days': '3-7 दिन',
    'More than a week': 'एक सप्ताह से अधिक',
  };

  @override
  void dispose() {
    _symptomsController.dispose();
    _notesController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
      case 'उच्च':
        return Colors.red;
      case 'medium':
      case 'मध्यम':
        return Colors.orange;
      case 'low':
      case 'कम':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('Pregnant') || category.contains('गर्भवती')) {
      return Icons.pregnant_woman;
    } else if (category.contains('Child') || category.contains('बच्चा')) {
      return Icons.child_care;
    } else if (category.contains('Elderly') || category.contains('बुजुर्ग')) {
      return Icons.elderly;
    }
    return Icons.person;
  }

  void _checkAIPriority() {
    // Simulate AI triage analysis
    setState(() {
      _aiCheckPerformed = true;
      
      // Simple logic for demo (in production, this would call an AI API)
      if (_symptomsController.text.toLowerCase().contains('fever') ||
          _symptomsController.text.toLowerCase().contains('बुखार')) {
        if (_selectedVisitType == 'Emergency') {
          _aiPriority = 'Emergency';
          _aiRecommendation = _isEnglish 
              ? 'Immediate medical attention required. Consider hospital referral.'
              : 'तत्काल चिकित्सा ध्यान आवश्यक है। अस्पताल रेफरल पर विचार करें।';
        } else {
          _aiPriority = 'Urgent';
          _aiRecommendation = _isEnglish
              ? 'Monitor closely. Telemedicine consultation recommended.'
              : 'बारीकी से निगरानी करें। टेलीमेडिसिन परामर्श की सिफारिश की गई।';
        }
      } else if (_selectedVisitType == 'Emergency') {
        _aiPriority = 'Urgent';
        _aiRecommendation = _isEnglish
            ? 'Assess symptoms carefully. Consider telemedicine consultation.'
            : 'लक्षणों का सावधानीपूर्वक आकलन करें। टेलीमेडिसिन परामर्श पर विचार करें।';
      } else {
        _aiPriority = 'Routine';
        _aiRecommendation = _isEnglish
            ? 'Regular monitoring and follow-up as scheduled.'
            : 'नियमित निगरानी और अनुसूची के अनुसार अनुवर्ती।';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish 
              ? '✓ AI analysis completed' 
              : '✓ AI विश्लेषण पूर्ण',
        ),
        backgroundColor: AppTheme.primaryTeal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveVisit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish 
                ? '⚠ Please fill all required fields' 
                : '⚠ कृपया सभी आवश्यक फ़ील्ड भरें',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedVisitType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish 
                ? '⚠ Please select visit type' 
                : '⚠ कृपया दौरे का प्रकार चुनें',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_aiCheckPerformed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish 
                ? '⚠ Please check AI priority before saving' 
                : '⚠ कृपया सहेजने से पहले AI प्राथमिकता जांचें',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isEnglish ? 'Visit Saved!' : 'दौरा सहेजा गया!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          _isEnglish
              ? 'Visit for ${widget.patientName} has been recorded successfully.\n\nPriority: $_aiPriority'
              : '${widget.patientName} के लिए दौरा सफलतापूर्वक रिकॉर्ड किया गया है।\n\nप्राथमिकता: $_aiPriority',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to Patient Profile
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              _isEnglish ? 'Back to Profile' : 'प्रोफाइल पर वापस जाएं',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _isEnglish ? 'New Visit' : 'नया दौरा',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => setState(() => _isEnglish = !_isEnglish),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 24, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          _isEnglish ? 'EN' : 'HI',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Context Header
                  _buildPatientContextCard(),
                  
                  const SizedBox(height: 24),

                  // SECTION 1: Visit Details
                  _buildSectionHeader(
                    icon: Icons.calendar_today,
                    title: _isEnglish ? 'Visit Details' : 'दौरा विवरण',
                  ),
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  _buildVisitTypeDropdown(),

                  const SizedBox(height: 24),

                  // SECTION 2: Symptoms & Observations
                  _buildSectionHeader(
                    icon: Icons.medical_services,
                    title: _isEnglish ? 'Symptoms & Observations' : 'लक्षण और अवलोकन',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _symptomsController,
                    label: _isEnglish ? 'Symptoms Description *' : 'लक्षणों का विवरण *',
                    icon: Icons.description,
                    maxLines: 4,
                    required: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.mic, color: AppTheme.primaryTeal),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isEnglish 
                                  ? '🎤 Voice input activated' 
                                  : '🎤 आवाज़ इनपुट सक्रिय',
                            ),
                            backgroundColor: AppTheme.primaryTeal,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDurationDropdown(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _temperatureController,
                    label: _isEnglish ? 'Temperature (°F)' : 'तापमान (°F)',
                    icon: Icons.thermostat,
                    keyboardType: TextInputType.number,
                    required: false,
                  ),

                  const SizedBox(height: 24),

                  // SECTION 3: AI Triage & Priority
                  _buildSectionHeader(
                    icon: Icons.psychology,
                    title: _isEnglish ? 'AI Triage & Priority' : 'AI ट्राइएज और प्राथमिकता',
                  ),
                  const SizedBox(height: 16),
                  _buildAITriageSection(),

                  const SizedBox(height: 24),

                  // SECTION 4: Actions Taken
                  _buildSectionHeader(
                    icon: Icons.check_circle,
                    title: _isEnglish ? 'Actions Taken' : 'की गई कार्रवाई',
                  ),
                  const SizedBox(height: 16),
                  _buildActionsCheckboxes(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _notesController,
                    label: _isEnglish ? 'Notes' : 'नोट्स',
                    icon: Icons.notes,
                    maxLines: 3,
                    required: false,
                  ),

                  const SizedBox(height: 24),

                  // SECTION 5: Follow-up
                  _buildSectionHeader(
                    icon: Icons.event_repeat,
                    title: _isEnglish ? 'Follow-up' : 'अनुवर्ती',
                  ),
                  const SizedBox(height: 16),
                  _buildFollowUpSection(),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveVisit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            _isEnglish ? 'Save Visit' : 'दौरा सहेजें',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Space for floating buttons
                ],
              ),
            ),
          ),
          // Floating Action Buttons (SOS & Voice Assistant)
          FloatingActionButtonsWidget(
            isEnglish: _isEnglish,
            initialSosPosition: const Offset(16, 20),
            initialVoicePosition: const Offset(16, 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientContextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryTeal.withOpacity(0.8), AppTheme.accentTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryTeal.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(widget.patientCategory),
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_isEnglish ? "Age" : "उम्र"}: ${widget.patientAge} | ${widget.patientCategory}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  color: _getRiskColor(widget.patientRisk),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.patientRisk,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.primaryTeal.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryTeal, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTeal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return _isEnglish ? 'This field is required' : 'यह फ़ील्ड आवश्यक है';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryTeal),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryTeal, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _visitDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _visitDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppTheme.primaryTeal),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? 'Visit Date *' : 'दौरा तिथि *',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy').format(_visitDate),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(_isEnglish ? 'Visit Type *' : 'दौरे का प्रकार *'),
          value: _selectedVisitType.isEmpty ? null : _selectedVisitType,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryTeal),
          items: _visitTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Icon(
                    type == 'Emergency' ? Icons.emergency : Icons.medical_services,
                    size: 20,
                    color: type == 'Emergency' ? Colors.red : AppTheme.primaryTeal,
                  ),
                  const SizedBox(width: 12),
                  Text(_isEnglish ? type : _visitTypesHindi[type]!),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedVisitType = value!);
          },
        ),
      ),
    );
  }

  Widget _buildDurationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(_isEnglish ? 'Duration of symptoms' : 'लक्षणों की अवधि'),
          value: _symptomDuration.isEmpty ? null : _symptomDuration,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryTeal),
          items: _durations.map((duration) {
            return DropdownMenuItem(
              value: duration,
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: AppTheme.primaryTeal),
                  const SizedBox(width: 12),
                  Text(_isEnglish ? duration : _durationsHindi[duration]!),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _symptomDuration = value!);
          },
        ),
      ),
    );
  }

  Widget _buildAITriageSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _symptomsController.text.isEmpty
                ? null
                : _checkAIPriority,
            icon: const Icon(Icons.psychology, color: Colors.white),
            label: Text(
              _isEnglish ? 'Check Priority' : 'प्राथमिकता जांचें',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
        ),
        if (_aiCheckPerformed) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getPriorityColor(_aiPriority).withOpacity(0.1),
                  _getPriorityColor(_aiPriority).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getPriorityColor(_aiPriority),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getPriorityEmoji(_aiPriority),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isEnglish ? 'Priority: $_aiPriority' : 'प्राथमिकता: $_aiPriority',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(_aiPriority),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _isEnglish ? 'Recommendation:' : 'सिफारिश:',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _aiRecommendation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Emergency':
        return Colors.red;
      case 'Urgent':
        return Colors.orange;
      case 'Moderate':
        return Colors.amber;
      case 'Routine':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityEmoji(String priority) {
    switch (priority) {
      case 'Emergency':
        return '🔴';
      case 'Urgent':
        return '🟠';
      case 'Moderate':
        return '🟡';
      case 'Routine':
        return '🟢';
      default:
        return '⚪';
    }
  }

  Widget _buildActionsCheckboxes() {
    return Column(
      children: [
        _buildCheckbox(
          label: _isEnglish ? 'Home care advised' : 'घरेलू देखभाल की सलाह दी',
          value: _homeCareAdvised,
          onChanged: (val) => setState(() => _homeCareAdvised = val!),
        ),
        const SizedBox(height: 12),
        _buildCheckbox(
          label: _isEnglish ? 'Telemedicine consulted' : 'टेलीमेडिसिन से परामर्श लिया',
          value: _telemedicineConsulted,
          onChanged: (val) => setState(() => _telemedicineConsulted = val!),
        ),
        const SizedBox(height: 12),
        _buildCheckbox(
          label: _isEnglish ? 'Referred to hospital' : 'अस्पताल में रेफर किया गया',
          value: _referredToHospital,
          onChanged: (val) => setState(() => _referredToHospital = val!),
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? AppTheme.primaryTeal.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? AppTheme.primaryTeal : Colors.grey[300]!,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? AppTheme.primaryTeal : Colors.white,
                border: Border.all(
                  color: value ? AppTheme.primaryTeal : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                  color: value ? AppTheme.primaryTeal : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFollowUpOption(
                label: _isEnglish ? 'Yes' : 'हाँ',
                value: true,
                groupValue: _followUpRequired,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFollowUpOption(
                label: _isEnglish ? 'No' : 'नहीं',
                value: false,
                groupValue: _followUpRequired,
              ),
            ),
          ],
        ),
        if (_followUpRequired) ...[
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _followUpDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event, color: AppTheme.primaryTeal),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEnglish ? 'Follow-up Date' : 'अनुवर्ती तिथि',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _followUpDate != null
                              ? DateFormat('dd MMM yyyy').format(_followUpDate!)
                              : (_isEnglish ? 'Select date' : 'तिथि चुनें'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFollowUpOption({
    required String label,
    required bool value,
    required bool groupValue,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => setState(() => _followUpRequired = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryTeal.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryTeal : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppTheme.primaryTeal : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
