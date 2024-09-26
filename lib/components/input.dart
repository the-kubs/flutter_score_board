import 'package:flutter/material.dart';

class TeamInput extends StatelessWidget {
  final String teamName;
  final String labelText;
  final Color containerColor;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const TeamInput(
      {super.key,
      required this.teamName,
      this.labelText = '',
      required this.containerColor,
      this.keyboardType = TextInputType.text,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      width: MediaQuery.of(context).size.width / (!isPortrait ? 3 : 1),
      color: containerColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(),
              labelText: labelText,
            ),
          ),
        ],
      ),
    );
  }
}
