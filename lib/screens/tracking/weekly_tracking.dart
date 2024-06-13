import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:happy_soul/screens/psychiatrist_data/psychiatrists_page.dart';


class WeeklyReport extends StatefulWidget {
  static const String id = 'weekly_report';

  const WeeklyReport({super.key,});


  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {

  // get data from navigator

  @override
  Widget build(BuildContext context) {

    var items = ModalRoute.of(context)?.settings.arguments;
    var data = items;

    String? selectedValue;
    var x_axis = 30;

    final List<String> options = [
      '7 days',
      '2 weeks',
      '30 days',
      '2 months',
    ];

    int getSelectedDays(String? value) {
      switch (value) {
        case '7 days':
          return 7;
        case '2 weeks':
          return 14;
        case '30 days':
          return 30;
        case '2 months':
          return 60;
        default:
          return 7;
      }
    }

    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Weekly Report'),
        gradient: const LinearGradient(
          colors: <Color>[kPrimaryColor, kSecondaryColor],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedValue = value;
                x_axis = getSelectedDays(selectedValue);
              });
            },
            itemBuilder: (BuildContext context) {
              return options.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
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
                child: display_Graph( data, x_axis),
              ),

              const SizedBox(height: 100,),
              Visibility(
                child: ElevatedButton(
                  onPressed: () async {
                    String? userEmail =
                        FirebaseAuth.instance.currentUser!.email;
                    String? country;

                    //   if user exists
                    if (userEmail != null) {
                      // get the user document

                      final snapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: userEmail)
                          .get();
                      for (var doc in snapshot.docs) {
                        // update the location field
                        country = doc['country'];
                      }
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => psychiatrist_details(country: country),
                      ),
                    );
                  },

                  child: const Text('Mind Masters', style: TextStyle(color: Color(0xFF008000)),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget display_Graph(var data, var xAxis) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8, // Making it square
      color: Colors.grey, // Background color

      // Padding for the chart
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Feeling Scale', textAlign: TextAlign.left,),
          const SizedBox(height: 15,),
          Expanded(
            flex: 1,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: ((data as List<dynamic>).reversed.toList()).asMap()
                        .entries
                        .take(30) // Limit to 7 data points
                        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                        .toList(),
                    isCurved: false,
                    color: Colors.white, // Foreground color
                    barWidth: 4,
                    belowBarData: BarAreaData(show: true),
                  ),
                ],
                minX: 0,
                maxX: xAxis.toDouble(),
                minY: 0,
                maxY: 100,

                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles : AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
                gridData: const FlGridData(show: true),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          const Text('Timeline', textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}