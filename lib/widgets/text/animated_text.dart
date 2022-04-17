import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';

class AnimatedCounter extends StatelessWidget {
  final int endVal;
  final double? fontSize;
  final bool isBlue;
  const AnimatedCounter(
      {Key? key, required this.endVal, this.isBlue = true, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: endVal.toDouble()),
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      builder: (context, value, _) {
        return Text(
          value.toInt().toString(),
          style: TextStyle(
            color: (isBlue) ? kCeruleanBlue : kSchoolBusYellow,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
