import 'package:flutter/material.dart';
import 'package:rideshare/utils/color_utils.dart';

Stack logoWidget(BuildContext context) {
  // return Image.asset(
  //   imageName,
  //   fit: BoxFit.cover,
  //   width: 80,
  //   height: 80,
  //   color: Colors.white,
  // );
  return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          width: 270,
          height: 50,
          decoration: BoxDecoration(
            color: hexStringToColor("343b3e"),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: hexStringToColor("ffcc66"), offset: Offset(7, 7)),
              const BoxShadow(color: Colors.white70, offset: Offset(3, 3)),
            ],
          ),
        ),
        Text(
          "RIDESHARE",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'AstroSpace',
            fontSize: 40,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ]);
}

TextField reusableTextField(
    String text, IconData icon, TextEditingController controller) {
  return TextField(
    // Type of controller
    controller: controller,

    // Configurations
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),

    // Add decoration to text box
    decoration: InputDecoration(
      // Prefixed icon
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),

      // Test Styling
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: false,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),

      // Border Styling
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.white, width: 2, style: BorderStyle.solid)),
      border: OutlineInputBorder(),
    ),
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 15, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),

    // Elevated Button creation
    child: ElevatedButton(
      // When pressed
      onPressed: () {
        onTap();
      },

      // Styling and Shape
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return hexStringToColor("ffcc66").withOpacity(0.7);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),

      // Text of button
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    ),
  );
}
