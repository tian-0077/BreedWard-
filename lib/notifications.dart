import 'package:breedward/botnavbar.dart';
import 'package:breedward/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends State<NotificationsScreen> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://breedward1-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("waterlevel");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WEDNESDAY 13, APRIL',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(fontSize: 15),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Notifications',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(fontSize: 30),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.circle, size: 10, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
        actions: [
          
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 16),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: GestureDetector(child: const Icon(Icons.close_outlined, color: Colors.white),onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomBottomNavBar()));
              },),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: GoogleFonts.outfit(color: Colors.grey)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: _database.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong.'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text('No notifications yet.'));
                  }

                  final rawData = snapshot.data!.snapshot.value;
                  print("Raw data from Firebase: $rawData");

                  if (rawData is! Map) {
                    return Center(
                      child: Text('Unexpected data format: $rawData'),
                    );
                  }

                  final data = Map<String, dynamic>.from(rawData);

                  final waterlevel =
                      data.entries.map((entry) {
                        final value = entry.value;
                        if (value is String) {
                          return value;
                        } else if (value is Map &&
                            value.containsKey('message')) {
                          return value['message']
                              .toString(); 
                        } else {
                          return 'Invalid data format';
                        }
                      }).toList();

                  return ListView.builder(
                    itemCount: waterlevel.length,
                    itemBuilder: (context, index) {
                      return SizedBox(height: 80,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 226, 226),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.notifications),
                              SizedBox(width: 10,),
                              Text(
                                waterlevel[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
