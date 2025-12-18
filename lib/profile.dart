import 'dart:io';

import 'package:breedward/Notifications.dart';
import 'package:breedward/about.dart';
import 'package:breedward/feedback.dart';
import 'package:breedward/myaccount.dart';
import 'package:breedward/settingsext.dart';
import 'package:breedward/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  bool isLoading = false;

  void showPopupCard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(30, 30, 30, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/logout.json',
                height: 105,
                width: 105,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15),
              Text(
                "Are you logging out?",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "You can always log back in at any time.",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: BorderSide(
                        color: Color.fromRGBO(39, 150, 69, 1),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });

                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Welcome()),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Color.fromRGBO(39, 150, 69, 1),
                      elevation: 0,
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                              height: 100,
                              width: 100,
                              child: Lottie.asset('assets/loadingg.json'),
                            )
                            : Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String email = user?.email ?? 'wharzwharz@gmail.com';
    final String displayName = user?.displayName ?? 'test1';
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 49, 49, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(49, 49, 49, 1),
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Center(
            child: Text(
              "Profile",
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 10),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: 5),
            Text(
              displayName,
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              email,
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Myaccount()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.green,
                elevation: 0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 37,
                  vertical: 13,
                ),
                child: Text(
                  "Edit Profile",
                  style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settingsext(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color.fromARGB(
                                    45,
                                    76,
                                    175,
                                    79,
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Settings',
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 33,
                              width: 33,
                              child: CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  30,
                                  158,
                                  158,
                                  158,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color.fromARGB(
                                    255,
                                    164,
                                    164,
                                    164,
                                  ),
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color.fromARGB(
                                    45,
                                    76,
                                    175,
                                    79,
                                  ),
                                  child: Icon(
                                    Icons.feedback_outlined,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Submit Feedback',
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 33,
                              width: 33,
                              child: CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  30,
                                  158,
                                  158,
                                  158,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color.fromARGB(
                                    255,
                                    164,
                                    164,
                                    164,
                                  ),
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color.fromARGB(
                                    45,
                                    76,
                                    175,
                                    79,
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'About',
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 33,
                              width: 33,
                              child: CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  30,
                                  158,
                                  158,
                                  158,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color.fromARGB(
                                    255,
                                    164,
                                    164,
                                    164,
                                  ),
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        showPopupCard(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color.fromARGB(
                                    45,
                                    76,
                                    175,
                                    79,
                                  ),
                                  child: Icon(
                                    Icons.logout_outlined,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Logout',
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 33,
                              width: 33,
                              child: CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  30,
                                  158,
                                  158,
                                  158,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color.fromARGB(
                                    255,
                                    164,
                                    164,
                                    164,
                                  ),
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _selectedImage1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i.postimg.cc/0jqKB6mS/Profile-Image.png",
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.green),
                  ),
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  _picImageFromGallery();
                },
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _picImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage1 = File(returnedImage!.path);
    });
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.colors,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Colors colors;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color.fromRGBO(39, 150, 69, 1),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
