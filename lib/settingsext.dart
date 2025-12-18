import 'package:breedward/emailrecovery.dart';
import 'package:breedward/forgotpassword_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settingsext extends StatefulWidget {
  const Settingsext({super.key});

  @override
  State<Settingsext> createState() => _SettingsextState();
}

class _SettingsextState extends State<Settingsext> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 49, 49, 1),
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),backgroundColor: Colors.green,),
      
      body: 
      
      Padding(
        padding: const EdgeInsets.only(
          top: 1,
          left: 15,
          right: 15,
          bottom: 10,
        ),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Divider(thickness: 1,indent: 1,color: Colors.green,),
            
            Text(
              "Settings",
              style: GoogleFonts.outfit(
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),

            

            SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.green
                  ),
                  SizedBox(width: 10),
              
                  Text(
                    "Account",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: 2,),
            Divider(thickness: 1,color: Colors.green,),

            SizedBox(height: 30),
            

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: FilledButton(
                    
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.green,splashFactory: NoSplash.splashFactory
                    ),
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeEmailPage()));},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Email Address",style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),

                          Icon(Icons.arrow_forward,color:  Color.fromRGBO(39, 150, 69, 1),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),

                 SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: FilledButton(
                    
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.green,splashFactory: NoSplash.splashFactory
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Password",style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),

                          Icon(Icons.arrow_forward,color:  Color.fromRGBO(39, 150, 69, 1),)
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15,),

                 SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: FilledButton(
                    
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.green,splashFactory: NoSplash.splashFactory
                    ),
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Email Address",style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                            
                          ),

                          Icon(Icons.arrow_forward,color:  Color.fromRGBO(39, 150, 69, 1),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
