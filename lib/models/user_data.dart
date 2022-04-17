import 'package:sycon_ticketing_app/models/organizer.dart';
import 'package:sycon_ticketing_app/models/registration.dart';

class UserData extends Organizer {
  int referralCode;
  int cash;
  int onlineMoney;
  List<Registration> registrationList = [];
  UserData(email, name, department, referralCount, year, this.referralCode,
      this.cash, this.onlineMoney, this.registrationList)
      : super(email, name, department, referralCount, year);
  factory UserData.fromJson(Map<String, dynamic> json, int cash,
      int onlineMoney, List<Registration> registrations) {
    return UserData(
        json['email'],
        json['fullName'],
        json['branch'],
        json['registrations'],
        json['year'],
        json['referral_code'],
        cash,
        onlineMoney,
        registrations);
  }
}
