import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InventoryChartScreen extends StatelessWidget {
  InventoryChartScreen({Key? key}) : super(key: key);

  final List<_InventoryData> data = [
    _InventoryData(DateTime(2025, 10, 1), 2000, 3000, 200000),
    _InventoryData(DateTime(2025, 10, 2), 2000, 1000, 201000),
    _InventoryData(DateTime(2025, 10, 3), 1200, 2211, 199989),
    _InventoryData(DateTime(2025, 10, 4), 1500, 2400, 199089),
    _InventoryData(DateTime(2025, 10, 5), 2500, 1000, 200589),
    _InventoryData(DateTime(2025, 10, 6), 1000, 1000, 200589),
    _InventoryData(DateTime(2025, 10, 7), 2000, 1000, 201589),
    _InventoryData(DateTime(2025, 10, 8), 2000, 1000, 202589),
    _InventoryData(DateTime(2025, 10, 9), 2300, 1500, 203389),
    _InventoryData(DateTime(2025, 10, 10), 1111, 2456, 202044),
    _InventoryData(DateTime(2025, 10, 11), 2222, 3111, 201155),
    _InventoryData(DateTime(2025, 10, 12), 1234, 1000, 201389),
    _InventoryData(DateTime(2025, 10, 13), 2000, 1000, 202389),
    _InventoryData(DateTime(2025, 10, 14), 2000, 3000, 201389),
    _InventoryData(DateTime(2025, 10, 15), 2134, 1000, 202523),
    _InventoryData(DateTime(2025, 10, 16), 1700, 1000, 203223),
    _InventoryData(DateTime(2025, 10, 17), 2222, 1000, 204445),
    _InventoryData(DateTime(2025, 10, 18), 1111, 3000, 202556),
    _InventoryData(DateTime(2025, 10, 19), 1632, 2151, 202037),
  ];

  final numberFormatter = NumberFormat('#,###'); // định dạng có dấu phẩy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biểu đồ Nhập - Xuất - Tồn kho')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SfCartesianChart(
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.days,
            dateFormat: DateFormat.Md(),
            majorGridLines: const MajorGridLines(
              width: 0,
            ), // tắt major grid lines trục X
            minorGridLines: const MinorGridLines(
              width: 0,
            ), // tắt minor grid lines trục X
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Nhập / Xuất'),
            numberFormat: NumberFormat.compact(),
            majorGridLines: const MajorGridLines(
              width: 0,
            ), // tắt major grid lines trục Y chính
            minorGridLines: const MinorGridLines(
              width: 0,
            ), // tắt minor grid lines trục Y chính
          ),
          axes: <ChartAxis>[
            NumericAxis(
              name: 'secondaryYAxis',
              opposedPosition: true,
              title: AxisTitle(text: 'Tồn kho'),
              numberFormat: NumberFormat.compact(),
              majorGridLines: const MajorGridLines(
                width: 0,
              ), // tắt major grid lines trục phụ
              minorGridLines: const MinorGridLines(
                width: 0,
              ), // tắt minor grid lines trục phụ
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_InventoryData, DateTime>>[
            ColumnSeries<_InventoryData, DateTime>(
              name: 'Nhập',
              dataSource: data,
              xValueMapper: (_InventoryData d, _) => d.date,
              yValueMapper: (_InventoryData d, _) => d.nhap,
              color: Colors.blue.withOpacity(.8),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.bottom,
                builder:
                    (
                      dynamic data,
                      dynamic point,
                      dynamic series,
                      int pointIndex,
                      int seriesIndex,
                    ) {
                      return RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          numberFormatter.format(data.nhap),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
              ),
            ),

            ColumnSeries<_InventoryData, DateTime>(
              name: 'Xuất',
              dataSource: data,
              xValueMapper: (_InventoryData d, _) => d.date,
              yValueMapper: (_InventoryData d, _) => d.xuat,
              color: Colors.indigo.withOpacity(.7),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.bottom,
                margin: const EdgeInsets.only(top: 8),
                builder:
                    (
                      dynamic data,
                      dynamic point,
                      dynamic series,
                      int pointIndex,
                      int seriesIndex,
                    ) {
                      return RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          numberFormatter.format(data.xuat), // Đã sửa ở đây
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
              ),
            ),

            LineSeries<_InventoryData, DateTime>(
              name: 'Tồn kho',
              dataSource: data,
              xValueMapper: (_InventoryData d, _) => d.date,
              yValueMapper: (_InventoryData d, _) => d.tonKho,
              yAxisName: 'secondaryYAxis',
              markerSettings: const MarkerSettings(isVisible: true),
              color: Colors.green,
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
                        numberFormatter.format(data.tonKho),
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

class _InventoryData {
  final DateTime date;
  final int nhap;
  final int xuat;
  final int tonKho;

  _InventoryData(this.date, this.nhap, this.xuat, this.tonKho);
}
