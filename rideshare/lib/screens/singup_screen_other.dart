import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_picker/country_picker.dart';
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

class SignUpScreenOther extends StatefulWidget {
  const SignUpScreenOther({super.key});

  @override
  State<SignUpScreenOther> createState() => _SignUpScreenOtherState();
}

class _SignUpScreenOtherState extends State<SignUpScreenOther> {
  File? image;
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isPasswordVisible = true;
  bool isChecked = false;

  Country selectedCountry = Country(
      phoneCode: "1",
      countryCode: "CA",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Canada",
      example: "Canada",
      displayName: "Canada",
      displayNameNoCountryCode: "CA",
      e164Key: "");

  @override
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
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
                                  backgroundImage: getProfilePic(context),
                                  radius: 50,
                                ),
                        ),
                      ),

                      // First Name, Last Name
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: reusableTextField(
                                  "First Name",
                                  Icons.person_outline,
                                  _firstNameController,
                                  false),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: reusableTextField(
                                  "Last Name",
                                  Icons.person_outline,
                                  _lastNameController,
                                  false),
                            ),
                          ],
                        ),
                      ),

                      // Email Box
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: reusableTextField("E-Mail", Icons.email_outlined,
                            _emailTextController, true),
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

                      // Phone Number Box
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: TextField(
                          // Type of controller
                          controller: _phoneNumberController,

                          // Configurations
                          cursorColor: Colors.white,

                          onChanged: (value) {
                            setState(() {
                              _phoneNumberController.text = value;
                            });
                          },
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18),

                          // Add decoration to text box
                          decoration: InputDecoration(
                            // Prefixed icon
                            prefixIcon: Container(
                              padding: const EdgeInsets.fromLTRB(10, 11, 10, 0),
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                      context: context,
                                      countryListTheme:
                                          const CountryListThemeData(
                                              bottomSheetHeight: 500),
                                      onSelect: (value) {
                                        setState(() {
                                          selectedCountry = value;
                                        });
                                      });
                                },
                                child: Text(
                                  "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.9)),
                                ),
                              ),
                            ),

                            suffixIcon: _phoneNumberController.text.length > 9
                                ? Container(
                                    height: 30,
                                    width: 30,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Icon(Icons.done,
                                        color: Colors.white, size: 20),
                                  )
                                : null,

                            // Test Styling
                            labelText: "Phone Number",
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

                          keyboardType: TextInputType.number,
                        ),
                      ),

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
                            // Check if any are empty
                            if (_firstNameController.text == "" ||
                                _lastNameController.text == "" ||
                                _emailTextController.text == "" ||
                                _passwordTextController.text == "" ||
                                _phoneNumberController.text == "") {
                              showSnackBar(
                                  context,
                                  "Oops!",
                                  "Please fill in all fields",
                                  ContentType.warning);
                            }

                            // Validate E-Mail
                            sendEmail(context, _emailTextController.text,
                                _passwordTextController.text);
                            sendPhoneNumber(
                                context, _phoneNumberController.text);
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

  void sendEmail(BuildContext context, String email, String password) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    if (EmailValidator.validate(_emailTextController.text)) {
      if (_passwordTextController.text.length >= 6) {
        final AuthCredential authCredential =
            EmailAuthProvider.credential(email: email, password: password);
        authProvider.linkUserData(authCredential);

        storeData();
      } else {
        showSnackBar(context, "Oops!",
            "Password length must be atleast 6 characters", ContentType.help);
      }
    } else {
      showSnackBar(context, "Oops!", "Invalid Email", ContentType.warning);
    }
  }
}
