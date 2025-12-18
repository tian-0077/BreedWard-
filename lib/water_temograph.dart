import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WaterTempChart extends StatefulWidget {
  const WaterTempChart({super.key});

  @override
  _WaterTempChartState createState() => _WaterTempChartState();
}

class _WaterTempChartState extends State<WaterTempChart> {
  List<double> barValues = List.filled(7, 0); // last 7 seconds
  Timer? _timer;
  final _sensorRef = FirebaseDatabase.instance.ref('PUMPS/sensors/sensor1');

  @override
  void initState() {
    super.initState();
    _startRealtimeUpdates();
  }

  void _startRealtimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final snapshot = await _sensorRef.get();
      if (snapshot.exists) {
        final rawValue = snapshot.value;
        final newValue = double.tryParse(rawValue.toString()) ?? 0;

        setState(() {
          // Shift the list to the left and add the new value at the end
          barValues.removeAt(0);
          barValues.add(newValue);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100, // Adjust based on expected range
        minY: 0,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                'T${value.toInt()}',
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: List.generate(barValues.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: barValues[index],
                width: 25,
                borderRadius: BorderRadius.circular(4),
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
