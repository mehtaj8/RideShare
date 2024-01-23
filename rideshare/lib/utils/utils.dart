import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/model/user_model.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/modules/authentication_module/screens/signin_screen.dart';
import 'package:intl/intl.dart';

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

// Show Snack Bar
void showSnackBar(BuildContext context, String title, String content,
    ContentType contentType) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Transform.scale(
      scale: 0.9,
      child: AwesomeSnackbarContent(
          title: title, message: content, contentType: contentType),
    ),
    behavior: SnackBarBehavior.floating,
  ));
}

// Pick Image from gallery
Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, "Error", e.toString(), ContentType.failure);
  }

  return image;
}

// Sign Up with Phone Number
Future<void> sendPhoneNumber(BuildContext context, String phoneNumber) async {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
  if (phoneNumber.length <= 9) {
    showSnackBar(context, "Error", "The Provided Phone Number is not Valid.",
        ContentType.failure);
  } else {
    if (await authProvider
        .checkIfUserExistsPhone("+${selectedCountry.phoneCode}$phoneNumber")) {
      showSnackBar(context, "Error", "This Phone Number already exists",
          ContentType.failure);
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const SignInScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 300)),
          (route) => false);
    } else {
      authProvider.signUpWithPhone(
          context, "+${selectedCountry.phoneCode}$phoneNumber");
    }
  }
}

// Link Phone Number
Future<void> linkPhoneNumber(BuildContext context, String firstName,
    String lastName, String email, String phoneNumber, String image) async {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
  if (phoneNumber.length <= 9) {
    showSnackBar(context, "Error", "The Provided Phone Number is not Valid.",
        ContentType.failure);
  } else {
    if (await authProvider
        .checkIfUserExistsPhone("+${selectedCountry.phoneCode}$phoneNumber")) {
      showSnackBar(
          context, "Oops!", "Phone number already in use", ContentType.failure);
    } else {
      authProvider.setAllInfoCollected();
      storeDataOther(context, firstName, lastName, email,
          "+${selectedCountry.phoneCode}$phoneNumber", image);
      authProvider.linkPhone(
          context, "+${selectedCountry.phoneCode}$phoneNumber");
    }
  }
}

// Link Phone Number if given a new profile pic
Future<void> linkPhoneNumberNewProfilePic(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    File? image) async {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
  if (phoneNumber.length <= 9) {
    showSnackBar(context, "Error", "The Provided Phone Number is not Valid.",
        ContentType.failure);
  } else {
    User? user = await authProvider.getCurrentUser();
    String uid = user!.uid;
    String profilePic =
        await authProvider.storeFileToStorage("profilePic/$uid", image!);
    if (await authProvider
        .checkIfUserExistsPhone("+${selectedCountry.phoneCode}$phoneNumber")) {
      showSnackBar(
          context, "Oops!", "Phone number already in use", ContentType.failure);
    } else {
      storeDataOther(context, firstName, lastName, email,
          "+${selectedCountry.phoneCode}$phoneNumber", profilePic);
      authProvider.linkPhone(
          context, "+${selectedCountry.phoneCode}$phoneNumber");
    }
  }
}

// Link E-Mail
Future<void> linkEmail(BuildContext context, String firstName, String lastName,
    String email, String password, File image) async {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
  if (EmailValidator.validate(email)) {
    if (password.length >= 6) {
      if (await authProvider.checkIfUserExistsEmail(email)) {
        showSnackBar(
            context,
            "Error!",
            "E-Mail already in use! Please log in with the same provider you used to sign up!",
            ContentType.failure);
        User? user = await authProvider.getCurrentUser();
        user?.delete();
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const SignInScreen(),
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300)),
            (route) => false);
      } else {
        final AuthCredential authCredential =
            EmailAuthProvider.credential(email: email, password: password);
        authProvider.linkUserData(authCredential);

        authProvider.getUserDataFromFirebase().whenComplete(
          () {
            authProvider.setAllInfoCollected();
            storeDataPhoneNumber(context, firstName, lastName, email, image);
          },
        );
      }
    } else {
      showSnackBar(context, "Oops!",
          "Password length must be atleast 6 characters", ContentType.help);
    }
  } else {
    showSnackBar(context, "Oops!", "Invalid Email", ContentType.warning);
  }
}

// Store Data Other Providers
void storeDataOther(BuildContext context, String firstName, String lastName,
    String email, String phoneNumber, String image) async {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);

  authProvider.saveUserDataToFirebaseOtherNewProfilePic(
    context: context,
    userModel: authProvider.userModel,
    firstName: firstName.trim(),
    lastName: lastName.trim(),
    phoneNumber: phoneNumber.trim(),
    profilePic: image.trim(),
    onSuccess: () {
      // Once Data is stored, store it locally.
      authProvider.saveUserDataToSP().then(
            (value) => authProvider
                .setSignIn()
                .then((value) => authProvider.setAllInfoCollected()),
          );
    },
  );
}

// Store Data Phone Number Sign Up
void storeDataPhoneNumber(BuildContext context, String firstName,
    String lastName, String email, File image) async {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
  UserModel userModel = UserModel(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      phoneNumber: "",
      profilePic: "",
      createdAt: "",
      provider: "phone",
      uid: "");
  authProvider.saveUserDataToFirebase(
    context: context,
    userModel: userModel,
    profilePic: image,
    onSuccess: () {
      // Once Data is stored, store it locally.
      authProvider
          .saveUserDataToSP()
          .then((value) => authProvider.setSignIn().then(
                (value) => authProvider.setAllInfoCollected().then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const HomeScreen())),
                        (route) => false)),
              ));
    },
  );
}

// Get Profile Pic
NetworkImage? getProfilePic(BuildContext context) {
  final authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
  authProvider.getUserDataFromFirebase().whenComplete(() {
    return NetworkImage(authProvider.userModel.profilePic);
  });
  return null;
}

// Convert Created At to MM/dd/yyyy
String convertCreatedAt(String createdAt) {
  var date = DateTime.fromMillisecondsSinceEpoch(int.parse(createdAt));
  return DateFormat('MMM d yyyy').format(date);
}
