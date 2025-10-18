import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  State<CustomSwitch> createState() => _CustomSwitch();
}

class _CustomSwitch extends State<CustomSwitch> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeThumbColor: darkBlueAccent,
      inactiveThumbColor: whiteColor,
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
      },
    );
  }
}
