import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';
import 'package:intouch/constants.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Future<Map<String, dynamic>> information;

  @override
  void initState() {
    super.initState();
    information = fetchInformation();
  }

  Future<Map<String, dynamic>> fetchInformation() async {
    final response = await http.get(Constants.baseURL + 'covid19');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Covid19 information!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(
      context,
    ).size;

    return Scaffold(
      body: Container(
        child: Center(
          child: new ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            children: [
              header(),
              FutureBuilder<Map<String, dynamic>>(
                future: information,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          'Alert Level',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _media.width / 18,
                          ),
                        ),
                        LimitedBox(
                          maxHeight: _media.width / 2.25,
                          child: SingleChildScrollView(
                            child: alertLevel(
                              snapshot.data["level"],
                            ),
                            physics: NeverScrollableScrollPhysics(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cases(
                              "Cases",
                              snapshot.data["cases"].toString(),
                              Colors.deepOrange,
                            ),
                            cases(
                              "Cases In Hospital",
                              snapshot.data["cases_in_hospital"].toString(),
                              Colors.deepOrangeAccent,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cases(
                              "Confirmed Cases",
                              snapshot.data["confirmed_cases"].toString(),
                              Colors.orange,
                            ),
                            cases(
                              "Probable Cases",
                              snapshot.data["probable_cases"].toString(),
                              Colors.orangeAccent,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cases(
                              "Recoveries",
                              snapshot.data["recovered"].toString(),
                              Colors.lightGreen,
                            ),
                            cases(
                              "Deaths",
                              snapshot.data["deaths"].toString(),
                              Colors.redAccent,
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _media.width / 24,
                      ),
                    );
                  }

                  return CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Constants.secondaryColor
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    final _media = MediaQuery.of(
      context,
    ).size;

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: Icon(
              Icons.search,
              size: min(
                _media.width / 3,
                _media.height / 3,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Constants.name + ' COVID-19 TRACKER',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              fontSize: _media.width / 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget cases(String title, String data, Color color) {
    final _media = MediaQuery.of(
      context,
    ).size;

    return Expanded(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: _media.width / 24,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              data,
              style: TextStyle(
                color: color,
                fontSize: _media.width / 12,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget alertLevel(int _alert) {
    final _media = MediaQuery.of(
      context,
    ).size;

    Color gaugeColor;

    switch (_alert) {
      case 0:
        gaugeColor = Colors.lightGreen;
        break;
      case 1:
        gaugeColor = Colors.lime;
        break;
      case 2:
        gaugeColor = Colors.yellow;
        break;
      case 3:
        gaugeColor = Colors.orange;
        break;
      case 4:
        gaugeColor = Colors.redAccent;
        break;
      default:
        gaugeColor = Colors.blue;
        break;
    }

    return Column(
      children: <Widget>[
        Container(
          height: _media.width / 1.75,
          child: Stack(
            children: [
              charts.PieChart(
                [
                  charts.Series<GaugeSegment, String>(
                    id: 'Segments',
                    domainFn: (GaugeSegment segment, _) => segment.segment,
                    measureFn: (GaugeSegment segment, _) => segment.value,
                    colorFn: (GaugeSegment segment, _) => segment.color,
                    labelAccessorFn: (GaugeSegment segment, _) =>
                        segment.segment == 'Main' ? '${segment.value}' : null,
                    data: [
                      GaugeSegment('Main', 1, gaugeColor),
                    ],
                  )
                ],
                defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: (_media.width / 15).round(),
                  startAngle: 11 / 12 * pi,
                  arcLength: 14 / 12 * pi,
                ),
              ),
              Center(
                child: Text(
                  _alert.toString(),
                  style: TextStyle(
                    fontSize: _media.width / 12,
                    color: gaugeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GaugeSegment {
  final String segment;
  final double value;
  final charts.Color color;

  GaugeSegment(
    this.segment,
    this.value,
    Color color,
  ) : this.color = charts.Color(
          r: color.red,
          g: color.green,
          b: color.blue,
          a: color.alpha,
        );
}
