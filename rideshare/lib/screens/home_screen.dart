import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/screens/signin_screen.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Column(children: [
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: hexStringToColor("ffcc66").withOpacity(0.7),
                  backgroundImage:
                      NetworkImage(authProvider.userModel.profilePic),
                  radius: 50,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Text(authProvider.userModel.firstName),
        ),
        Text(authProvider.userModel.lastName),
        Text(authProvider.userModel.phoneNumber),
        Text(authProvider.userModel.email),
      ]),
    );
  }
}
