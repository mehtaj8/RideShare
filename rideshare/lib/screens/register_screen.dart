import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'package:rideshare/screens/singup_screen_other.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/utils/utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
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
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(children: <Widget>[
                    // Top Icon
                    Container(
                      height: 100,
                      width: 100,
                      child: Icon(
                        Icons.create_outlined,
                        size: 100,
                        color: hexStringToColor("ffcc66").withOpacity(0.7),
                      ),
                    ),

                    // Top text
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        "Let's Get You Registered!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Add Phone Number Text
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "Add your Phone Number, We'll send you a Verification Code!",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Phone Number box
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                            color: Colors.white.withOpacity(0.9), fontSize: 18),

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

                    // Register
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: firebaseUIButton(context, "Register", () {
                        sendPhoneNumber(context, _phoneNumberController.text);
                      }),
                    ),

                    // Or Sign Up With
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                      child: Row(children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Sign Up With',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ]),
                    ),

                    // Bottom Provider Buttons
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
                                          (value) => Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const SignUpScreenOther())),
                                              (route) => false)),
                                    );
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
                                authProvider.signUpWithFacebook(context, () {
                                  authProvider.saveUserDataToSP().then(
                                        (value) => authProvider
                                            .setSignIn()
                                            .then((value) =>
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            const SignUpScreenOther())),
                                                    (route) => false)),
                                      );
                                });
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
                  ])),
            )));
  }
}
