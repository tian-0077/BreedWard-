
import 'package:breedward/Settings.dart';
import 'package:breedward/controller1.dart';

import 'package:breedward/notifications.dart';
import 'package:breedward/profile.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:breedward/home_page.dart';
import 'package:breedward/sign_in.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [HomePage(), Settings(),ProfileScreen()];

  final List<String> _labels = ["Home", "Graphs", "Account"];

  final List<String> _lottieSelectedFiles = [
    'assets/home.json',
    'assets/graph.json',
    'assets/profilesel.json',
  ];

  final List<dynamic> _pngUnselectedFiles = [
    'assets/homeicon.png',
    Icons.bar_chart,
    Icons.account_circle_outlined,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 49, 49, 1),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(30, 30, 30, 1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_lottieSelectedFiles.length, (index) {
            bool isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.white : Color.fromRGBO(30, 30, 30, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected)
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Lottie.asset(
                          _lottieSelectedFiles[index],
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      _buildUnselectedIconOrImage(_pngUnselectedFiles[index]),

                    if (isSelected) const SizedBox(width: 5),
                    if (isSelected)
                      Text(
                        _labels[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildUnselectedIconOrImage(dynamic item) {
    if (item is String) {
      return Image.asset(item, width: 25, height: 25, fit: BoxFit.contain);
    } else if (item is IconData) {
      return Icon(item, size: 25, color: Colors.white);
    }
    return SizedBox();
  }
}
