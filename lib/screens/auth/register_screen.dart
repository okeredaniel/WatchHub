import 'package:flutter/material.dart';
import '../../app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _label('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: 'Vincze Nikolett'),

                  const SizedBox(height: 16),

                  _label('Work Email'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: 'nathan.roberts@example.com'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 13, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Please use your professional email address',
                          style: TextStyle(
                              fontSize: 11, color: Colors.orange[700]),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _label('Password'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: '280mLzLH7CU',
                    obscure: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(
                            () => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  _label('Confirm Password'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: '••••••••••••',
                    obscure: _obscureConfirm,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _agreedToTerms,
                          activeColor: const Color(0xFF3D5AFE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() => _agreedToTerms = value ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                            children: [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: Color(0xFF3D5AFE),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Color(0xFF3D5AFE),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _agreedToTerms
                          ? () {
                              Navigator.pushReplacementNamed(
                                  context, AppRouter.login);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D5AFE),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF6F7FB),
        suffixIcon: suffix,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}