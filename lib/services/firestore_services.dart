import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sycon_ticketing_app/models/registration.dart';

Future<Map<String, dynamic>> getRegistrations(int referralCode,
    {bool onlyPaid = false}) async {
  QuerySnapshot<Map<String, dynamic>> regQuerySnapshot;
  if (onlyPaid) {
    regQuerySnapshot = await FirebaseFirestore.instance
        .collection("registrations")
        .where("referral_code", isEqualTo: referralCode)
        .where("hasPaid", isEqualTo: true)
        .get();
  } else {
    regQuerySnapshot = await FirebaseFirestore.instance
        .collection("registrations")
        .where("referral_code", isEqualTo: referralCode)
        .get();
  }
  List<Registration> registrationsList = [];
  int cash = 0, onlineMoney = 0;
  for (int i = 0; i < regQuerySnapshot.docs.length; i++) {
    registrationsList.add(Registration.fromJson(
        regQuerySnapshot.docs.elementAt(i).data(),
        regQuerySnapshot.docs.elementAt(i).id));
    if (registrationsList.elementAt(i).hasPaid) {
      if (registrationsList.elementAt(i).paymentLink != null) {
        onlineMoney += 200;
      } else {
        cash += 200;
      }
    }
  }
  return {
    'registrationsList': registrationsList,
    'cash': cash,
    'onlineMoney': onlineMoney
  };
}

Future sendQREmail(String documentID, String fullName, String email) async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('sendEmailForRegistration');
  await callable.call(<String, dynamic>{
    'docId': documentID,
    'fullName': fullName,
    'email': email,
  });
}

Future fetchRegisterInformation(String documentId) async {
  DocumentSnapshot<Map<String, dynamic>> registrationDocument;
  try {
    if (documentId.contains("/")) {
      return null;
    }
    registrationDocument = await FirebaseFirestore.instance
        .collection("registrations")
        .doc(documentId)
        .get();
    return Registration.fromJson(registrationDocument.data()!, documentId);
  } catch (e) {
    return null;
  }
}

Future allowRegisterAccess(String documentId, {required bool isEntry}) async {
  if (isEntry) {
    await FirebaseFirestore.instance
        .collection("registrations")
        .doc(documentId)
        .update({"isEntry": true});
  } else {
    await FirebaseFirestore.instance
        .collection("registrations")
        .doc(documentId)
        .update({"isLunch": true});
  }
}

Future setRegisterPaid(String documentId, int referralCode) async {
  await FirebaseFirestore.instance
      .collection("registrations")
      .doc(documentId)
      .update({"referral_code": referralCode, "hasPaid": true});
}

Future incrementUserReferral() async {
  QuerySnapshot<Map<String, dynamic>> userQuerySnapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();
  String documentId = userQuerySnapshot.docs.first.id;
  int registrationsCount =
      userQuerySnapshot.docs.first.get("registrations") as int;
  await FirebaseFirestore.instance
      .collection("users")
      .doc(documentId)
      .update({"registrations": registrationsCount + 1});
}
