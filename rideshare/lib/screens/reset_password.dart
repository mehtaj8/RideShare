import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/reusable_widgets/reusable_widget.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/utils/utils.dart';

// TODO: Actually make forgot password email link work

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
  }

  Future passwordReset() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    if (!await authProvider.checkIfUserExistsEmail(_emailTextController.text)) {
      showSnackBar(
          context, "Error!", "User Does Not Exist", ContentType.failure);
    } else {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text.trim())
          .then((value) => Navigator.of(context).pop())
          .catchError((onError) {
        print(onError.code);
        if (onError.code == 'missing-email') {
          showSnackBar(
              context, "Hmm...", "Please Enter an E-Mail", ContentType.help);
        }
        if (onError.code == 'invalid-email') {
          showSnackBar(context, "Oops!", "Please Enter a Valid E-Mail",
              ContentType.warning);
        }
      });
    }
  }

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
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.email_outlined,
                    size: 100,
                    color: hexStringToColor("ffcc66").withOpacity(0.7),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Enter your E-Mail and we will send you a Password Reset Link",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: reusableTextField("E-Mail", Icons.person_outline,
                      _emailTextController, false),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: firebaseUIButton(
                      context, "Reset Password", () => passwordReset()),
                )
              ],
            ),
          ))),
    );
  }
}
