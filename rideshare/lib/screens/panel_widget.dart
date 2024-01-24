import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    super.key,
    required this.controller,
    required this.panelController,
  });

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      controller: widget.controller,
      children: [
        // Top Panel Button
        GestureDetector(
          onTap: () {
            widget.panelController.panelPosition.round() == 1
                ? widget.panelController.close()
                : widget.panelController.open();
          },
          child: Center(
              child: Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            alignment: Alignment.topCenter,
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
          )),
        ),

        // Sliding Switch
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SlidingSwitch(
              textOff: "Trips",
              textOn: "Messages",
              value: false,
              onChanged: (value) {},
              onTap: () {},
              onDoubleTap: (value) {},
              onSwipe: (value) {},
              buttonColor: Colors.white70,
              colorOn: Colors.black87,
              colorOff: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
