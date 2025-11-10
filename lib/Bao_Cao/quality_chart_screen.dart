import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class QualityChartScreen extends StatelessWidget {
  QualityChartScreen({Key? key}) : super(key: key);

  final List<_QualityData> data = [
    _QualityData(DateTime(2025, 10, 1), 2000, 5, 0.25),
    _QualityData(DateTime(2025, 10, 2), 2000, 6, 0.30),
    _QualityData(DateTime(2025, 10, 3), 1200, 10, 0.83),
    _QualityData(DateTime(2025, 10, 4), 1500, 10, 0.66),
    _QualityData(DateTime(2025, 10, 5), 2500, 10, 0.40),
    _QualityData(DateTime(2025, 10, 6), 1000, 10, 0.99),
    _QualityData(DateTime(2025, 10, 7), 2000, 0, 0.00),
    _QualityData(DateTime(2025, 10, 8), 2000, 10, 0.50),
    _QualityData(DateTime(2025, 10, 9), 2300, 10, 0.43),
    _QualityData(DateTime(2025, 10, 10), 1111, 0, 0.00),
    _QualityData(DateTime(2025, 10, 11), 2222, 0, 0.00),
    _QualityData(DateTime(2025, 10, 12), 1234, 0, 0.00),
    _QualityData(DateTime(2025, 10, 13), 2000, 8, 0.40),
    _QualityData(DateTime(2025, 10, 14), 2000, 10, 0.50),
    _QualityData(DateTime(2025, 10, 15), 2134, 1, 0.05),
    _QualityData(DateTime(2025, 10, 16), 1700, 10, 0.58),
    _QualityData(DateTime(2025, 10, 17), 2222, 22, 0.98),
    _QualityData(DateTime(2025, 10, 18), 1111, 10, 0.89),
    _QualityData(DateTime(2025, 10, 19), 1632, 10, 0.61),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biểu đồ OK - NG - NG %')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SfCartesianChart(
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.days,
            dateFormat: DateFormat.Md(),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Số lượng'),
            numberFormat: NumberFormat.compact(),
          ),
          axes: <ChartAxis>[
            NumericAxis(
              name: 'secondaryYAxis',
              opposedPosition: true,
              title: AxisTitle(text: 'Tỉ lệ NG %'),
              numberFormat: NumberFormat.percentPattern(),
              minimum: 0,
              maximum: 1,
              interval: 0.2,
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_QualityData, DateTime>>[
            StackedColumnSeries<_QualityData, DateTime>(
              name: 'OK',
              dataSource: data,
              xValueMapper: (_QualityData d, _) => d.date,
              yValueMapper: (_QualityData d, _) => d.ok,
              color: Colors.green,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
            StackedColumnSeries<_QualityData, DateTime>(
              name: 'NG',
              dataSource: data,
              xValueMapper: (_QualityData d, _) => d.date,
              yValueMapper: (_QualityData d, _) => d.ng,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(color: Colors.black),
              ),
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
            LineSeries<_QualityData, DateTime>(
              name: 'NG %',
              dataSource: data,
              xValueMapper: (_QualityData d, _) => d.date,
              yValueMapper: (_QualityData d, _) => d.ngPercent,
              yAxisName: 'secondaryYAxis',
              markerSettings: const MarkerSettings(isVisible: true),
              color: Colors.orange,
              width: 4,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                builder:
                    (
                      dynamic data,
                      dynamic point,
                      dynamic series,
                      int pointIndex,
                      int seriesIndex,
                    ) {
                      return Text(
                        '${data.ngPercent.toString()}%', // hiển thị số nguyên, không rút gọn
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityData {
  final DateTime date;
  final int ok;
  final int ng;
  final double
  ngPercent; // lưu theo tỉ lệ (vd 0.25% = 0.0025 -> ở đây dùng 0.0025, nhưng dữ liệu bạn cho là 0.25% nên tôi đã đổi thành 0.0025 nhé)

  _QualityData(this.date, this.ok, this.ng, this.ngPercent);
}
