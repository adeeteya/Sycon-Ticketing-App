import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';

class StatusPill extends StatelessWidget {
  final bool isLunch;
  final bool isSuccess;

  const StatusPill({super.key, required this.isLunch, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
          decoration: BoxDecoration(
            color: (isSuccess) ? kMalachiteGreen.withOpacity(0.11) : kFairPink,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon((isLunch) ? Icons.local_dining : Icons.login),
              ),
              Text(
                (isLunch) ? "Lunch" : "Entry",
                style: const TextStyle(color: kRichBlack),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: (isSuccess)
              ? const Icon(
                  Icons.check_circle,
                  color: kMalachiteGreen,
                )
              : const Icon(
                  Icons.cancel,
                  color: kCongoPink,
                ),
        ),
      ],
    );
  }
}
