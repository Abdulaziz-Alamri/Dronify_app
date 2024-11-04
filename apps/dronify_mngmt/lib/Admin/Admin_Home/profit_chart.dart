import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfitChart extends StatelessWidget {
  const ProfitChart({super.key});

  Future<List<Map<String, dynamic>>> fetchDailyProfits() async {
    final response =
        await Supabase.instance.client.rpc('fetch_daily_profits').select();

    if (response.isNotEmpty) {
      return response.map((e) {
        return {
          "day": e["day"],
          "total_profit": (e["total_profit"] as num).toDouble(),
        };
      }).toList();
    } else {
      throw Exception('Error fetching daily profits');
    }
  }

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
            'Daily Profits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDailyProfits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(child: Image.asset('assets/drone.gif'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final profits = snapshot.data ?? [];
                  return LineChart(
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
                              final dayIndex = value.toInt();
                              if (dayIndex >= 0 && dayIndex < profits.length) {
                                final day = profits[dayIndex]["day"];
                                return Text(
                                  day
                                      .toString()
                                      .substring(5), // عرض اليوم والشهر فقط
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
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
                            double value = entry.value["total_profit"];
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
