import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final DatabaseReference _controlsRef = FirebaseDatabase.instance.ref('PUMPS');

  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;
  bool switch4 = false;

  @override
  void initState() {
    super.initState();
    _listenToSwitches();
  }

  void _listenToSwitches() {
    _controlsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          switch1 = data['pump1'] == true;
          switch2 = data['pump2'] == true;
          switch3 = data['pump3'] == true;
          switch4 = data['pump4'] == true;
        });
      }
    });
  }

  void _updateSwitch(String key, bool value) {
    _controlsRef.update({key: value});
  }

  Widget _buildCard(
    String label,
    bool value,
    Function(bool) onChanged,
    String imagePath,
    Color color,
  ) {
    return Container(
      width: 170,
      height: 190,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.greenAccent,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(39, 150, 69, 1),
        actions: [],
        title: Text('Pump Controller',style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Color.fromRGBO(49, 49, 49, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Water Pumps',
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),

            SizedBox(height: 60),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildCard(
                  "Pump 1",
                  switch1,
                  (val) => _updateSwitch("pump1", val),
                  'assets/pump3.png',
                  Color.fromRGBO(39, 150, 69, 1),
                ),
                _buildCard(
                  "Pump 2",
                  switch2,
                  (val) => _updateSwitch("pump2", val),
                  'assets/pump3.png',
                  Color.fromRGBO(30, 30, 30, 1),
                ),
                _buildCard(
                  "Pump 3",
                  switch3,
                  (val) => _updateSwitch("pump3", val),
                  'assets/pump3.png',
                  Color.fromRGBO(30, 30, 30, 1),
                ),
                _buildCard(
                  "Pump 4",
                  switch4,
                  (val) => _updateSwitch("pump4", val),
                  'assets/pump3.png',
                  Color.fromRGBO(39, 150, 69, 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
