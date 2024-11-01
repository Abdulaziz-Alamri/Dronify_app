import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmployeesBarchart extends StatelessWidget {
  const EmployeesBarchart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 200,
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
            'Employees\' Rating',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BarChart(
                BarChartData(borderData: FlBorderData(show: false), barGroups: [
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                      toY: 5.5,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff072D6F),
                          Color(0xff0D56D5),
                        ],
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter,
                      )),
                ],
              ),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                    toY: 2.5,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff072D6F),
                        Color(0xff0D56D5),
                      ],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    )),
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                    toY: 3.5,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff072D6F),
                        Color(0xff0D56D5),
                      ],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    )),
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                    toY: 8.5,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff072D6F),
                        Color(0xff0D56D5),
                      ],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    )),
              ]),
            ])),
          ),
        ],
      ),
    );
  }
}
