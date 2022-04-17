import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/widgets/text/legend_text.dart';

class TicketsAndMoneyPieGraph extends StatefulWidget {
  final int moneyCollected;
  final int ticketsSold;
  const TicketsAndMoneyPieGraph(
      {Key? key, required this.moneyCollected, required this.ticketsSold})
      : super(key: key);

  @override
  _TicketsAndMoneyPieGraphState createState() =>
      _TicketsAndMoneyPieGraphState();
}

class _TicketsAndMoneyPieGraphState extends State<TicketsAndMoneyPieGraph> {
  final int _moneyGoal = 160000;
  final int _ticketsGoal = 800;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 3,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tickets & Money",
            style: TextStyle(
              color: kRichBlack,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: size.width / 2.5,
                      width: size.width / 2.5,
                      child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: widget.moneyCollected / _moneyGoal,
                          ),
                          curve: Curves.easeOut,
                          duration: const Duration(seconds: 2),
                          builder: (context, value, _) {
                            return CircularProgressIndicator(
                              value: value,
                              color: kSchoolBusYellow,
                              strokeWidth: 8,
                              backgroundColor: kAlabasterWhite,
                            );
                          }),
                    ),
                    SizedBox(
                      height: size.width / 4,
                      width: size.width / 4,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: widget.ticketsSold / _ticketsGoal,
                        ),
                        curve: Curves.easeOut,
                        duration: const Duration(seconds: 2),
                        builder: (context, value, _) {
                          return CircularProgressIndicator(
                            value: value,
                            color: kCeruleanBlue,
                            strokeWidth: 8,
                            backgroundColor: kAlabasterWhite,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LegendText(
                      text: "Tickets Sold",
                      value: widget.ticketsSold,
                    ),
                    LegendText(
                      text: "Money Collected",
                      value: widget.moneyCollected,
                      isBlue: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
