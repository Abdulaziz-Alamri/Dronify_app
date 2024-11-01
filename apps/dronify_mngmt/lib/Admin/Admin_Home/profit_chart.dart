import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfitChart extends StatelessWidget {
  final List<int> profits;
  const ProfitChart({super.key, required this.profits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Profits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Oct');
                          case 1:
                            return const Text('Nov');
                          case 2:
                            return const Text('Dec');
                          case 3:
                            return const Text('Jan');
                          case 4:
                            return const Text('Feb');
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    preventCurveOverShooting: true,
                    spots: profits.asMap().entries.map((entry) {
                      int index = entry.key;
                      double value = entry.value.toDouble();
                      return FlSpot(index.toDouble(), value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: const LinearGradient(colors: [
                        Color(0xff73DDFF),
                        Color(0xff072D6F),
                      ]),
                    ),
                  ),
                ],
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
