import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rideshare/model/user_model.dart';
import 'package:rideshare/modules/authentication_module/screens/singup_screen_other.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/modules/authentication_module/screens/otp_screen.dart';
import 'package:rideshare/modules/authentication_module/screens/signin_screen.dart';
import 'package:rideshare/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _allInfoCollected = false;
  bool get allInfoCollected => _allInfoCollected;

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthenticationProvider() {
    checkSignIn();
    checkAllInfoCollected();
  }

  // Get Current User
  Future<User?> getCurrentUser() async {
    return await _firebaseAuth.currentUser;
  }

  // Get Instance
  FirebaseAuth getInstance() {
    return _firebaseAuth;
  }

  // Check Sign In
  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();
  }

  // Check All Info Collected
  void checkAllInfoCollected() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _allInfoCollected = s.getBool("all_info_collected") ?? false;
    notifyListeners();
  }

  // Set Sign In to true if user signed in
  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // Set All Info Collected to true if all user info is collected
  Future setAllInfoCollected() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("all_info_collected", true);
    _allInfoCollected = true;
    notifyListeners();
  }

  // Link User Data
  void linkUserData(AuthCredential credential) async {
    _firebaseAuth.currentUser?.linkWithCredential(credential);
  }

  // Sign Up with Google
  void signUpWithGoogle(BuildContext context, Function onSuccess) async {
    _isLoading = true;
    notifyListeners();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (userDetails != null) {
      if (await checkIfUserExistsEmail(userDetails.email!)) {
        if (await checkIfUserUsedGoogle(userDetails.email!)) {
          await getUserDataFromFirebase().whenComplete(() {
            _isLoading = false;
            notifyListeners();
            if (userDetails.phoneNumber == null) {
              saveUserDataToSP().then(
                (value) => setSignIn().then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SignUpScreenOther())),
                        (route) => false)),
              );
            } else {
              saveUserDataToSP().then((value) => setSignIn().then(
                    (value) => setAllInfoCollected()
                        .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const HomeScreen())),
                            )),
                  ));
            }
          });
        } else if (await checkIfUserUsedFacebook(userDetails.email!) ||
            await checkIfUserUsedPhone(userDetails.email!)) {
          await getUserDataFromFirebase().whenComplete(() async {
            _userModel!.provider = "google";
            _uid = _userModel!.uid;

            try {
              await _firebaseFirestore
                  .collection("users")
                  .doc(_uid)
                  .set(userModel.toMap())
                  .whenComplete(() {
                _isLoading = false;
                notifyListeners();
              });
            } on FirebaseAuthException catch (e) {
              showSnackBar(
                  context, "Error", e.message.toString(), ContentType.failure);
            }

            setSignIn();
            setAllInfoCollected();
            Navigator.push(
                context,
                PageTransition(
                    child: const HomeScreen(),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 300)));
          });
        }
      } else {
        _uid = userDetails.uid;

        UserModel userModel = UserModel(
            firstName: "",
            lastName: "",
            email: userDetails.email!,
            phoneNumber: "",
            profilePic: userDetails.photoURL!,
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            provider: "google",
            uid: userDetails.uid);

        _userModel = userModel;
        try {
          await _firebaseFirestore
              .collection("users")
              .doc(_uid)
              .set(userModel.toMap())
              .whenComplete(() {
            onSuccess();
            _isLoading = false;
            notifyListeners();
          });
        } on FirebaseAuthException catch (e) {
          showSnackBar(
              context, "Error", e.message.toString(), ContentType.failure);
        }
      }
    }
  }

  // Sign Up with Facebook
  void signUpWithFacebook(BuildContext context, Function onSuccess) async {
    _isLoading = true;
    notifyListeners();

    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);

    if (loginResult.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();

      if (await checkIfUserExistsEmail(userData['email'])) {
        if (await checkIfUserUsedGoogle(userData['email'])) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
          showSnackBar(context, "Oops!", "Please sign in using google",
              ContentType.help);
        } else if (await checkIfUserUsedPhone(userData['email'])) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
          showSnackBar(context, "Oops!",
              "Please sign in with your email and password!", ContentType.help);
        } else if (await checkIfUserUsedFacebook(userData['email'])) {
          final AuthCredential authCredential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);

          await _firebaseAuth.signInWithCredential(authCredential);

          await getUserDataFromFirebase().whenComplete(() async {
            if (!await checkIfUserExistsPhoneUsingEmail(userData['email'])) {
              _isLoading = false;
              notifyListeners();
              saveUserDataToSP().then(
                (value) => setSignIn().then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SignUpScreenOther())),
                        (route) => false)),
              );
            } else {
              _isLoading = false;
              notifyListeners();
              saveUserDataToSP().then((value) => setSignIn().then(
                    (value) => setAllInfoCollected()
                        .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const HomeScreen())),
                            )),
                  ));
            }
          });
        }
      } else {
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        UserCredential result =
            await _firebaseAuth.signInWithCredential(authCredential);

        User? userDetails = result.user;

        UserModel userModel = UserModel(
            firstName: "",
            lastName: "",
            email: userData['email'],
            phoneNumber: "",
            profilePic: "",
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            provider: "facebook",
            uid: userDetails!.uid);

        _uid = userDetails.uid;
        _userModel = userModel;

        try {
          await _firebaseFirestore
              .collection("users")
              .doc(_uid)
              .set(userModel.toMap())
              .whenComplete(() {
            onSuccess();
            _isLoading = false;
            notifyListeners();
          });
        } on FirebaseAuthException catch (e) {
          showSnackBar(
              context, "Error", e.message.toString(), ContentType.failure);
        }
      }
    } else {
      showSnackBar(context, "Hmm...", "Seems something went wrong, try again!",
          ContentType.failure);
    }
  }

  // Sign Up with Phone
  void signUpWithPhone(BuildContext context, String phoneNumber) async {
    _firebaseAuth.setSettings(forceRecaptchaFlow: true);
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          if (error.code == "invalid-phone-number") {
            showSnackBar(context, "Error",
                "The Provided Phone Number is not Valid.", ContentType.failure);
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OtpScreen(verificationId: verificationId)),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  // Link Phone Number
  void linkPhone(BuildContext context, String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          notifyListeners();
          await _firebaseAuth.currentUser
              ?.linkWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          if (error.code == "invalid-phone-number") {
            showSnackBar(context, "Error",
                "The Provided Phone Number is not Valid.", ContentType.failure);
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OtpScreen(verificationId: verificationId)),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  // Verify OTP and Link User
  void verifyOtpLink({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      // User
      await _firebaseAuth.currentUser?.linkWithCredential(creds);
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        showSnackBar(
            context,
            "Error!",
            "OTP is invalid. Please enter correct password",
            ContentType.failure);
      }
    }
  }

  // Verify OTP and sign in
  void verifyOtpSignIn({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      // User
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        _uid = user.uid;
        _isLoading = false;
        notifyListeners();
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        showSnackBar(
            context,
            "Error!",
            "OTP is invalid. Please enter correct password",
            ContentType.failure);
      }
    }
  }

  // User Sign Out
  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    _allInfoCollected = false;
    notifyListeners();
    s.clear();
  }

  // DATABASE OPERATIONS

  // Check if user exists
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  // Check if user exists using email
  Future<bool> checkIfUserExistsEmail(String email) async {
    QuerySnapshot query = await _firebaseFirestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.length == 0) {
      return false;
    }
    return true;
  }

  // Check if user used google sign up
  Future<bool> checkIfUserUsedGoogle(String email) async {
    QuerySnapshot query = await _firebaseFirestore
        .collection("users")
        .where('email', isEqualTo: email)
        .where('provider', isEqualTo: "google")
        .get();
    if (query.docs.length == 0) {
      return false;
    }
    return true;
  }

  // Check if user used facebook sign up
  Future<bool> checkIfUserUsedFacebook(String email) async {
    QuerySnapshot query = await _firebaseFirestore
        .collection("users")
        .where('email', isEqualTo: email)
        .where('provider', isEqualTo: "facebook")
        .get();
    if (query.docs.length == 0) {
      return false;
    }
    return true;
  }

  // Check if user used phone to sign up
  Future<bool> checkIfUserUsedPhone(String email) async {
    QuerySnapshot query = await _firebaseFirestore
        .collection("users")
        .where('email', isEqualTo: email)
        .where('provider', isEqualTo: "phone")
        .get();
    if (query.docs.length == 0) {
      return false;
    }
    return true;
  }

  // Check if user exists using phone number
  Future<bool> checkIfUserExistsPhone(String phoneNumber) async {
    QuerySnapshot query = await _firebaseFirestore
        .collection("users")
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    if (query.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  // Check if user phone number exists using email
  Future<bool> checkIfUserExistsPhoneUsingEmail(String email) async {
    QuerySnapshot query = await _firebaseFirestore
        .collection("users")
        .where('email', isEqualTo: email)
        .where('phoneNumber', isNotEqualTo: "")
        .get();
    if (query.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  // Save Data to firebase for other providers (Google, Apple, Facebook)
  void saveUserDataToFirebaseOther({
    required BuildContext context,
    required UserModel userModel,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Uploading image to firebase storage

      userModel.firstName = firstName;
      userModel.lastName = lastName;
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = phoneNumber;

      _userModel = userModel;

      // Uploading to Database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Error", e.message.toString(), ContentType.failure);
    }
  }

  // User uploaded new Profile Pic
  void saveUserDataToFirebaseOtherNewProfilePic({
    required BuildContext context,
    required UserModel userModel,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Uploading image to firebase storage
      userModel.profilePic = profilePic;
      userModel.firstName = firstName;
      userModel.lastName = lastName;
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = phoneNumber;

      _userModel = userModel;

      // Uploading to Database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .update(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Error", e.message.toString(), ContentType.failure);
    }
  }

  // Save Data to firebase if sign up with phone
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Uploading image to firebase storage
      await getUserDataFromFirebase().then((value) async {
        await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
          userModel.profilePic = value;
          userModel.createdAt =
              DateTime.now().millisecondsSinceEpoch.toString();
          userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
          userModel.uid = _firebaseAuth.currentUser!.uid;
        });

        _userModel = userModel;

        // Uploading to Database
        await _firebaseFirestore
            .collection("users")
            .doc(_uid)
            .set(userModel.toMap())
            .then((value) {
          _isLoading = false;
          notifyListeners();
          onSuccess();
        });
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Error", e.message.toString(), ContentType.failure);
    }
  }

  // Store profile pic
  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Get Current User Data
  Future getUserDataFromFirebase() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return _firebaseFirestore
          .collection('users')
          .doc(await FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        _userModel = UserModel.fromMap(value.data());
      });
    }
  }

  // STORING DATA LOCALLY

  // Save Data to Shared Preferences
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  // Get Data from Shared Preferences
  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }
}
