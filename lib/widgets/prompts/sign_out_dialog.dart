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
          child: const Text("No"),
          style: TextButton.styleFrom(primary: kEbonyBlack),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
          child: const Text("Yes"),
          style: TextButton.styleFrom(primary: Colors.red),
        ),
      ],
    ),
  );
}
