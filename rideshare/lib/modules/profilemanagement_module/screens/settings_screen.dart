import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/modules/authentication_module/screens/signin_screen.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/utils/color_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          child: Column(
            children: [
              // Logout Button
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: ElevatedButton(
                  child: Text("Logout"),
                  onPressed: () {
                    authProvider.userSignOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
