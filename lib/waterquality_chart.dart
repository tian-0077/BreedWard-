import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WaterQualityChart extends StatefulWidget {
  const WaterQualityChart({super.key});

  @override
  _WaterQualityChartState createState() => _WaterQualityChartState();
}

class _WaterQualityChartState extends State<WaterQualityChart> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://breedward1-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("waterQuality");

  List<double> barValues = List.generate(7, (index) => 0);
  StreamSubscription<DatabaseEvent>? _dataSubscription;
  int currentDay = 1;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _checkForNewDay(); 
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    _fetchData();
  }

  void _fetchData() {
    _dataSubscription = _database.onValue.listen(
      (event) {
        if (event.snapshot.value != null &&
            event.snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

          List<double> newValues = List.generate(7, (index) {
            String key = "day${index + 1}";

            if (data[key] != null && data[key] is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> dayData = data[key];

              List<double> readings = [];
              dayData.forEach((key, value) {
                try {
                  readings.add(double.parse(value.toString()));
                } catch (e) {
                  debugPrint("Error parsing value for $key: $value");
                }
              });

              if (readings.isNotEmpty) {
                return readings.reduce((a, b) => a + b) / readings.length;
              }
            }
            return 0;
          });

          setState(() {
            barValues = newValues;
          });

          debugPrint("Computed Averages: $barValues");
        } else {
          debugPrint(" No data received from Firebase.");
        }
      },
      onError: (error) {
        debugPrint("Firebase Error: $error");
      },
    );
  }

  void _checkForNewDay() {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat.Hm().format(now); 

      if (formattedTime == "00:00") {
        debugPrint("🎯 12 AM Reached! Storing average and resetting readings...");
        await _finalizeDay();
      }
    });
  }

  Future<void> _finalizeDay() async {
   
    int newDay = DateTime.now().weekday; 

    if (newDay != currentDay) {
      debugPrint("🌙 Transitioning to new day: Day $newDay");

      // Store the final daily average
      double finalAverage = barValues[currentDay - 1];

      await _database.child("dailyAverages").child("day$currentDay").set(finalAverage);
      debugPrint("Stored final average for Day $currentDay: $finalAverage");

      // Reset readings for new day
      await _database.child("waterQuality").child("day$newDay").remove();
      debugPrint("Started new collection for Day $newDay");

      setState(() {
        currentDay = newDay;
      });
    }
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        minY: 0,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  "Day ${value.toInt()}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: List.generate(barValues.length, (index) {
          return BarChartGroupData(
            x: index + 1,
            barRods: [
              BarChartRodData(
                fromY: 0,
                toY: barValues[index],
                width: 30,
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(61, 156, 87, 1),
                    Color.fromRGBO(61, 156, 87, 1),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
