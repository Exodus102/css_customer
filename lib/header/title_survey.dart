import 'package:flutter/material.dart';

class TitleSurvey extends StatelessWidget {
  const TitleSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/images/urs_logo.png",
          fit: BoxFit.contain,
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NURTURING TOMMOROW’S NOBLEST',
              style: TextStyle(
                color: const Color(0xFFF1F7F9),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
                fontSize: 15,
              ),
            ),
            Text(
              'UNIVERSITY OF RIZAL SYSTEM',
              style: TextStyle(
                color: const Color(0xFFF1F7F9),
                fontWeight: FontWeight.bold,
                fontSize: 25,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            Text(
              'CUSTOMER SATISFACTION SURVEY SYSTEM',
              style: TextStyle(
                color: const Color(0xFFF1F7F9),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
                fontSize: 15,
              ),
            ),
          ],
        )
      ],
    );
  }
}
