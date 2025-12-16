import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TouristRegisterScreen extends StatefulWidget {
  const TouristRegisterScreen({super.key});

  @override
  State<TouristRegisterScreen> createState() => _TouristRegisterScreenState();
}

class _TouristRegisterScreenState extends State<TouristRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final emailRegex =
    RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$'); // true email format
    return emailRegex.hasMatch(value);
  }

  bool _isStrongPassword(String value) {
    final hasMinLength = value.length >= 8;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    return hasMinLength && hasLetter && hasDigit;
  }

  Future<void> _registerTourist() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = cred.user!.uid;

      final ref = FirebaseDatabase.instance.ref('users/$uid');
      await ref.set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': 'tourist',
        'createdAt': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      // تسجيل ناجح → يروح للاكسبلور
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/explore',
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      if (e.code == 'email-already-in-use') {
        // Row 8: User already exists
        msg = 'User already exists';
      } else {
        msg = e.message ?? 'Registration failed';
      }
      setState(() => _error = msg);
    } catch (e) {
      setState(() => _error = 'Registration failed');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.brown.withOpacity(0.6),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Create your Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Register as a tourist',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // 1) Empty username → Username required
                            _buildTextField(
                              controller: _nameController,
                              hint: 'Full Name',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Username required';
                                }
                                if (value.trim().length < 3) {
                                  return 'Please enter the username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // 2) Email
                            _buildTextField(
                              controller: _emailController,
                              hint: 'Email Address',
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  // Row 2
                                  return 'Email required';
                                }
                                if (!_isValidEmail(value.trim())) {
                                  // Row 4
                                  return 'Invalid email format';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Phone
                            _buildTextField(
                              controller: _phoneController,
                              hint: 'Phone Number (8 digits)',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.length != 8) {
                                  return 'Phone number must be 8 digits';
                                }
                                if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                                  return 'Digits only are allowed';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // 3 + 5) Password
                            _buildTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              obscure: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // Row 3
                                  return 'Password required';
                                }
                                if (!_isStrongPassword(value)) {
                                  // Row 5
                                  return 'Password must contain at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // 6 + 7) Confirm Password
                            _buildTextField(
                              controller: _confirmPasswordController,
                              hint: 'Confirm Password',
                              icon: Icons.lock_outline,
                              obscure: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // Row 6
                                  return 'Confirm password required';
                                }
                                if (value != _passwordController.text) {
                                  // Row 7
                                  return 'Password does not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _registerTourist,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFBF6B2F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _loading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            if (_error != null)
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),

                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/touristLogin');
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      validator: validator,
    );
  }
}
