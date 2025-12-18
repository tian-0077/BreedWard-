import 'package:breedward/register.dart';
import 'package:breedward/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 440,
                  width: double.maxFinite,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(43, 61, 137, 207),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Center(
                      child: Lottie.asset(
                        'assets/monitoring.json',
                        height: 600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),
                Text(
                  'Monitor & Manage\n Your Fishpond with Ease',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Keep track of water quality, feeding schedules, and fish health in real-time with BreedWard.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Spacer(),

                SizedBox(
                  width: double.maxFinite,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_in()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Color.fromRGBO(39, 150, 69, 1),
                      elevation: 0,
                    ),
                    child: Text(
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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => sign_up()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color.fromRGBO(220, 236, 224, 1),
                        elevation: 0,
                      ),
                      child: Text(
                        'Register',
                        style: GoogleFonts.outfit(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
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
}
