import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/screens/register_screen.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'package:rideshare/screens/reset_password.dart';
import 'package:rideshare/animations/fade_animation.dart';
import 'package:rideshare/utils/utils.dart';

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
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _emailTextController.dispose();
  }

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(
              // The children in this Scroll View
              children: <Widget>[
                // Logo
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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

                // Welcome Text
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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

                // Slogan Text
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 30),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: FadeAnimation(
                    1.6,
                    reusableTextField("E-Mail", Icons.email_outlined,
                        _emailTextController, false),
                  ),
                ),

                // Password Input
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                FadeAnimation(1.8, forgetPassword(context)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: FadeAnimation(
                    2.1,
                    firebaseUIButton(context, "Sign In", () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        authProvider.setSignIn();
                        authProvider.setAllInfoCollected();
                        authProvider.getUserDataFromFirebase().whenComplete(
                            () => Navigator.push(
                                context,
                                PageTransition(
                                    child: const HomeScreen(),
                                    type: PageTransitionType.fade,
                                    duration:
                                        const Duration(milliseconds: 300))));
                      }).catchError((onError) async {
                        if (onError.code == 'invalid-email') {
                          showSnackBar(context, "Oops!", "Invalid E-Mail",
                              ContentType.warning);
                        }
                        if (onError.code == 'INVALID_LOGIN_CREDENTIALS') {
                          if (await authProvider.checkIfUserExistsEmail(
                              _emailTextController.text)) {
                            showSnackBar(
                                context,
                                "Oops!",
                                "Looks like you used another provider to sign up! Please use the same provider to login!",
                                ContentType.help);
                          } else {
                            showSnackBar(
                                context,
                                "Hmm...",
                                "Incorrect E-Mail or Password",
                                ContentType.warning);
                          }
                        }
                      });
                    }),
                  ),
                ),

                // Or Sign In With
                FadeAnimation(2.1, signUpOption()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 40, 5, 0),
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
                            'Or Sign In With',
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

                // Bottom Provider Buttons
                FadeAnimation(
                  2.4,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            authProvider.signUpWithGoogle(context, () {
                              authProvider.saveUserDataToSP().then(
                                  (value) => authProvider.setSignIn().then(
                                        (value) => authProvider
                                            .setAllInfoCollected()
                                            .then((value) =>
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const HomeScreen())),
                                                )),
                                      ));
                            });
                          },
                          child: Image.asset(
                            "assets/images/google.png",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              // authProvider.signInWithGoogle(context);
                            },
                            child: Image.asset(
                              "assets/images/facebook.png",
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
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
                    builder: (context) => const RegistrationScreen()));
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
