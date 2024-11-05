import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarchart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CustomBarchart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: data.isNotEmpty
            ? data.map((e) => e['order_count'] as double).reduce((a, b) => a > b ? a : b) + 5
            : 20, // تحديد الحد الأقصى
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  final serviceId = data[value.toInt()]['service_id'];
                  return Text(serviceId == 1
                      ? 'Building'
                      : serviceId == 2
                          ? 'Nano'
                          : 'Spot');
                }
                return const Text('');
              },
            ),
          ),
        ),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item['order_count'] as double,
                color: index == 0
                    ? const Color(0xff072D6F)
                    : index == 1
                        ? const Color(0xff0D56D5)
                        : const Color(0xff73DDFF),
                width: 15,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
