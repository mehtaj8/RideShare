import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DriverScreen extends StatefulWidget {
  bool allInfoFilledIn;

  DriverScreen({super.key, required this.allInfoFilledIn});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Driver Account Text
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Container(
          alignment: Alignment.topCenter,
          child: const Text(
            "Driver Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),

      // Save Button
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: ElevatedButton(
          child: Text("Save"),
          onPressed: () {
            setState(() {
              widget.allInfoFilledIn = true;
            });
          },
        ),
      ),

      // Unsave Button
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: ElevatedButton(
          child: Text("Unsave"),
          onPressed: () {
            setState(() {
              widget.allInfoFilledIn = false;
            });
          },
        ),
      ),
    ]);
  }
}
