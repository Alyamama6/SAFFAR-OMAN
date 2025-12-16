import 'package:flutter/material.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _codeControllers =
  List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var c in _codeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    String code = _codeControllers.map((e) => e.text).join();

    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter the 4-digit code")),
      );
      return;
    }

    Navigator.pushNamed(context, '/resetPassword');
  }

  Widget _otpBox(TextEditingController c) {
    return SizedBox(
      width: 55,
      height: 55,
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (_) {
          if (c.text.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
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
            child: Container(color: Colors.brown.withOpacity(0.5)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter Verification code",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We've sent a 4-digit code to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  /// OTP BOXES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _codeControllers
                        .map((c) => _otpBox(c))
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  const Text("Resend code in 00:59",
                      style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                  const Text("Didn’t receive a code? Resend",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4A2A15),
                          decoration: TextDecoration.underline)),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("verify",
                          style: TextStyle(color: Colors.black)),
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
}

