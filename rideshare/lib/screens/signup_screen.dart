import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/model/user_model.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'dart:io';

import 'package:rideshare/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? image;
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool isPasswordVisible = true;
  bool isChecked = false;

  @override
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  // Selecting Image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

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
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: hexStringToColor("ffcc66").withOpacity(0.7),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      // Title
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          "Let's Create Your Account!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      // Photo
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? CircleAvatar(
                                  backgroundColor: hexStringToColor("ffcc66")
                                      .withOpacity(0.7),
                                  radius: 50,
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: const Text(
                          "Please add a Profile Picture",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),

                      // First Name, Last Name
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: reusableTextField("First Name",
                                  Icons.person_outline, _firstNameController),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: reusableTextField("Last Name",
                                  Icons.person_outline, _lastNameController),
                            ),
                          ],
                        ),
                      ),

                      // Email Box
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: reusableTextField("E-Mail", Icons.email_outlined,
                            _emailTextController),
                      ),

                      // Password Box
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: TextField(
                            // Type of controller
                            controller: _passwordTextController,

                            // Configurations
                            obscureText: isPasswordVisible,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: Colors.white,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),

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
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: false,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                          )),

                      // Terms and Conditions
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    })),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white)),
                                TextSpan(
                                    text: " and ",
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: "Terms of Use",
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white)),
                              ])),
                            ),
                          ],
                        ),
                      ),

                      // Sign Up Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: firebaseUIButton(context, "Create Account", () {
                          if (isChecked) {
                            final authProvider =
                                Provider.of<AuthenticationProvider>(context,
                                    listen: false);

                            print(_firstNameController.text);
                            print(_lastNameController.text);
                            print(_emailTextController.text);
                            print(_passwordTextController.text);

                            if (_firstNameController.text != "" &&
                                _lastNameController.text != "" &&
                                _emailTextController.text != "" &&
                                _passwordTextController.text != "") {
                              if (EmailValidator.validate(
                                  _emailTextController.text)) {
                                if (_passwordTextController.text.length >= 6) {
                                  final AuthCredential authCredential =
                                      EmailAuthProvider.credential(
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text);
                                  authProvider.linkUserData(authCredential);
                                  storeData();
                                } else {
                                  showSnackBar(
                                      context,
                                      "Oops!",
                                      "Password length must be atleast 6 characters",
                                      ContentType.help);
                                }
                              } else {
                                showSnackBar(context, "Oops!", "Invalid Email",
                                    ContentType.warning);
                              }
                            } else {
                              showSnackBar(
                                  context,
                                  "Oops!",
                                  "Please fill in all fields",
                                  ContentType.warning);
                            }
                          } else {
                            showSnackBar(
                                context,
                                "Oops!",
                                "Please agree to Privacy Policy and Terms of Use",
                                ContentType.warning);
                          }
                        }),
                      )
                    ],
                  ),
                ))),
    );
  }

  void storeData() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    UserModel userModel = UserModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailTextController.text.trim(),
        phoneNumber: "",
        profilePic: "",
        createdAt: "",
        uid: "");
    if (image != null) {
      authProvider.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          // Once Data is stored, store it locally.
          authProvider.saveUserDataToSP().then(
                (value) => authProvider.setSignIn().then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const HomeScreen())),
                        (route) => false)),
              );
        },
      );
    } else {
      showSnackBar(context, "Oops!", "Please Upload a Profile Picture",
          ContentType.help);
    }
  }
}
