import 'package:flutter/material.dart';
import 'package:breedward/welcome.dart'; // Replace with your actual screen

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeOutAnimation;
  bool showFishOnly = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

   
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showFishOnly = true;
        });


        // Wait 1 second, then navigate
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Welcome()),
          );
        });
      }
    });

    // Start fade animation after delay
    Future.delayed(const Duration(seconds: 2), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 170,
          width: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showFishOnly)
                Image.asset(
                  'assets/fish1.png',
                  width: 320,
                  fit: BoxFit.contain,
                ),
              FadeTransition(
                opacity: _fadeOutAnimation,
                child: Image.asset(
                  'assets/logobw.png',
                  width: 320,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
