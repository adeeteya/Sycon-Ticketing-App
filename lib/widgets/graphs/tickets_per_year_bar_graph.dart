import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';

class TicketsPerYearBarGraph extends StatelessWidget {
  final List<int> ticketsData;
  final int yCoordinateVal;
  const TicketsPerYearBarGraph(
      {Key? key, required this.ticketsData, required this.yCoordinateVal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BarChart(
        BarChartData(
          maxY: yCoordinateVal.toDouble(),
          minY: 0,
          borderData: FlBorderData(
            show: true,
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.07),
              ),
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.07),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'Tickets',
                style: TextStyle(color: kDarkGrey),
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, titleMeta) {
                  return Text(
                    '${val.toInt()}',
                    style: const TextStyle(color: kDarkGrey),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                'Years',
                style: TextStyle(color: kDarkGrey),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, titleMeta) {
                  return Text(
                    '${val.toInt()}',
                    style: const TextStyle(color: kDarkGrey),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String yearString = "";
                switch (groupIndex) {
                  case 0:
                    yearString = "1st Year";
                    break;
                  case 1:
                    yearString = "2nd Year";
                    break;
                  case 2:
                    yearString = "3rd Year";
                    break;
                  case 3:
                    yearString = "4th Year";
                    break;
                }
                return BarTooltipItem(
                  yearString + '\n',
                  const TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: "${rod.toY.toInt()} tickets",
                      style: TextStyle(
                        color: rod.color,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          gridData: FlGridData(
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: Colors.black.withOpacity(0.07), strokeWidth: 1),
              drawVerticalLine: false),
          barGroups: [
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                    toY: ticketsData[0].toDouble(),
                    width: 30,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    color: kCeruleanBlue),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                    toY: ticketsData[1].toDouble(),
                    width: 30,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    color: kSchoolBusYellow),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                    toY: ticketsData[2].toDouble(),
                    width: 30,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    color: kCeruleanBlue),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: ticketsData[3].toDouble(),
                  width: 30,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  color: kSchoolBusYellow,
                ),
              ],
            ),
          ],
        ),
        swapAnimationDuration: const Duration(seconds: 1),
        swapAnimationCurve: Curves.easeOut,
      ),
    );
  }
}
