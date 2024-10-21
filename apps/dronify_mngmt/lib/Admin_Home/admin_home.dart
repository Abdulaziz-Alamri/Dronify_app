import 'dart:math';

import 'package:dronify_mngmt/Admin_Home/custom_stat_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> profits = [0, 500, 1500, 1000, 4000];

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/appbar1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              centerTitle: true,
              title: Text(
                'Welcome Back Admin 👋',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            backgroundColor: Colors.transparent,
            pinned: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomStatCard(title: 'Users', value: '10K'),
                      CustomStatCard(title: 'Orders', value: '10K'),
                      CustomStatCard(title: 'Profits', value: '10K'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    height: 300,
                    width: 337,
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
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
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
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(colors: [
                                Color(0xff73DDFF),
                                Color(0xff072D6F),
                              ]),
                            ),
                          ),
                        ],
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    height: 160,
                    width: 337,
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
                    child: BarChart(BarChartData(barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 5.5),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 2.5),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 3.5),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 8.5),
                      ]),
                    ])),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    height: 160,
                    width: 337,
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
                    child: BarChart(BarChartData(barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 5.5),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 2.5),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 3.5),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 8.5),
                      ]),
                    ])),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
