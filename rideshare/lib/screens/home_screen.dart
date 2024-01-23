import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/modules/profilemanagement_module/screens/profile_screen.dart';
import 'package:rideshare/utils/color_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    authProvider.getUserDataFromFirebase().whenComplete(() {
      precacheImage(NetworkImage(authProvider.userModel.profilePic), context);
    });

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: hexStringToColor("6c7373"),
        ),
        child: Column(children: [
          // Profile Pic
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 20, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: const ProfileScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 300)),
                );
              },
              child: Container(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  backgroundImage:
                      NetworkImage(authProvider.userModel.profilePic),
                  radius: 20,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
