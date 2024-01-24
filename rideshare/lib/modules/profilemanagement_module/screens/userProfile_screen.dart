import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/utils/utils.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                backgroundImage:
                    NetworkImage(authProvider.userModel.profilePic),
                radius: 30,
              ),
            ),
            Column(children: [
              Row(children: [
                // First Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 40, 5, 0),
                  child: Text(
                    authProvider.userModel.firstName,
                    textScaler: TextScaler.linear(1.5),
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Last Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(
                    authProvider.userModel.lastName,
                    textScaler: TextScaler.linear(1.5),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),

              // Joined on
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Joined: ${convertCreatedAt(authProvider.userModel.createdAt)}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
