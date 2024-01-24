import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/modules/profilemanagement_module/screens/profile_screen.dart';
import 'package:rideshare/screens/panel_widget.dart';
import 'package:rideshare/utils/color_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double profileButtonClosed = 170;
  double profileButtonHeight = profileButtonClosed;

  final panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.15;

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
      child: Stack(children: [
        // Tentative Search Box
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 115, 0, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),

        // Sliding Bottom Panel
        SlidingUpPanel(
          controller: panelController,
          borderRadius: BorderRadius.circular(20),
          color: hexStringToColor("ffcc66"),
          maxHeight: panelHeightOpen,
          minHeight: panelHeightClosed,
          panelBuilder: (controller) => PanelWidget(
            controller: controller,
            panelController: panelController,
          ),
          onPanelSlide: (position) => setState(() {
            final panelMaxScrollExtent = panelHeightOpen - panelHeightClosed;
            profileButtonHeight =
                position * panelMaxScrollExtent + profileButtonClosed;
          }),
        ),

        // Profile Button
        Positioned(
          right: 15,
          bottom: profileButtonHeight,
          child: Stack(children: [
            GestureDetector(
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
                  backgroundColor: hexStringToColor("ffcc66"),
                  backgroundImage:
                      NetworkImage(authProvider.userModel.profilePic),
                  radius: 20,
                ),
              ),
            ),
          ]),
        ),
      ]),
    ));
  }
}
