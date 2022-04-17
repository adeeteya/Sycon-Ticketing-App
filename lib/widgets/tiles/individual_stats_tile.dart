import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/widgets/text/legend_text.dart';

class IndividualStatsTile extends StatefulWidget {
  final String name;
  final int cash;
  final int onlineMoney;
  const IndividualStatsTile(
      {Key? key,
      required this.name,
      required this.cash,
      required this.onlineMoney})
      : super(key: key);

  @override
  _IndividualStatsTileState createState() => _IndividualStatsTileState();
}

class _IndividualStatsTileState extends State<IndividualStatsTile> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2.5,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              color: kRichBlack,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 0,
                      sectionsSpace: 0,
                      startDegreeOffset: 120,
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      sections: [
                        PieChartSectionData(
                            value: widget.cash.toDouble(),
                            color: kCeruleanBlue,
                            radius: (_touchedIndex == 0)
                                ? size.width / 4.2
                                : size.width / 4.5,
                            showTitle: (_touchedIndex == 0) ? true : false,
                            title: "Cash\n${widget.cash}",
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            )),
                        PieChartSectionData(
                          value: widget.onlineMoney.toDouble(),
                          color: kSchoolBusYellow,
                          radius: (_touchedIndex == 1)
                              ? size.width / 4.2
                              : size.width / 4.5,
                          showTitle: (_touchedIndex == 1) ? true : false,
                          title: "Online Money\n${widget.onlineMoney}",
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 1500),
                    swapAnimationCurve: Curves.easeOut,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LegendText(
                      text: "Cash",
                      value: widget.cash,
                    ),
                    LegendText(
                      text: "Online Money",
                      value: widget.onlineMoney,
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
