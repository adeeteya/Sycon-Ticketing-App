import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/models/organizer.dart';

DataRow leaderBoardTile(Organizer organizer, int index,
    {bool isCurrentUser = false}) {
  return DataRow(
    color: MaterialStateColor.resolveWith(
      (states) => (isCurrentUser)
          ? kSchoolBusYellow
          : (index.isOdd)
              ? Colors.white
              : kCulturedWhite,
    ),
    cells: [
      DataCell(
        Text(
          organizer.name,
          style: TextStyle(
            color: (isCurrentUser) ? kEbonyBlack : kQuickSilver,
          ),
        ),
      ),
      DataCell(
        Text(
          organizer.referralCount.toString(),
          style: TextStyle(
            color: (isCurrentUser) ? kEbonyBlack : kQuickSilver,
          ),
        ),
      ),
      DataCell(
        Center(
          child: (index == 0)
              ? Image.asset(
                  "assets/rank_1.gif",
                  width: 30,
                  height: 30,
                )
              : (index == 1)
                  ? Image.asset(
                      "assets/rank_2.gif",
                      width: 30,
                      height: 30,
                    )
                  : (index == 2)
                      ? Image.asset(
                          "assets/rank_3.gif",
                          width: 30,
                          height: 30,
                        )
                      : Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: (isCurrentUser) ? kEbonyBlack : kQuickSilver,
                          ),
                        ),
        ),
      ),
      DataCell(
        Text(
          organizer.yearInRomanNumerals(),
          style: TextStyle(
            color: (isCurrentUser) ? kEbonyBlack : kQuickSilver,
          ),
        ),
      ),
      DataCell(
        Text(
          organizer.department,
          style: TextStyle(
            color: (isCurrentUser) ? kEbonyBlack : kQuickSilver,
          ),
        ),
      ),
    ],
  );
}
