import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GuideRegistrationScreen extends StatefulWidget {
  const GuideRegistrationScreen({super.key});

  @override
  State<GuideRegistrationScreen> createState() =>
      _GuideRegistrationScreenState();
}

class _GuideRegistrationScreenState extends State<GuideRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool loading = false;
  String? error;

  bool validEmail(String v) {
    return RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$').hasMatch(v);
  }

  bool strongPass(String v) {
    return v.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(v) &&
        RegExp(r'\d').hasMatch(v);
  }

  Future<void> registerGuide() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );

      final uid = cred.user!.uid;

      final ref = FirebaseDatabase.instance.ref("users/$uid");
      await ref.set({
        "name": _name.text.trim(),
        "email": _email.text.trim(),
        "phone": _phone.text.trim(),
        "role": "guide",
        "cvUrl": null,
        "idUrl": null,
        "createdAt": DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guideHome',
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      if (e.code == 'email-already-in-use') {
        msg = 'User already exists'; // Row 8
      } else {
        msg = e.message ?? 'Registration failed';
      }
      setState(() => error = msg);
    } catch (e) {
      setState(() => error = 'Registration failed');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset("images/background.jpeg", fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.brown.withOpacity(.55))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    "Become A Guide",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Username
                            field(_name, "Full Name", Icons.person, (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Username required";
                              }
                              if (v.trim().length < 3) {
                                return "Please enter the username";
                              }
                              return null;
                            }),
                            const SizedBox(height: 12),

                            // Email
                            field(_email, "Email Address", Icons.email, (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Email required";
                              }
                              if (!validEmail(v.trim())) {
                                return "Invalid email format";
                              }
                              return null;
                            }),
                            const SizedBox(height: 12),

                            // Phone
                            field(
                              _phone,
                              "Phone Number (8 digits)",
                              Icons.phone,
                                  (v) {
                                if (v == null || v.isEmpty) {
                                  return "Phone number is required";
                                }
                                if (v.length != 8) {
                                  return "Phone number must be 8 digits";
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Password
                            field(
                              _pass,
                              "Password",
                              Icons.lock,
                                  (v) {
                                if (v == null || v.isEmpty) {
                                  return "Password required";
                                }
                                if (!strongPass(v)) {
                                  return "Password must contain at least 8 characters";
                                }
                                return null;
                              },
                              obscure: true,
                            ),
                            const SizedBox(height: 12),

                            // Confirm password
                            field(
                              _confirmPass,
                              "Confirm Password",
                              Icons.lock,
                                  (v) {
                                if (v == null || v.isEmpty) {
                                  return "Confirm password required";
                                }
                                if (v != _pass.text) {
                                  return "Password does not match";
                                }
                                return null;
                              },
                              obscure: true,
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: loading ? null : registerGuide,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: loading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            if (error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  error!,
                                  style: const TextStyle(
                                      color: Colors.redAccent),
                                ),
                              ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget field(
      TextEditingController c,
      String hint,
      IconData icon,
      String? Function(String?) validator, {
        bool obscure = false,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(.9),
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
