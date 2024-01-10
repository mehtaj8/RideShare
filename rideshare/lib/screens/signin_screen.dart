import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/screens/phoneregister_screen.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'package:rideshare/screens/reset_password.dart';
import 'package:rideshare/animations/fade_animation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
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

        // Creating a child to hold the logo
        child: SingleChildScrollView(
          // Adding some padding to make the image center and at top of screen
          child: Column(
            // The children in this Scroll View
            children: <Widget>[
              // Logo
              // Container(
              //   padding: EdgeInsets.fromLTRB(50, 100, 0, 0),
              //   alignment: Alignment.topLeft,
              //   child: logoWidget("assets/images/car.png"),
              // ),

              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 100, 0, 0),
                  child: FadeAnimation(
                    1,
                    Container(
                        width: 75,
                        height: 100,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ))),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: FadeAnimation(
                      1.3,
                      const Text(
                        "Welcome To RideShare,",
                        style: TextStyle(
                            color: Colors.white, //hexStringToColor("343c3c"),
                            fontFamily: "Salma",
                            fontSize: 17),
                        textAlign: TextAlign.left,
                      )),
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 0, 30),
                  child: FadeAnimation(
                      1.3,
                      const Text(
                        "Connecting Canadians, One Journey at a Time!",
                        style: TextStyle(
                            color: Colors.white, //hexStringToColor("343c3c"),
                            fontFamily: "Salma",
                            fontSize: 10),
                        textAlign: TextAlign.left,
                      )),
                ),
              ),

              // Username Input
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: FadeAnimation(
                  1.6,
                  reusableTextField(
                      "E-Mail", Icons.email_outlined, _emailTextController),
                ),
              ),

              // Password Input
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: FadeAnimation(
                  1.9,
                  TextField(
                    // Type of controller
                    controller: _passwordTextController,

                    // Configurations
                    obscureText: isPasswordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),

                    // Add decoration to text box
                    decoration: InputDecoration(
                      // Prefixed icon
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),

                      // Test Styling
                      labelText: "Password",
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.9)),
                      filled: false,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white.withOpacity(0.3),

                      // Border Styling
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                              style: BorderStyle.solid)),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              // Sign In button
              const SizedBox(
                height: 5,
              ),
              FadeAnimation(1.8, forgetPassword(context)),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: FadeAnimation(
                  2.1,
                  firebaseUIButton(context, "Sign In", () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("User Logged In ${_emailTextController.text}");
                      authProvider.setSignIn();
                      authProvider.getUserDataFromFirebase().whenComplete(() =>
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const HomeScreen(),
                                  type: PageTransitionType.fade,
                                  duration:
                                      const Duration(milliseconds: 300))));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  }),
                ),
              ),
              FadeAnimation(2.1, signUpOption()),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                child: FadeAnimation(
                  2.4,
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Sign in With',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PhoneRegistration()));
          },
          child: Text(
            " Sign Up",
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}
