import 'package:breedward/botnavbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Feedbackconfirm extends StatefulWidget {
  const Feedbackconfirm({super.key});

  @override
  State<Feedbackconfirm> createState() => _FeedbackconfirmState();
}

class _FeedbackconfirmState extends State<Feedbackconfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 400,width: 400,
            child: Lottie.asset('assets/newn.json')),
          Text(
            "Thank You",
            style: GoogleFonts.outfit(
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
           Text(
            "Your feedback has been recorded.",
            style: GoogleFonts.outfit(
              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
            ),
          ),

          SizedBox(height: 25,),

           GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomBottomNavBar()));
            },
             child: Text(
              "Go back to home.",
              style: GoogleFonts.outfit(
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200 ),
                decoration: TextDecoration.underline
              ),
                       ),
           ),
        ],
      ),
    );
  }
}
