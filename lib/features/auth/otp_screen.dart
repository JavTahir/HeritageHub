import 'package:family_tree_app/core/constants/theme/theme.dart';
import 'package:family_tree_app/providers/registeration_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../core/services/firebase_service.dart';
import '../../core/utils/loading_dialog.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  bool _isCodeSent = false;
  bool _isVerified = false;
  String _countryCode = '+91';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    showLoadingDialog(context);
    try {
      await FirebaseService.auth.verifyPhoneNumber(
        phoneNumber: _countryCode + _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseService.auth.signInWithCredential(credential);
          Navigator.pop(context);
          setState(() {
            _isVerified = true;
          });
          Fluttertoast.showToast(msg: 'Auto verification successful');
        },
        verificationFailed: (FirebaseAuthException e) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pop(context);
          setState(() {
            _verificationId = verificationId;
            _isCodeSent = true;
          });
          Fluttertoast.showToast(msg: 'OTP sent successfully');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  Future<void> _verifyOTP() async {
    showLoadingDialog(context);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await FirebaseService.auth.signInWithCredential(credential);
      Navigator.pop(context);
      setState(() {
        _isVerified = true;
      });
      Fluttertoast.showToast(msg: 'Login successful');

      final provider =
          Provider.of<RegistrationProvider>(context, listen: false);
      final hasHeadData = await provider.loadFamilyData();

      if (!hasHeadData) {
        Navigator.pushReplacementNamed(context, '/headRegistration');
      } else {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Invalid OTP');
    }
  }

  void _resendOTP() {
    _phoneController.clear();
    _otpController.clear();
    setState(() {
      _isCodeSent = false;
      _isVerified = false;
    });
    Fluttertoast.showToast(msg: 'Enter your phone number again to resend OTP');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: AppTheme.elevatedShadow,
                        ),
                        child: Image.asset(
                          'assets/heritage_hub_logo_bg.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title and Subtitle
                    Text(
                      _isCodeSent ? 'Verify OTP' : 'Phone Verification',
                      style: AppTheme.headingLarge.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      _isCodeSent
                          ? 'Enter the verification code sent to\n${_countryCode} ${_phoneController.text}'
                          : 'We need to verify your phone number\nto secure your family tree',
                      style: AppTheme.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 50),
                    AppTheme.cardContainer(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          if (!_isVerified) ...[
                            if (!_isCodeSent) ...[
                              _buildPhoneInputSection(),
                            ] else ...[
                              _buildOTPInputSection(),
                            ],
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: AppTheme.cardRadius,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Colors.white.withOpacity(0.8),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your privacy is protected. We use secure authentication to keep your family data safe.',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
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
        ),
      ),
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTheme.headingSmall.copyWith(
            color: AppTheme.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.inputRadius,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryMagenta.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: IntlPhoneField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Enter your phone number',
              border: OutlineInputBorder(
                borderRadius: AppTheme.inputRadius,
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              labelStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.lightGray,
              ),
            ),
            initialCountryCode: 'IN',
            onCountryChanged: (country) {
              _countryCode = '+${country.dialCode}';
            },
            style: AppTheme.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: AppTheme.buttonRadius,
            boxShadow: AppTheme.buttonShadow,
          ),
          child: ElevatedButton(
            onPressed: _verifyPhoneNumber,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.buttonRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Send Verification Code',
                  style: AppTheme.buttonText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Code',
          style: AppTheme.headingSmall.copyWith(
            color: AppTheme.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.inputRadius,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryMagenta.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: TextField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: 'Enter 6-digit code',
              border: OutlineInputBorder(
                borderRadius: AppTheme.inputRadius,
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              labelStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.lightGray,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryMagenta.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.security,
                  color: AppTheme.primaryMagenta,
                  size: 20,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
            ),
            maxLength: 6,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                null,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: AppTheme.buttonRadius,
            boxShadow: AppTheme.buttonShadow,
          ),
          child: ElevatedButton(
            onPressed: _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.buttonRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_rounded, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Verify & Continue',
                  style: AppTheme.buttonText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.darkGray),
            ),
            TextButton(
              onPressed: _resendOTP,
              child: Text(
                'Resend',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryMagenta,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
