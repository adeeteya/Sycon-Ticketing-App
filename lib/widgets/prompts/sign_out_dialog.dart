import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';

Future showSignOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Sign Out"),
      content: const Text("Do you want to sign out?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: kEbonyBlack),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance
                .signOut()
                .then((value) => Navigator.pop(context));
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text("Yes"),
        ),
      ],
    ),
  );
}
