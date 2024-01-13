import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/signin_screen.dart';
import 'package:flutter/material.dart';

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
      body: Column(children: [
        // Logout Button
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              authProvider.userSignOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ),

        // Profile Pic
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      NetworkImage(authProvider.userModel.profilePic),
                  radius: 50,
                )
              ],
            ),
          ),
        ),

        // First Name
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Text(authProvider.userModel.firstName),
        ),

        // Last Name
        Text(authProvider.userModel.lastName),

        // Phone Number
        Text(authProvider.userModel.phoneNumber),

        // Email
        Text(authProvider.userModel.email),
      ]),
    );
  }
}
