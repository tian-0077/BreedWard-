import 'package:breedward/home_page.dart';
import 'package:breedward/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;
  bool isSigningUp = false;

  Future<void> signUp() async {
    setState(() {
      isSigningUp = true;
    });

    await Future.delayed(Duration(milliseconds: 100)); 

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
     
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': nameController.text.trim(),
          'email': emailController.text.trim(),
          'created_at': Timestamp.now(),
        });

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          showPopupCard(context);

          _auth.authStateChanges().listen((User? user) async {
            if (user != null) {
              await user.reload();
              user = _auth.currentUser;

              if (user != null && user.emailVerified) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => sign_in()),
                );
              }
            }
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => sign_in()),
          );
        }
      }
    } catch (e) {
      print("Signup failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }

  void showPopupCard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animverif.json',
                height: 105,
                width: 105,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15),

              Text(
                "Verification Required",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Text(
                "A verification email has been sent to your email. Please check your inbox and verify before signing in.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => sign_in()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Color.fromRGBO(39, 150, 69, 1),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                        controller: nameController,

                        decoration: InputDecoration(
                          hintText: 'Username',
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
                        controller: emailController,

                        decoration: InputDecoration(
                          hintText: 'Username, Email & Phone Number',
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

                    SizedBox(height: 40),

                    SizedBox(
                      width: double.maxFinite,
                      height: 59,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isSigningUp) {
                            setState(() {
                              isSigningUp =
                                  true; 
                            });

                            Future.delayed(Duration(milliseconds: 100), () {
                              print("Signing up..."); 
                              signUp(); 
                            });
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          backgroundColor: Color.fromRGBO(39, 150, 69, 1),
                        ),
                        child:
                            isSigningUp
                                ? SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Lottie.asset(
                                    'assets/loading.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                    animate: true,
                                  ),
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

                          Text('Or Sign up With'),

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
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              shape: BoxShape.circle,
                            ),

                            child: Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Lottie.asset(
                                  'assets/google1.json',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: Lottie.asset(
                                  'assets/facebook1.json',

                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(236, 236, 236, 1),
                              ),
                              color: const Color.fromRGBO(236, 236, 236, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: Image.asset(
                                  'assets/apple2.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
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
}
