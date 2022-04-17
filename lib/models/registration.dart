class Registration {
  String fullName;
  String registerNumber;
  String phone;
  String year;
  int referralCode;
  String degree;
  String branch;
  String email;
  bool hasPaid;
  bool isEntry;
  bool isLunch;
  String? paymentLink;
  String documentId;
  Registration(
      this.fullName,
      this.registerNumber,
      this.phone,
      this.year,
      this.referralCode,
      this.degree,
      this.branch,
      this.email,
      this.hasPaid,
      this.isEntry,
      this.isLunch,
      this.documentId,
      {this.paymentLink});
  factory Registration.fromJson(Map<String, dynamic> json, String documentId) {
    return Registration(
        json['fullName'],
        json['registerNumber'],
        json['phone'],
        json['year'],
        json['referral_code'],
        json['degree'],
        json['branch'],
        json['email'],
        json['hasPaid'],
        json['isEntry'],
        json['isLunch'],
        documentId,
        paymentLink: json['paymentLink']);
  }

  String displayYear() {
    String result = "";
    switch (year) {
      case '1':
        result = "1st Year";
        break;
      case '2':
        result = "2nd Year";
        break;
      case '3':
        result = "3rd Year";
        break;
      case '4':
        result = "4th Year";
        break;
    }
    return result;
  }

  String displayYearInRoman() {
    switch (year) {
      case '1':
        return 'I';
      case '2':
        return 'II';
      case '3':
        return 'III';
      case '4':
        return 'IV';
      default:
        return 'I';
    }
  }
}
