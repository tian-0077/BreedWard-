import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changeEmail() async {
    final newEmail = emailController.text.trim();
    final password = passwordController.text.trim();

    if (newEmail.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;

      await user?.reload();
      user = _auth.currentUser;

      if (user == null || !user.emailVerified) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Email Not Verified"),
                content: const Text(
                  "Please verify your current email address first.\n\nWe've sent you a verification email.",
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      try {
                        await user?.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Verification email sent"),
                          ),
                        );
                      } catch (e) {
                        debugPrint("ERROR: $e");
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Resend Email"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      final confirm = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Email Not Verified"),
              content: const Text(
                "Please verify your current email address first.\n\nWe've sent you a verification email.",
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      await user?.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Verification email sent"),
                        ),
                      );
                    } catch (e) {
                      debugPrint("ERROR: $e");
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Resend Email"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );

      if (confirm != true) return;

      await user.updateEmail(newEmail);
      await user.sendEmailVerification();

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/emailforgot.json',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Email updated to:\n\n$newEmail\n\nPlease check your inbox and verify.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("DEBUG: FirebaseAuthException: ${e.message}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/emailsent.json', height: 230),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Change Email Address",
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: emailController,
                  hintText: "Enter new email address",
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: passwordController,
                  hintText: "Enter current password",
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: changeEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(39, 150, 69, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Change Email",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color.fromRGBO(243, 243, 243, 1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
