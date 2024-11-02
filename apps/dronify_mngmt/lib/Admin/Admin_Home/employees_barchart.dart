import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeesBarchart extends StatelessWidget {
  const EmployeesBarchart({super.key});

  Future<List<Map<String, dynamic>>> fetchEmployeeRatings() async {
    final response =
        await Supabase.instance.client.rpc('fetch_employee_ratings').select();

    if (response is List) {
      return response.map((e) {
        return {
          "employee_id": e["employee_id"],
          "rating": (e["rating"] as num).toDouble(),
        };
      }).toList();
    } else {
      throw Exception('Error fetching employee ratings');
    }
  }

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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchEmployeeRatings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final ratings = snapshot.data ?? [];
                  final barGroups = ratings.asMap().entries.map((entry) {
                    int index = entry.key;
                    double rating = entry.value["rating"];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: rating,
                          gradient: const LinearGradient(
                            colors: [Color(0xff072D6F), Color(0xff0D56D5)],
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                          ),
                        ),
                      ],
                    );
                  }).toList();

                  return BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < ratings.length) {
                                return Text(
                                  ratings[value.toInt()]["employee_id"]
                                      .toString()
                                      .substring(0, 4),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
