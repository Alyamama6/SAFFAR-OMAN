import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  double strength = 0.0;
  String strengthLabel = "Weak";

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _checkStrength(String v) {
    double s = 0;

    if (v.length >= 8) s += 0.4;
    if (RegExp(r'[A-Z]').hasMatch(v)) s += 0.2;
    if (RegExp(r'[a-z]').hasMatch(v)) s += 0.2;
    if (RegExp(r'[0-9]').hasMatch(v)) s += 0.2;

    setState(() {
      strength = s;
      if (s < 0.4) strengthLabel = "Weak";
      else if (s < 0.7) strengthLabel = "Medium";
      else strengthLabel = "Strong";
    });
  }

  void _savePassword() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushNamed(context, '/passwordSaved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("images/background.jpeg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.brown.withOpacity(.5)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create a new, secure password for your account.",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),

                    /// NEW PASSWORD
                    TextFormField(
                      controller: _pass,
                      obscureText: true,
                      onChanged: _checkStrength,
                      decoration: InputDecoration(
                        hintText: "Enter new password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.visibility_off),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Password required";
                        }
                        if (v.length < 8) {
                          return "Must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),

                    /// Strength indicator
                    SizedBox(
                      height: 5,
                      child: LinearProgressIndicator(
                        value: strength,
                        color: Colors.orange,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Password Strength: $strengthLabel",
                      style:
                      const TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    const SizedBox(height: 20),

                    /// CONFIRM PASSWORD
                    TextFormField(
                      controller: _confirm,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm new password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.visibility_off),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) {
                        if (v != _pass.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _savePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBF6B2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
