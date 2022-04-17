class Organizer {
  String email;
  String name;
  String department;
  int referralCount;
  int year;
  Organizer(
      this.email, this.name, this.department, this.referralCount, this.year);
  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(json['email'], json['fullName'], json['branch'],
        json['registrations'], json['year']);
  }
  String yearInRomanNumerals() {
    switch (year) {
      case 1:
        return 'I';
      case 2:
        return 'II';
      case 3:
        return 'III';
      case 4:
        return 'IV';
      default:
        return 'IV';
    }
  }
}
