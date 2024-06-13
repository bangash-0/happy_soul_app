import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';

class PatientReport extends StatefulWidget {
  static const String id = 'patient_report';

  const PatientReport({super.key,});


  @override
  State<PatientReport> createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {

  // get data from navigator


  @override
  Widget build(BuildContext context) {

    var items = ModalRoute.of(context)?.settings.arguments;
    var data = items;

    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Patient Report'),
        gradient: const LinearGradient(
          colors: <Color>[kPrimaryColor, kSecondaryColor],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[kPrimaryColor, kSecondaryColor],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.8, // Making it square
                  color: Colors.grey, // Background color

                  // Padding for the chart
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Feeling Scale', textAlign: TextAlign.left,),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: ((data as List<dynamic>).reversed.toList()).asMap()
                                    .entries
                                    .take(8) // Limit to 7 data points
                                    .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                                    .toList(),
                                isCurved: true,
                                color: Colors.white, // Foreground color
                                barWidth: 4,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            minX: 0,
                            maxX: 30,
                            minY: 0,
                            maxY: 100,
                            titlesData: const FlTitlesData(
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),


                            ),
                            gridData: const FlGridData(show: true),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      const Text('Timeline', textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100,),
            ],
          ),
        ),

      ),
    );
  }
}