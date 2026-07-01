import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wealthwise/login/login_screen.dart';
import 'package:wealthwise/login/signup_screen.dart';
import 'package:wealthwise/login/welcome_screen.dart';
import 'package:wealthwise/screens/dashboard_screen.dart';
import 'homePage.dart';
class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
  super.initState();

  Future.delayed(
    const Duration(seconds: 4),
    () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 246, 236),
      
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80,),
            RepaintBoundary(
            child:Lottie.asset(
              "assets/animations/moneyy.json",
               fit: BoxFit.contain,
              frameRate: FrameRate.max,
              width:400,
              height: 400,
              repeat: false,
              // renderCache: RenderCache.raster,
            ),),
            
            Text("Wealth Wise",style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w400
            ),),
            SizedBox(height: 10,),
            Text("India's Own Wealth Management App!",style: TextStyle(
              fontSize: 15
            ),)

          ],
        ),
      ),
    );
  }
}