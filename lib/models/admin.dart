import 'package:sycon_ticketing_app/models/user_data.dart';

class AdminData {
  int overallCash;
  int overallOnlineMoney;
  List<UserData> usersList;
  AdminData(this.overallCash, this.overallOnlineMoney, this.usersList);

  int getTotalMoney() {
    return overallCash + overallOnlineMoney;
  }

  int getYCoordinate() {
    int maxVal = 0;
    List<int> ticketsSoldPerYear = [
      getTicketsSold(1),
      getTicketsSold(2),
      getTicketsSold(3),
      getTicketsSold(4)
    ];
    for (var element in ticketsSoldPerYear) {
      if (element > maxVal) maxVal = element;
    }
    return maxVal + 2;
  }

  int getTicketsSold(int year, {String? department}) {
    int count = 0;
    for (var user in usersList) {
      for (var element in user.registrationList) {
        if (int.parse(element.year) == year) {
          if (department == null) {
            count++;
          } else if (element.branch == department) {
            count++;
          }
        }
      }
    }
    return count;
  }

  int getTotalTicketsSold() {
    return getTicketsSold(1) +
        getTicketsSold(2) +
        getTicketsSold(3) +
        getTicketsSold(4);
  }
}
