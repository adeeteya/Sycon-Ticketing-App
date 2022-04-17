import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/providers.dart';
import 'package:sycon_ticketing_app/widgets/referral_table.dart';
import 'package:sycon_ticketing_app/widgets/prompts/sign_out_dialog.dart';
import 'package:sycon_ticketing_app/widgets/text/animated_text.dart';

class AccountStats extends ConsumerStatefulWidget {
  const AccountStats({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AccountStatsState();
}

class _AccountStatsState extends ConsumerState<AccountStats> {
  String _segmentedGroupValue = "Paid";
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Stats"),
        actions: [
          IconButton(
            onPressed: () {
              showSignOutDialog(context);
            },
            icon: const Icon(
              Icons.logout,
              color: kRichBlack,
            ),
          ),
        ],
      ),
      body: userData.when(
        data: (userData) => Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: AnimatedCounter(endVal: userData.cash),
                              ),
                            ),
                            const Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Cash Collected",
                                  style: TextStyle(
                                    color: kRichBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: AnimatedCounter(
                                  endVal: userData.onlineMoney,
                                  isBlue: false,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Online Money",
                                  style: TextStyle(
                                    color: kRichBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 16,
                  bottom: 5,
                  right: 8,
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CupertinoSlidingSegmentedControl<String>(
                      backgroundColor: kBrightGrey,
                      groupValue: _segmentedGroupValue,
                      padding: const EdgeInsets.all(2),
                      children: {
                        "Paid": Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "Paid Referrals (${userData.registrationList.where((element) => element.hasPaid).length})",
                            style: const TextStyle(
                                color: kRichBlack, fontWeight: FontWeight.w600),
                          ),
                        ),
                        "Unpaid": Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "Unpaid Referrals (${userData.registrationList.where((element) => !element.hasPaid).length})",
                            style: const TextStyle(
                                color: kRichBlack, fontWeight: FontWeight.w600),
                          ),
                        ),
                      },
                      onValueChanged: (segmentKey) {
                        setState(() {
                          _segmentedGroupValue = segmentKey ?? "Paid";
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ReferralTable(
                      registrationList: (_segmentedGroupValue == "Paid")
                          ? userData.registrationList
                              .where((element) => element.hasPaid)
                              .toList()
                          : userData.registrationList
                              .where((element) => !element.hasPaid)
                              .toList(),
                      hasPaid: _segmentedGroupValue == "Paid",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        error: (_, __) => Center(
          child: Lottie.asset('assets/lottie/error.json'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
