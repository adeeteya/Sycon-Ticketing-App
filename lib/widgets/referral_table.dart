import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/models/registration.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralTable extends StatelessWidget {
  final bool hasPaid;
  final List<Registration> registrationList;

  const ReferralTable(
      {super.key, required this.registrationList, required this.hasPaid});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: (registrationList.isNotEmpty)
          ? ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                    child: DataTable(
                      columnSpacing: 24,
                      showBottomBorder: true,
                      border: const TableBorder(
                        horizontalInside: BorderSide(color: kAltoGrey),
                      ),
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => kBrightGrey,
                      ),
                      columns: [
                        const DataColumn(
                          label: Text(
                            "Name",
                            style: kTableHeadingTextStyle,
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            "Phone",
                            style: kTableHeadingTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            (hasPaid) ? "Entry" : "Register No",
                            style: kTableHeadingTextStyle,
                          ),
                        ),
                        if (hasPaid)
                          const DataColumn(
                            label: Text(
                              "Lunch",
                              style: kTableHeadingTextStyle,
                            ),
                          ),
                      ],
                      rows: [
                        for (int i = 0; i < registrationList.length; i++)
                          DataRow(
                            color: MaterialStateColor.resolveWith((states) =>
                                (i.isOdd) ? Colors.white : kCulturedWhite),
                            cells: [
                              DataCell(
                                Text(
                                  registrationList.elementAt(i).fullName,
                                  style: kTableRowValueTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  registrationList.elementAt(i).phone,
                                  style: const TextStyle(
                                    color: kCeruleanBlue,
                                  ),
                                ),
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      "tel:${registrationList.elementAt(i).phone}"));
                                },
                              ),
                              DataCell(
                                (hasPaid)
                                    ? Center(
                                        child: (registrationList
                                                .elementAt(i)
                                                .isEntry)
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: kMalachiteGreen,
                                              )
                                            : const Icon(
                                                Icons.cancel,
                                                color: kCongoPink,
                                              ),
                                      )
                                    : Text(
                                        registrationList
                                            .elementAt(i)
                                            .registerNumber,
                                        style: kTableRowValueTextStyle,
                                      ),
                              ),
                              if (hasPaid)
                                DataCell(
                                  Center(
                                    child:
                                        (registrationList.elementAt(i).isLunch)
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: kMalachiteGreen,
                                              )
                                            : const Icon(
                                                Icons.cancel,
                                                color: kCongoPink,
                                              ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                (hasPaid) ? "No referrals yet" : "No unpaid referrals",
                style: const TextStyle(fontSize: 16, color: kDarkGrey),
              ),
            ),
    );
  }
}
