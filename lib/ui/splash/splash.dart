import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/dashboard.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double wilksScore = 0.0;
  bool startAnimation = false;
  final textColor = Color(0xFFFFFDD0);
  final bgColor = Color(0xFF0f0E47);
  //image animation
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Trigger animation after build
   _startAnimationAndProceed();
  }

  _startAnimationAndProceed() {
    //text animation
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        startAnimation = true;
      });
    });
    //image animation
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Future.delayed(Duration(seconds: 2), () {
      if(mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WilksCalculatorScreen()), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              children: [
                _animatedTextAlign(title: "Wilks",alignment: Alignment.centerLeft),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(seconds: 1),
                  child: SizedBox(
                    height: 250,
                    child: Image.asset("assets/images/splash.png",fit: BoxFit.cover)
                  ),
                ),
                _animatedTextAlign(title: "Calculator",alignment: Alignment.centerRight),
              ],
            ),
          )
        ],
      ),
    );
  }

  AnimatedAlign _animatedTextAlign({required String title,required Alignment  alignment}) {
    return AnimatedAlign(
      duration: Duration(seconds: 1),
      curve: Curves.easeOut,
      alignment: startAnimation
          ? Alignment.center
          : alignment, // from left to center
      child: Text(
        title,
        style: GoogleFonts.sourceSerif4(
          fontSize: 44,
          fontWeight: FontWeight.w700,
          color: bgColor,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
