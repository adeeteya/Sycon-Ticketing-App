import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/providers.dart';
import 'package:sycon_ticketing_app/widgets/tiles/leaderboard_tile.dart';

class LeaderBoard extends ConsumerWidget {
  const LeaderBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderBoardRef = ref.watch(leaderBoardProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBrightGrey,
        title: const Text("Leaderboard"),
      ),
      body: leaderBoardRef.when(
        data: (organizerList) => RefreshIndicator(
          color: kSchoolBusYellow,
          onRefresh: () async {
            ref.invalidate(leaderBoardProvider);
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => kBrightGrey,
                  ),
                  border: const TableBorder(
                    horizontalInside: BorderSide(color: kAltoGrey),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Name",
                        style: kTableHeadingTextStyle,
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text(
                        "Referrals",
                        style: kTableHeadingTextStyle,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Rank",
                        style: kTableHeadingTextStyle,
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text(
                        "Year",
                        style: kTableHeadingTextStyle,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Department",
                        style: kTableHeadingTextStyle,
                      ),
                    ),
                  ],
                  rows: [
                    for (int i = 0; i < organizerList.length; i++)
                      leaderBoardTile(
                        organizerList[i],
                        i,
                        isCurrentUser: organizerList.elementAt(i).email ==
                            FirebaseAuth.instance.currentUser?.email,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        error: (_, __) => Center(
          child: Lottie.asset('assets/lottie/error.json'),
        ),
        loading: () => Center(
          child: Lottie.asset('assets/lottie/trophy_loading.json'),
        ),
      ),
    );
  }
}
