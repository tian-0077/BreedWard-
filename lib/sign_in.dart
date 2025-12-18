import 'package:breedward/botnavbar.dart';
import 'package:breedward/forgotpassword_page.dart';
import 'package:breedward/home_page.dart';
import 'package:breedward/username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';

class sign_in extends StatefulWidget {
  const sign_in({super.key});

  @override
  State<sign_in> createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  //////////////////GOOGLE SIGN IN //////////////////////////////////////
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  //////////////////GOOGLE SIGN IN //////////////////////////////////////

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          showSnackbar("Please verify your email before signing in.");
        } else {
          await Future.delayed(Duration(seconds: 3));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
          );
        }
      }
    } catch (e) {
      showSnackbar("Sign-in failed: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 5,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Effortlessly monitor water quality, feeding schedules, \nand fish health in real time.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 50),

                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Color.fromRGBO(243, 243, 243, 1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Color.fromRGBO(243, 243, 243, 1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    SizedBox(
                      width: double.maxFinite,
                      height: 59,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : signIn,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Color.fromRGBO(39, 150, 69, 1),
                        ),
                        child:
                            isLoading
                                ? Lottie.asset(
                                  'assets/loadingg.json',
                                  width: 40,
                                  height: 40,
                                )
                                : Text(
                                  'Sign in',
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 20),
                   
                    Center(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/dash1.png',
                            width: 120,
                            height: 10,
                          ),
                          SizedBox(width: 3),
                          Text('Or Sign in With'),
                          SizedBox(width: 3),
                          Image.asset(
                            'assets/dash2.png',
                            width: 120,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton('assets/google.png', () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => usernameget(),
                            ),
                          );
                        }),

                        SizedBox(width: 10),
                        _socialButton('assets/fb.png', () {}),
                        SizedBox(width: 10),
                        _socialButton('assets/apple2.png', () {}),
                      ],
                    ),

                    Spacer(),
                    Center(child: Image.asset('assets/logobw.png')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(236, 236, 236, 1)),
          color: const Color.fromRGBO(236, 236, 236, 1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            height: 35,
            width: 35,
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
