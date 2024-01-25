import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/models/registration.dart';
import 'package:sycon_ticketing_app/widgets/status_pill.dart';

Future showScannedResultBottomSheet(
    BuildContext context, Registration scannedResult, bool isSuccessful) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 15,
      ),
      child: Column(
        children: [
          Lottie.asset(
            (isSuccessful)
                ? "assets/lottie/verification_success.json"
                : "assets/lottie/verification_failure.json",
            repeat: false,
            width: 135,
            height: 135,
          ),
          Text(
            (isSuccessful) ? "Verification Successful" : "QR Already Scanned",
            style: const TextStyle(
              color: kRichBlack,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scannedResult.fullName,
                    style: const TextStyle(
                      color: kRichBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    scannedResult.registerNumber,
                    style: TextStyle(
                      color: kRichBlack.withOpacity(0.5),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    scannedResult.branch,
                    style: TextStyle(
                      color: kRichBlack.withOpacity(0.7),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    scannedResult.displayYear(),
                    style: TextStyle(
                      color: kRichBlack.withOpacity(0.5),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              StatusPill(
                isLunch: false,
                isSuccess: scannedResult.isEntry,
              ),
              const SizedBox(width: 20),
              StatusPill(
                isLunch: true,
                isSuccess: scannedResult.isLunch,
              ),
              const Spacer(flex: 10),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Continue Scanning"),
            ),
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}

Future showScannedErrorDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Invalid QR Code"),
      content: const Text(
          "QR Code is either Invalid or some unknown error occurred."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(foregroundColor: kEbonyBlack),
          child: const Text("Ok"),
        )
      ],
    ),
  );
}
