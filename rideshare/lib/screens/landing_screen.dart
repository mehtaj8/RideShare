import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rideshare/animations/fade_animation.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'package:rideshare/screens/signin_screen.dart';
import 'package:rideshare/utils/color_utils.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late final AnimationController _scale2Controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));

  late final AnimationController _widthController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  late final AnimationController _positionController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _widthController.forward();
          }
        });

  late final Animation<double> _scale2Animation =
      Tween<double>(begin: 1.0, end: 40.0).animate(_scale2Controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Navigator.push(
                context,
                PageTransition(
                    child: const SignInScreen(),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 500)));
          }
        });

  late final Animation<double> _widthAnimation =
      Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _positionController.forward();
          }
        });

  late final Animation<double> _positionAnimation =
      Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              hideIcon = true;
            });
            _scale2Controller.forward();
          }
        });

  bool hideIcon = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("ffcc66"),
          hexStringToColor("9e9476"),
          hexStringToColor("343b3e"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        width: double.infinity,

        // Top Animation
        child: Stack(
          children: <Widget>[
            // Top of Screen 1
            Positioned(
              top: -50,
              left: 0,
              child: FadeAnimation(
                1,
                Container(
                    width: width,
                    height: 900,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/one.png'),
                      fit: BoxFit.cover,
                    ))),
              ),
            ),

            // Top of Screen 2
            Positioned(
              top: -100,
              left: 0,
              child: FadeAnimation(
                1.3,
                Container(
                    width: width,
                    height: 900,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/one.png'),
                      fit: BoxFit.cover,
                    ))),
              ),
            ),

            // Top of Screen3
            Positioned(
              top: -150,
              left: 0,
              child: FadeAnimation(
                1.6,
                Container(
                    width: width,
                    height: 900,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/one.png'),
                      fit: BoxFit.cover,
                    ))),
              ),
            ),

            // Logo + Slogan + Bottom Button
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Logo
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: FadeAnimation(
                        2.4,
                        Column(
                          children: [
                            Transform.scale(
                                scale: 0.8, child: logoWidget(context)),
                          ],
                        )),
                  ),

                  // Slogan
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 150),
                    child: FadeAnimation(
                        2.4,
                        Text(
                          "YOUR TRUSTED JOURNEY ACROSS CANADA",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontFamily: "Timeburner",
                              fontSize: 40),
                          textAlign: TextAlign.center,
                        )),
                  ),

                  // Bottom Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                    child: FadeAnimation(
                        2.4,
                        AnimatedBuilder(
                          animation: _scaleController,
                          builder: (context, child) => Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _widthController,
                                  builder: (context, child) => Container(
                                    width: _widthAnimation.value,
                                    height: 80,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: hexStringToColor("ffcc66")
                                            .withOpacity(0.4)),
                                    child: InkWell(
                                      onTap: () {
                                        _scaleController.forward();
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          AnimatedBuilder(
                                            animation: _positionAnimation,
                                            builder: (context, child) =>
                                                Positioned(
                                              left: _positionAnimation.value,
                                              child: AnimatedBuilder(
                                                animation: _scale2Controller,
                                                builder: (context, child) =>
                                                    Transform.scale(
                                                        scale: _scale2Animation
                                                            .value,
                                                        child: Container(
                                                          width: 60,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  hexStringToColor(
                                                                      "ffcc66")),
                                                          child:
                                                              hideIcon == false
                                                                  ? Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7),
                                                                    )
                                                                  : Container(),
                                                        )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        )),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
