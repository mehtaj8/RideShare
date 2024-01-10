import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/screens/landing_screen.dart';
import 'package:rideshare/utils/color_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), _navigate);
  }

  _navigate() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    authProvider.getUserDataFromFirebase().whenComplete(() {
      if (authProvider.isSignedIn == true) {
        Navigator.push(
            context,
            PageTransition(
                child: const HomeScreen(),
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300)));
      } else {
        Navigator.push(
            context,
            PageTransition(
                child: const LandingScreen(),
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            // Finding screen width and height
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            // Creating a gradient on the screen
            decoration: BoxDecoration(
              color: hexStringToColor("6c7373"),
              // gradient: LinearGradient(
              //     colors: [
              //   hexStringToColor("ffcc66"),
              //   hexStringToColor("9e9476"),
              //   hexStringToColor("343b3e"),
              // ],

              // Making the gradient go from top to bottom
              // begin: Alignment.topCenter,
              // end: Alignment.bottomCenter)),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(0, 350, 0, 0),
              child: logoWidget(context),
            )));
  }
}
