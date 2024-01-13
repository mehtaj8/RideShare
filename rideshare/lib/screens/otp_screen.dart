import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/screens/signup_screen.dart';
import 'package:rideshare/utils/color_utils.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthenticationProvider>(context, listen: true).isLoading;

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
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: hexStringToColor("ffcc66").withOpacity(0.7),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Top Icon
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Icon(
                            Icons.verified_outlined,
                            size: 100,
                            color: hexStringToColor("ffcc66").withOpacity(0.7),
                          ),
                        ),
                      ),

                      // Top text
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Verification",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Enter OTP
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "Enter the OTP sent to your Phone Number",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Pin Input
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                        child: Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                              width: 60,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: hexStringToColor("ffcc66")
                                          .withOpacity(0.7))),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                              verifyOtp(context, otpCode!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  // Verify Otp
  void verifyOtp(BuildContext context, String userOtp) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    if (authProvider.isSignedIn == true) {
      // If user is signing up with other provider
      authProvider.verifyOtpLink(
          context: context,
          verificationId: widget.verificationId,
          userOtp: userOtp,
          onSuccess: () {
            // Check if user exists
            authProvider.checkExistingUser().then(
              (value) async {
                if (value == true) {
                  final authProvider = Provider.of<AuthenticationProvider>(
                      context,
                      listen: false);

                  authProvider.setSignIn();
                  authProvider.setAllInfoCollected();
                  authProvider.getUserDataFromFirebase().whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const HomeScreen(),
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 300)));
                  });
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                      (route) => false);
                }
              },
            );
          });
    } else {
      // If user is siging up with phone number
      authProvider.verifyOtpSignIn(
          context: context,
          verificationId: widget.verificationId,
          userOtp: userOtp,
          onSuccess: () {
            // Check if current user exists
            authProvider.checkExistingUser().then(
              (value) async {
                if (value == true) {
                  final authProvider = Provider.of<AuthenticationProvider>(
                      context,
                      listen: false);

                  authProvider.setSignIn();
                  authProvider.setAllInfoCollected();
                  authProvider.getUserDataFromFirebase().whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const HomeScreen(),
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 300)));
                  });
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                      (route) => false);
                }
              },
            );
          });
    }
  }
}
