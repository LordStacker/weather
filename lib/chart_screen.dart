import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_source.dart';
import 'models/time_series.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<WeatherChartData>(
          future: context.read<DataSource>().getChartData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final variables = snapshot.data!.daily!;
            return charts.TimeSeriesChart(
              [
                for (final variable in variables)
                  charts.Series<TimeSeriesDatum, DateTime>(
                    id: '${variable.name} ${variable.unit}',
                    domainFn: (datum, _) => datum.domain,
                    measureFn: (datum, _) => datum.measure,
                    data: variable.values,
                  ),
              ],
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              behaviors: [charts.SeriesLegend()],
            );
          },
        ),
      ),
    );
  }
}
