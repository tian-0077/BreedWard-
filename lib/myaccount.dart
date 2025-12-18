import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Myaccount extends StatefulWidget {
  const Myaccount({super.key});

  @override
  State<Myaccount> createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {
  final TextEditingController fnamecontroller = TextEditingController();
  final TextEditingController email1controller = TextEditingController();
  final TextEditingController passcpntroller = TextEditingController();
  
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.settings,
                  color: Color.fromRGBO(61, 156, 87, 1),
                  size: 25,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          bottom: 50,
          right: 20,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Edit Profile",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 140,
                width: 140,
                child: GestureDetector(
                  onTap: () {
                    _picImageFromGallery();
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : NetworkImage(
                              "https://i.postimg.cc/0jqKB6mS/Profile-Image.png",
                            ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      controller: fnamecontroller,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    child: TextField(
                      controller: email1controller,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: TextField(
                      controller: passcpntroller,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(),
                      child: Text(
                        "CANCEL",
                        style: GoogleFonts.outfit(
                          textStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(39, 150, 69, 1),
                      ),
                      child: Text(
                        "SAVE",
                        style: GoogleFonts.outfit(
                          textStyle: TextStyle(color: Colors.white),
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

  Future _picImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
