import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sycon_ticketing_app/models/admin.dart';
import 'package:sycon_ticketing_app/models/organizer.dart';
import 'package:sycon_ticketing_app/models/registration.dart';
import 'package:sycon_ticketing_app/models/user_data.dart';
import 'package:sycon_ticketing_app/services/firestore_services.dart';

final leaderBoardProvider = FutureProvider<List<Organizer>>((ref) async {
  List<Organizer> resultList = [];
  QuerySnapshot<Map<String, dynamic>> usersQuerySnapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .orderBy("registrations", descending: true)
          .get();
  for (int i = 0; i < usersQuerySnapshot.docs.length; i++) {
    resultList.add(Organizer.fromJson(usersQuerySnapshot.docs[i].data()));
  }
  return resultList;
});

final userDataProvider = FutureProvider<UserData>((ref) async {
  QuerySnapshot<Map<String, dynamic>> userQuerySnapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();
  Map<String, dynamic> registrationsData = await getRegistrations(
      userQuerySnapshot.docs.first.data()['referral_code']);
  UserData result = UserData.fromJson(
    userQuerySnapshot.docs.first.data(),
    registrationsData['cash'],
    registrationsData['onlineMoney'],
    registrationsData['registrationsList'],
  );
  return result;
});

final adminDataProvider = FutureProvider<AdminData>((ref) async {
  QuerySnapshot<Map<String, dynamic>> userQuerySnapshot =
      await FirebaseFirestore.instance.collection("users").get();
  List<UserData> usersList = [];
  int overallCash = 0, overallOnlineMoney = 0;
  for (int i = 0; i < userQuerySnapshot.docs.length; i++) {
    Map<String, dynamic> registrationsData = await getRegistrations(
        userQuerySnapshot.docs.elementAt(i).data()['referral_code'],
        onlyPaid: true);
    overallCash += registrationsData['cash'] as int;
    overallOnlineMoney += registrationsData['onlineMoney'] as int;
    usersList.add(UserData.fromJson(
      userQuerySnapshot.docs.elementAt(i).data(),
      registrationsData['cash'],
      registrationsData['onlineMoney'],
      registrationsData['registrationsList'],
    ));
  }

  return AdminData(overallCash, overallOnlineMoney, usersList);
});

final searchResultProvider = FutureProvider.autoDispose
    .family<Registration?, String>((ref, registerNumber) async {
  if (registerNumber == "") return null;
  QuerySnapshot<Map<String, dynamic>> searchQuerySnapshot =
      await FirebaseFirestore.instance
          .collection('registrations')
          .where('registerNumber', isEqualTo: registerNumber)
          .get();
  if (searchQuerySnapshot.docs.isEmpty) return null;
  return Registration.fromJson(
    searchQuerySnapshot.docs.first.data(),
    searchQuerySnapshot.docs.first.id,
  );
});

final adminCheckProvider = FutureProvider.autoDispose<bool>((ref) async {
  DocumentSnapshot<Map<String, dynamic>> adminDocSnapshot =
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get();
  if (adminDocSnapshot.exists) {
    await ref.read(adminDataProvider.future);
  } else {
    await ref.read(userDataProvider.future);
  }
  return adminDocSnapshot.exists;
});
