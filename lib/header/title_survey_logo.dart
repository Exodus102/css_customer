import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TitleSurveyLogo extends StatelessWidget {
  const TitleSurveyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            RichText(
              text: const TextSpan(
                text: 'URS',
                style: TextStyle(
                  color: Color(0xFF95B3D3),
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
                children: [
                  TextSpan(
                    text: 'atisfaction',
                    style: TextStyle(
                      color: Color(0xFFF1F7F9),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  )
                ],
              ),
            ),
            const Text(
              'We comply so URSatisfied',
              style: TextStyle(
                color: Color(0xFFF1F7F9),
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        SvgPicture.asset("assets/svg/images/Logo.svg"),
      ],
    );
  }
}
