import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';

class LegendText extends StatelessWidget {
  final bool isBlue;
  final String text;
  final int value;
  const LegendText({
    Key? key,
    this.isBlue = true,
    required this.text,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10,
          width: 10,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: (isBlue) ? kCeruleanBlue : kSchoolBusYellow,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: kDarkGrey),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                color: kEbonyBlack,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }
}
