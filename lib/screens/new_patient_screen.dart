import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_action_buttons.dart';

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({Key? key}) : super(key: key);

  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  bool _isEnglish = true;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _villageController = TextEditingController();
  final _householdController = TextEditingController();
  final _symptomsController = TextEditingController();
  
  // Form state
  String _selectedGender = '';
  String _selectedCategory = '';
  DateTime _visitDate = DateTime.now();
  String _selectedReason = '';
  bool _consentObtained = false;
  
  final List<String> _visitReasons = [
    'Antenatal care',
    'Immunization',
    'Fever',
    'Follow-up',
    'Other',
  ];
  
  final Map<String, String> _visitReasonsHindi = {
    'Antenatal care': 'प्रसवपूर्व देखभाल',
    'Immunization': 'टीकाकरण',
    'Fever': 'बुखार',
    'Follow-up': 'अनुवर्ती',
    'Other': 'अन्य',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _villageController.dispose();
    _householdController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _savePatient() {
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

    if (_selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish ? '⚠ Please select gender' : '⚠ कृपया लिंग चुनें',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish 
                ? '⚠ Please select patient category' 
                : '⚠ कृपया रोगी श्रेणी चुनें',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish 
                ? '⚠ Please select visit reason' 
                : '⚠ कृपया दौरे का कारण चुनें',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_consentObtained) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish 
                ? '⚠ Patient consent is required' 
                : '⚠ रोगी की सहमति आवश्यक है',
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
                _isEnglish ? 'Success!' : 'सफलता!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          _isEnglish
              ? 'Patient "${_nameController.text}" has been registered successfully.\n\nYou can now add future visits to this patient record.'
              : 'रोगी "${_nameController.text}" सफलतापूर्वक पंजीकृत हो गया है।\n\nअब आप इस रोगी रिकॉर्ड में भविष्य के दौरे जोड़ सकते हैं।',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to Home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              _isEnglish ? 'Go to Home' : 'होम पर जाएं',
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
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _isEnglish ? 'New Patient' : 'नया मरीज़',
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
                  // SECTION 1: Basic Details
                  _buildSectionHeader(
                    icon: Icons.person,
                    title: _isEnglish ? 'Basic Details' : 'मूल विवरण',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nameController,
                    label: _isEnglish ? 'Patient Name *' : 'मरीज़ का नाम *',
                    icon: Icons.person_outline,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderSelection(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _ageController,
                          label: _isEnglish ? 'Age *' : 'उम्र *',
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _mobileController,
                          label: _isEnglish ? 'Mobile Number' : 'मोबाइल नंबर',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          required: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // SECTION 2: Patient Category
                  _buildSectionHeader(
                    icon: Icons.category,
                    title: _isEnglish ? 'Patient Category *' : 'मरीज़ श्रेणी *',
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCards(),

                  const SizedBox(height: 24),

                  // SECTION 3: Address & Area
                  _buildSectionHeader(
                    icon: Icons.location_on,
                    title: _isEnglish ? 'Address & Area' : 'पता और क्षेत्र',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _villageController,
                    label: _isEnglish ? 'Village / Area Name *' : 'गांव / क्षेत्र का नाम *',
                    icon: Icons.home,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _householdController,
                    label: _isEnglish ? 'Household Number' : 'घर संख्या',
                    icon: Icons.house,
                    required: false,
                  ),

                  const SizedBox(height: 24),

                  // SECTION 4: Initial Visit Details
                  _buildSectionHeader(
                    icon: Icons.medical_services,
                    title: _isEnglish ? 'First Visit Details *' : 'पहली दौरा विवरण *',
                    subtitle: _isEnglish 
                        ? 'This represents the initial visit for this patient' 
                        : 'यह इस रोगी की पहली दौरा को दर्शाता है',
                  ),
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  _buildReasonDropdown(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _symptomsController,
                    label: _isEnglish ? 'Symptoms / Notes' : 'लक्षण / नोट्स',
                    icon: Icons.notes,
                    maxLines: 3,
                    required: false,
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

                  const SizedBox(height: 24),

                  // SECTION 5: Consent
                  _buildSectionHeader(
                    icon: Icons.verified_user,
                    title: _isEnglish ? 'Consent' : 'सहमति',
                  ),
                  const SizedBox(height: 12),
                  _buildConsentCheckbox(),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _savePatient,
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
                            _isEnglish ? 'Save Patient' : 'मरीज़ सहेजें',
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

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryTeal, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
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

  Widget _buildGenderSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? 'Gender *' : 'लिंग *',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption('Male', 'पुरुष', Icons.male),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderOption('Female', 'महिला', Icons.female),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderOption('Other', 'अन्य', Icons.transgender),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String value, String valueHindi, IconData icon) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () => setState(() => _selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryTeal.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primaryTeal : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryTeal : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish ? value : valueHindi,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryTeal : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCards() {
    final categories = [
      {'value': 'pregnant', 'label': 'Pregnant Woman', 'labelHindi': 'गर्भवती महिला', 'icon': Icons.pregnant_woman, 'color': Colors.pink},
      {'value': 'child', 'label': 'Child (0-5)', 'labelHindi': 'बच्चा (0-5)', 'icon': Icons.child_care, 'color': Colors.orange},
      {'value': 'adult', 'label': 'Adult', 'labelHindi': 'वयस्क', 'icon': Icons.person, 'color': Colors.blue},
      {'value': 'elderly', 'label': 'Elderly', 'labelHindi': 'बुजुर्ग', 'icon': Icons.elderly, 'color': Colors.purple},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: categories.map((category) {
        final isSelected = _selectedCategory == category['value'];
        return InkWell(
          onTap: () => setState(() => _selectedCategory = category['value'] as String),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? (category['color'] as Color).withOpacity(0.1) 
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? category['color'] as Color 
                    : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(
                      color: (category['color'] as Color).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: isSelected ? category['color'] as Color : Colors.grey[600],
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  _isEnglish ? category['label'] as String : category['labelHindi'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? category['color'] as Color : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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

  Widget _buildReasonDropdown() {
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
          hint: Text(_isEnglish ? 'Reason for visit *' : 'दौरे का कारण *'),
          value: _selectedReason.isEmpty ? null : _selectedReason,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryTeal),
          items: _visitReasons.map((reason) {
            return DropdownMenuItem(
              value: reason,
              child: Row(
                children: [
                  const Icon(Icons.medical_services, size: 20, color: AppTheme.primaryTeal),
                  const SizedBox(width: 12),
                  Text(_isEnglish ? reason : _visitReasonsHindi[reason]!),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedReason = value!);
          },
        ),
      ),
    );
  }

  Widget _buildConsentCheckbox() {
    return InkWell(
      onTap: () => setState(() => _consentObtained = !_consentObtained),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _consentObtained 
              ? Colors.green.withOpacity(0.1) 
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _consentObtained ? Colors.green : Colors.grey[300]!,
            width: _consentObtained ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _consentObtained ? Colors.green : Colors.white,
                border: Border.all(
                  color: _consentObtained ? Colors.green : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: _consentObtained
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isEnglish 
                    ? 'Patient consent obtained *' 
                    : 'रोगी की सहमति प्राप्त है *',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: _consentObtained ? FontWeight.w600 : FontWeight.normal,
                  color: _consentObtained ? Colors.green : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
