import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/input_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isPhoneStep = true;
  bool _isLoading = false;
  bool _isEnglish = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _submitPhone() {
    if (_phoneController.text.length == 10) {
      // Clear OTP field when moving to OTP step
      _otpController.clear();
      setState(() {
        _isPhoneStep = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEnglish 
            ? 'Please enter a valid 10-digit number'
            : 'कृपया एक वैध 10-अंकीय संख्या दर्ज करें'
          ),
        ),
      );
    }
  }

  void _submitOTP() {
    if (_otpController.text.length == 6) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Clear phone and OTP before navigation
          _phoneController.clear();
          _otpController.clear();
          
          // Navigate to main screen
          Navigator.of(context).pushReplacementNamed('/main');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEnglish
            ? 'Please enter all 6 digits'
            : 'कृपया सभी 6 अंक दर्ज करें'
          ),
        ),
      );
    }
  }

  void _login() {
    if (_isPhoneStep) {
      _submitPhone();
    } else {
      _submitOTP();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppTheme.xxl),
              // Logo area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEnglish ? 'AASHA-TRIAGE' : 'आशा-ट्रायज',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppTheme.xs),
                      Text(
                        _isEnglish 
                          ? 'Healthcare Guidance'
                          : 'स्वास्थ्य सेवा मार्गदर्शन',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumText,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 44,
                      color: AppTheme.primaryTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.xxl),

              // Phone/OTP form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isPhoneStep) ...[
                        Text(
                          _isEnglish ? 'Enter Phone Number' : 'फोन नंबर दर्ज करें',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppTheme.md),
                        Text(
                          _isEnglish 
                            ? 'We will send you an OTP to verify'
                            : 'हम आपको सत्यापन के लिए OTP भेजेंगे',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumText,
                          ),
                        ),
                        const SizedBox(height: AppTheme.xl),
                        TextField(
                          controller: _phoneController,
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: '10-digit mobile number',
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              borderSide: const BorderSide(color: AppTheme.primaryTeal, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.md,
                              vertical: AppTheme.md,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          keyboardType: TextInputType.phone,
                        ),
                      ] else ...[
                        Text(
                          _isEnglish ? 'Enter OTP' : 'OTP दर्ज करें',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppTheme.md),
                        Text(
                          _isEnglish
                            ? 'Code sent to +91 ${_phoneController.text}'
                            : '+91 ${_phoneController.text} पर कोड भेजा गया',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumText,
                          ),
                        ),
                        const SizedBox(height: AppTheme.md),
                        // Demo OTP display
                        Container(
                          padding: const EdgeInsets.all(AppTheme.md),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            border: Border.all(color: AppTheme.primaryTeal.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _isEnglish ? 'Demo OTP' : 'डेमो OTP',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.mediumText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppTheme.xs),
                              Text(
                                '123456',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.primaryTeal,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: AppTheme.xs),
                              Text(
                                _isEnglish 
                                  ? '(Enter this code below)'
                                  : '(नीचे यह कोड दर्ज करें)',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.lightText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.xl),
                        // OTP input field
                        TextField(
                          controller: _otpController,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter 6-digit OTP',
                            counterText: '${_otpController.text.length}/6',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              borderSide: const BorderSide(color: AppTheme.primaryTeal, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.md,
                              vertical: AppTheme.md,
                            ),
                          ),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            letterSpacing: 8,
                          ),
                          onChanged: (value) {
                            setState(() {}); // Update counter
                          },
                        ),
                        const SizedBox(height: AppTheme.lg),
                        // Visual OTP boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            String digit = _otpController.text.length > index 
                              ? _otpController.text[index] 
                              : '';
                            return Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: digit.isNotEmpty 
                                    ? AppTheme.primaryTeal 
                                    : AppTheme.borderColor,
                                  width: digit.isNotEmpty ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                color: digit.isNotEmpty 
                                  ? AppTheme.primaryTeal.withOpacity(0.1)
                                  : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                digit,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.primaryTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: AppTheme.lg),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.xl),

              // Login button
              _isLoading
                  ? SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          disabledBackgroundColor: AppTheme.primaryTeal.withOpacity(0.6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: AppTheme.md),
                            Text(
                              _isEnglish ? 'Logging in...' : 'लॉगिन हो रहा है...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : LargeButton(
                      label: _isEnglish ? 'Login' : 'लॉगिन करें',
                      onPressed: _login,
                    ),
              const SizedBox(height: AppTheme.lg),

              // Language toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                        side: BorderSide(
                          color: _isEnglish ? AppTheme.primaryTeal : AppTheme.borderColor,
                          width: 2,
                        ),
                      ),
                      onPressed: () => setState(() => _isEnglish = true),
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isEnglish ? AppTheme.primaryTeal : AppTheme.mediumText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.md),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                        side: BorderSide(
                          color: !_isEnglish ? AppTheme.primaryTeal : AppTheme.borderColor,
                          width: 2,
                        ),
                      ),
                      onPressed: () => setState(() => _isEnglish = false),
                      child: Text(
                        'हिंदी',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: !_isEnglish ? AppTheme.primaryTeal : AppTheme.mediumText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
