import 'package:breedward/main.dart';
import 'package:breedward/water_temograph.dart';
import 'package:breedward/waterquality_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<String?> getUsername() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (userDoc.exists) {
      return userDoc['username'];
    }
  }
  return null;
}

class _HomePageState extends State<HomePage> {
  String sensor1 = "Loading..";
  String sensor2 = "Loading..";
  String sensor3 = "Loading..";
  String sensor4 = "Loading..";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref('sensors');
  PageController _pageController = PageController();
  int _currentpage = 0;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    fetchdata();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void fetchdata() {
    final databaseRef = FirebaseDatabase.instance.ref('sensors');

    databaseRef.onValue.listen((event) {
      final snapshotValue = event.snapshot.value;

      if (snapshotValue != null && snapshotValue is Map<Object?, Object?>) {
        final data = Map<String, dynamic>.from(snapshotValue);

        debugPrint('Sensor data: $data');

        setState(() {
          sensor1 = data['sensor1']?.toString() ?? "N/A";
          sensor2 = data['sensor2']?.toString() ?? "N/A";
          sensor3 = data['sensor3']?.toString() ?? "N/A";
          sensor4 = data['sensor4']?.toString() ?? "N/A";

          
          final s3value = double.tryParse(sensor3);
          if (s3value != null && s3value >= 400) {
            _showNotification(
              "TDS exceeded",
              "Please clean up debris!",
            );
          }
          final s2value = double.tryParse(sensor2);
          if (s2value != null && s2value <= 7.5) {
            _showNotification(
              "Alkalinity dropped",
              "Pumping solution...",
            );
          }else if (s2value != null && s2value >= 8.3){
            _showNotification(
              "Alkalinity is at danger level!",
              "Pumping solution...",
            );

          }

          final s1value = double.tryParse(sensor1);
          if (s1value != null && s1value <= 26 ) {
            _showNotification(
              "Temperature dropped",
              "Pumping solution...",
            );
          }else if (s1value != null && s1value >= 32){
            _showNotification(
              "Temperature is at danger level!",
              "Pumping solution...",
            );

          }

          final s4value = double.tryParse(sensor4);
          if (s1value != null && s1value <= 20 ) {
            _showNotification(
              "Salinity dropped",
              "Pumping solution...",
            );
          }else if (s4value != null && s4value >= 32){
            _showNotification(
              "Salinity is at danger level!",
              "Pumping solution...",
            );

          }
        });
      } else {
        debugPrint("Sensor data is null or not a map");
      }
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'sensor_channel_id',
          'Sensor Alerts',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, 
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 49, 49, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 250,
                          width: 200,
                          child: Image.asset('assets/logowhite.png'),
                        ),
                      ),
                      FutureBuilder<String?>(
                        future: getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: 5,
                              width: 5,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error fetching username");
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            return Text(
                              " ${snapshot.data}",
                              style: GoogleFonts.outfit(
                                textStyle: TextStyle(
                                  fontSize: 5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            return Text("User not found");
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Lottie.asset('assets/google1.json'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Card(
                  color: Color.fromRGBO(30, 30, 30, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 5),
                          child: Text(
                            _currentpage == 0
                                ? 'Water Quality'
                                : 'Water Temperature',
                            style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentpage = index;
                              });
                            },
                            children: [WaterQualityChart(), WaterTempChart()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 170,
                    height: 165,
                    child: _buildCard(
                      Icons.water_drop,
                      "$sensor1°C",
                      "Water Temperature",
                      Color.fromRGBO(39, 150, 69, 1),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 165,
                    child: _buildCard(
                      Icons.water,
                      "$sensor2 pH",
                      "Alkalinity",
                      Color.fromRGBO(30, 30, 30, 1),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 165,
                    child: _buildCard(
                      Icons.thermostat,
                      "$sensor3 ppm",
                      "TDS",
                      Color.fromRGBO(30, 30, 30, 1),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 165,
                    child: _buildCard(
                      Icons.thermostat,
                      "$sensor4 ppt",
                      "Salinity",
                      Color.fromRGBO(39, 150, 69, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String value, String label, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
