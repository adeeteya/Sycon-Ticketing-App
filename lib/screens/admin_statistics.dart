import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/providers.dart';
import 'package:sycon_ticketing_app/widgets/graphs/tickets_money_pie_graph.dart';
import 'package:sycon_ticketing_app/widgets/graphs/tickets_per_year_bar_graph.dart';
import 'package:sycon_ticketing_app/widgets/prompts/sign_out_dialog.dart';
import 'package:sycon_ticketing_app/widgets/tiles/individual_stats_tile.dart';

class AdminStatistics extends ConsumerStatefulWidget {
  const AdminStatistics({super.key});

  @override
  ConsumerState createState() => _AdminStatisticsState();
}

class _AdminStatisticsState extends ConsumerState<AdminStatistics> {
  String _deptValue = "All";
  String _searchVal = "";

  @override
  Widget build(BuildContext context) {
    final adminDataRef = ref.watch(adminDataProvider);
    final size = MediaQuery.of(context).size;
    return adminDataRef.when(
      data: (adminData) => DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kSchoolBusYellow,
            title: const Text(
              "Statistics",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showSignOutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              indicatorColor: Colors.white,
              labelStyle: TextStyle(
                  fontFamily: 'NunitoSans', fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                  text: "Overall",
                ),
                Tab(
                  text: "Individual",
                ),
              ],
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: TabBarView(
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  children: [
                    Container(
                      height: size.height / 2.25,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tickets Sold",
                                style: TextStyle(
                                  color: kRichBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: kSandSilver),
                                ),
                                child: DropdownButton<String>(
                                  value: _deptValue,
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(4),
                                  iconEnabledColor: kEbonyBlack,
                                  dropdownColor: kAlabasterWhite,
                                  isDense: true,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.expand_more_outlined),
                                  iconSize: 20,
                                  style: const TextStyle(
                                    fontFamily: 'NunitoSans',
                                    color: kDarkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _deptValue = val ?? 'All';
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: 'All',
                                      child: Text('All'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'EEE',
                                      child: Text('EEE'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'ECE',
                                      child: Text('ECE'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'IT',
                                      child: Text('IT'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'CSE',
                                      child: Text('CSE'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'BME',
                                      child: Text('BME'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Civil',
                                      child: Text('Civil'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Mechanical',
                                      child: Text('Mech'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Chemical',
                                      child: Text('Chem'),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TicketsPerYearBarGraph(
                            ticketsData: [
                              adminData.getTicketsSold(1,
                                  department: (_deptValue == 'All')
                                      ? null
                                      : _deptValue),
                              adminData.getTicketsSold(2,
                                  department: (_deptValue == 'All')
                                      ? null
                                      : _deptValue),
                              adminData.getTicketsSold(3,
                                  department: (_deptValue == 'All')
                                      ? null
                                      : _deptValue),
                              adminData.getTicketsSold(4,
                                  department:
                                      (_deptValue == 'All') ? null : _deptValue)
                            ],
                            yCoordinateVal: adminData.getYCoordinate(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TicketsAndMoneyPieGraph(
                      moneyCollected: adminData.getTotalMoney(),
                      ticketsSold: adminData.getTotalTicketsSold(),
                    ),
                  ],
                ),
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: (_searchVal == "")
                      ? adminData.usersList.length + 1
                      : adminData.usersList
                              .where((element) =>
                                  element.name.contains(_searchVal))
                              .length +
                          1,
                  cacheExtent: 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return TextFormField(
                        cursorColor: kEbonyBlack,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.search,
                        onChanged: (val) {
                          setState(() {
                            _searchVal = val;
                          });
                        },
                        decoration: kSearchBoxDecorator,
                      );
                    }
                    if (_searchVal == "") {
                      return IndividualStatsTile(
                        name: adminData.usersList.elementAt(index - 1).name,
                        cash: adminData.usersList.elementAt(index - 1).cash,
                        onlineMoney: adminData.usersList
                            .elementAt(index - 1)
                            .onlineMoney,
                      );
                    } else {
                      return IndividualStatsTile(
                        name: adminData.usersList
                            .where(
                                (element) => element.name.contains(_searchVal))
                            .elementAt(index - 1)
                            .name,
                        cash: adminData.usersList
                            .where(
                                (element) => element.name.contains(_searchVal))
                            .elementAt(index - 1)
                            .cash,
                        onlineMoney: adminData.usersList
                            .where(
                                (element) => element.name.contains(_searchVal))
                            .elementAt(index - 1)
                            .onlineMoney,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      error: (_, __) => Center(
        child: Lottie.asset('assets/lottie/error.json'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
