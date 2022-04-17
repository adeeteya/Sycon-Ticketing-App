import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/providers.dart';
import 'package:sycon_ticketing_app/screens/account_stats.dart';
import 'package:sycon_ticketing_app/screens/admin_statistics.dart';
import 'package:sycon_ticketing_app/screens/leaderboard.dart';
import 'package:sycon_ticketing_app/screens/qr_scanner.dart';
import 'package:sycon_ticketing_app/screens/search_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedNavBarPosition = 0;
  late List<Widget> screens;
  late List<BottomNavigationBarItem> bottomNavBarItems;
  @override
  Widget build(BuildContext context) {
    final adminCheckRef = ref.watch(adminCheckProvider);
    return adminCheckRef.when(
      data: (isAdmin) {
        screens = [
          (isAdmin) ? const AdminStatistics() : const AccountStats(),
          const LeaderBoard(),
          SearchScreen(isAdmin: isAdmin),
          const QrScanner(),
        ];
        bottomNavBarItems = [
          BottomNavigationBarItem(
            label: isAdmin ? "AdminStatistics" : "AccountStatistics",
            icon: Icon(
              isAdmin ? Icons.supervisor_account : Icons.person,
            ),
          ),
          const BottomNavigationBarItem(
            label: "LeaderBoard",
            icon: Icon(
              Icons.emoji_events,
            ),
          ),
          const BottomNavigationBarItem(
              label: "Search", icon: Icon(Icons.search)),
          const BottomNavigationBarItem(
              label: "Scan", icon: Icon(Icons.qr_code_scanner)),
        ];
        return Scaffold(
          body: screens[_selectedNavBarPosition],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedNavBarPosition,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: kSchoolBusYellow,
            unselectedItemColor: Colors.grey,
            items: bottomNavBarItems,
            onTap: (pos) {
              if (_selectedNavBarPosition == pos) return;
              _selectedNavBarPosition = pos;
              setState(() {});
            },
          ),
        );
      },
      error: (_, __) => Scaffold(
        body: Center(
          child: Lottie.asset('assets/lottie/error.json'),
        ),
      ),
      loading: () => Scaffold(
        body: Center(
          child: Lottie.asset('assets/lottie/loading.json'),
        ),
      ),
    );
  }
}
