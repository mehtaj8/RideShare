import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rideshare/animations/fade_animation1.dart';
import 'package:rideshare/animations/fade_animation2.dart';
import 'package:rideshare/modules/profilemanagement_module/screens/driver_screen.dart';
import 'package:rideshare/modules/profilemanagement_module/screens/settings_screen.dart';
import 'package:rideshare/modules/profilemanagement_module/screens/userProfile_screen.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:rideshare/utils/utils.dart';
import 'package:sliding_switch/sliding_switch.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool screenState = true;
  bool allInfoFilledIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: hexStringToColor("6c7373"),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Stack(
                children: [
                  Align(
                    child: Center(
                      // Top Sliding Switch
                      child: SlidingSwitch(
                        height: 40,
                        width: 200,
                        value: true,
                        onChanged: (value) {
                          setState(() {
                            screenState = value;
                          });
                        },
                        onTap: () {
                          if (screenState) {
                            if (!allInfoFilledIn) {
                              setState(() {
                                screenState = false;
                              });
                              showSnackBar(
                                  context,
                                  "Oops!",
                                  "Please fill in all fields",
                                  ContentType.failure);
                            } else {
                              setState(() {
                                screenState = true;
                              });
                            }
                          }
                        },
                        onDoubleTap: () {
                          if (screenState) {
                            if (!allInfoFilledIn) {
                              setState(() {
                                screenState = false;
                              });
                              showSnackBar(
                                  context,
                                  "Oops!",
                                  "Please fill in all fields",
                                  ContentType.failure);
                            } else {
                              setState(() {
                                screenState = true;
                              });
                            }
                          }
                        },
                        onSwipe: () {
                          if (screenState) {
                            if (!allInfoFilledIn) {
                              setState(() {
                                screenState = false;
                              });
                              showSnackBar(
                                  context,
                                  "Oops!",
                                  "Please fill in all fields",
                                  ContentType.failure);
                            } else {
                              setState(() {
                                screenState = true;
                              });
                            }
                          }
                        },
                        textOff: "Driver",
                        textOn: "Rider",
                        contentSize: 15,
                        buttonColor: Colors.white70,
                        colorOn: Colors.black87,
                        colorOff: Colors.black87,
                      ),
                    ),
                  ),

                  // Settings Button
                  Positioned(
                    top: 8,
                    right: 30,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: SettingsScreen(),
                                childCurrent: ProfileScreen(),
                                type: PageTransitionType.rightToLeftJoined));
                      },
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            screenState == true
                ? FadeAnimation1(1, UserProfileScreen())
                : FadeAnimation2(
                    1,
                    DriverScreen(
                      allInfoFilledIn: allInfoFilledIn,
                    ),
                  )
          ]),
        ));
  }
}
