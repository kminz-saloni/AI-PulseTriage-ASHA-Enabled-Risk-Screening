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
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEnglish
            ? 'Please enter a valid 6-digit OTP'
            : 'कृपया एक वैध 6-अंकीय OTP दर्ज करें'
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with language toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEnglish ? 'AASHA Sathi' : 'आशा साथी',
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
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderColor),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isEnglish = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.md,
                                vertical: AppTheme.xs,
                              ),
                              decoration: BoxDecoration(
                                color: _isEnglish ? AppTheme.primaryTeal : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Text(
                                'EN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _isEnglish ? Colors.white : AppTheme.mediumText,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isEnglish = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.md,
                                vertical: AppTheme.xs,
                              ),
                              decoration: BoxDecoration(
                                color: !_isEnglish ? AppTheme.primaryTeal : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Text(
                                'HI',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: !_isEnglish ? Colors.white : AppTheme.mediumText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.xxl),

                if (_isPhoneStep) ...[
                  // Phone number step
                  Text(
                    _isEnglish ? 'Enter Your Phone Number' : 'अपना फोन नंबर दर्ज करें',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.md),
                  Text(
                    _isEnglish 
                      ? 'We will send you an OTP to verify your account'
                      : 'हम आपके खाते को सत्यापित करने के लिए एक OTP भेजेंगे',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumText,
                    ),
                  ),
                  const SizedBox(height: AppTheme.xl),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: '9876543210',
                      prefixIcon: const Icon(Icons.phone),
                      counterText: '',
                      prefixText: '+91 ',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.xl),
                  LargeButton(
                    label: _isEnglish ? 'Get OTP' : 'OTP प्राप्त करें',
                    onPressed: _submitPhone,
                    icon: Icons.arrow_forward,
                    isEnabled: _phoneController.text.length == 10,
                  ),
                  const SizedBox(height: AppTheme.lg),
                  Center(
                    child: TextActionButton(
                      label: _isEnglish ? 'Need Help?' : 'सहायता चाहिए?',
                      onPressed: () {
                        // Show help dialog
                      },
                      icon: Icons.help_outline,
                    ),
                  ),
                ] else ...[
                  // OTP verification step
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() => _isPhoneStep = true);
                          _otpController.clear();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEnglish ? 'Verify OTP' : 'OTP सत्यापित करें',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppTheme.xs),
                            Text(
                              _isEnglish
                                ? 'Sent to +91 ${_phoneController.text}'
                                : '+91 ${_phoneController.text} को भेजा गया',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.lg),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: '000000',
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: AppTheme.xl),
                  LargeButton(
                    label: _isEnglish ? 'Verify & Login' : 'सत्यापित करें और लॉगिन करें',
                    onPressed: _submitOTP,
                    isLoading: _isLoading,
                    icon: Icons.verified,
                    isEnabled: _otpController.text.length == 6 && !_isLoading,
                  ),
                  const SizedBox(height: AppTheme.lg),
                  Center(
                    child: TextActionButton(
                      label: _isEnglish ? 'Resend OTP' : 'OTP पुनः भेजें',
                      onPressed: () {
                        // Resend logic
                      },
                      icon: Icons.refresh,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                LargeButton(
                  label: _isEnglish ? 'Login' : 'लॉगिन करें',
                  onPressed: _login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
