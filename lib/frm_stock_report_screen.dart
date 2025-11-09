import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class StockReportChartsScreen extends StatefulWidget {
  const StockReportChartsScreen({super.key});

  @override
  State<StockReportChartsScreen> createState() =>
      _StockReportChartsScreenState();
}

class _StockReportChartsScreenState extends State<StockReportChartsScreen> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool showWeeklyNg = true;

  final List<Map<String, dynamic>> stockData = List.generate(180, (index) {
    final date = DateTime.now().subtract(Duration(days: index));
    final type = (index % 10 < 4)
        ? 'Nhập kho'
        : (index % 10 < 8)
        ? 'Xuất kho'
        : 'Kiểm kê';
    final qty = type == 'Kiểm kê'
        ? (1 + (index * 3) % 5)
        : (10 + (index * 7) % 50);
    final isNg = (type == 'Kiểm kê') ? (index % 4 == 0) : (index % 4 == 0);
    final warehouse = ['Kho A', 'Kho B', 'Kho C'][index % 3];
    final category = ['Điện tử', 'Thực phẩm', 'Văn phòng phẩm'][index % 3];

    return {
      'date': date,
      'type': type,
      'qty': qty,
      'isNg': isNg,
      'warehouse': warehouse,
      'category': category,
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterPanel(),
            const SizedBox(height: 24),
            _buildInboundChart(),
            const SizedBox(height: 24),
            _buildOutboundChart(),
            const SizedBox(height: 24),
            _buildNgChart(),
            const SizedBox(height: 32),
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bộ lọc',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Năm',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedYear,
                    items: List.generate(5, (i) {
                      int year = DateTime.now().year - i;
                      return DropdownMenuItem(
                        value: year,
                        child: Text('$year'),
                      );
                    }),
                    onChanged: (val) => setState(() => selectedYear = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Tháng',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedMonth,
                    items: List.generate(12, (i) {
                      int month = i + 1;
                      return DropdownMenuItem(
                        value: month,
                        child: Text('$month'),
                      );
                    }),
                    onChanged: (val) => setState(() => selectedMonth = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Kiểm kê:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Switch(
                  value: showWeeklyNg,
                  onChanged: (v) => setState(() => showWeeklyNg = v),
                  activeColor: Colors.blueGrey[600],
                ),
                Text(
                  showWeeklyNg ? 'Theo tuần' : 'Theo ngày',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInboundChart() {
    final data = _aggregateInboundByMonth(selectedYear);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập kho theo tháng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 220, child: _InboundBarChart(data: data)),
          ],
        ),
      ),
    );
  }

  Widget _buildOutboundChart() {
    final data = _dailyOutboundForMonth(selectedYear, selectedMonth);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xuất kho chi tiết ${selectedMonth.toString().padLeft(2, '0')}/$selectedYear',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 220, child: _OutboundLineChart(data)),
          ],
        ),
      ),
    );
  }

  Widget _buildNgChart() {
    final data = _ngCounts(selectedYear, selectedMonth, showWeeklyNg);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kiểm kê NG (${showWeeklyNg ? "Tuần" : "Tháng"} ${selectedMonth.toString().padLeft(2, '0')}/$selectedYear)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 220, child: _NgBarChart(data)),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        onPressed: _exportReport,
        icon: const Icon(Icons.file_download_outlined, size: 20),
        label: const Text(
          'Xuất Báo Cáo (Excel / PDF)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Map<int, int> _aggregateInboundByMonth(int year) {
    final filtered = stockData
        .where(
          (e) =>
              e['type'] == 'Nhập kho' && (e['date'] as DateTime).year == year,
        )
        .toList();
    Map<int, int> monthTotals = {};
    for (var e in filtered) {
      int month = (e['date'] as DateTime).month;
      monthTotals[month] = (monthTotals[month] ?? 0) + e['qty'] as int;
    }
    return monthTotals;
  }

  Map<int, int> _dailyOutboundForMonth(int year, int month) {
    final filtered = stockData
        .where(
          (e) =>
              e['type'] == 'Xuất kho' &&
              (e['date'] as DateTime).year == year &&
              (e['date'] as DateTime).month == month,
        )
        .toList();
    Map<int, int> dailyTotals = {};
    for (var e in filtered) {
      int day = (e['date'] as DateTime).day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + e['qty'] as int;
    }
    return dailyTotals;
  }

  Map<int, int> _ngCounts(int year, int month, bool weekly) {
    final filtered = stockData
        .where(
          (e) =>
              e['type'] == 'Kiểm kê' &&
              (e['date'] as DateTime).year == year &&
              (e['date'] as DateTime).month == month &&
              e['isNg'] == true,
        )
        .toList();
    Map<int, int> counts = {};
    for (var e in filtered) {
      DateTime date = e['date'] as DateTime;
      int key = weekly ? ((date.day - 1) ~/ 7 + 1) : date.day;
      counts[key] = (counts[key] ?? 0) + e['qty'] as int;
    }
    return counts;
  }

  Future<void> _exportReport() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      var excel = Excel.createExcel();
      var sheet = excel['Báo cáo'];

      sheet.appendRow([
        TextCellValue('Ngày'),
        TextCellValue('Loại'),
        TextCellValue('SL'),
        TextCellValue('NG'),
        TextCellValue('Kho'),
        TextCellValue('Danh mục'),
      ]);

      for (var e in stockData) {
        sheet.appendRow([
          TextCellValue(DateFormat('yyyy-MM-dd').format(e['date'] as DateTime)),
          TextCellValue(e['type']),
          IntCellValue(e['qty'] as int),
          BoolCellValue(e['isNg'] ?? false),
          TextCellValue(e['warehouse']),
          TextCellValue(e['category']),
        ]);
      }

      var bytes = excel.encode();
      final excelFile = File("${dir.path}/stock_report.xlsx");
      if (bytes != null) await excelFile.writeAsBytes(bytes);

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            children: [
              pw.Text(
                'BÁO CÁO KHO',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: ['Ngày', 'Loại', 'SL', 'NG', 'Kho', 'Danh mục'],
                data: stockData
                    .map(
                      (e) => [
                        DateFormat('yyyy-MM-dd').format(e['date'] as DateTime),
                        e['type'],
                        e['qty'].toString(),
                        e['isNg'].toString(),
                        e['warehouse'],
                        e['category'],
                      ],
                    )
                    .toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(4),
              ),
            ],
          ),
        ),
      );

      final pdfFile = File("${dir.path}/stock_report.pdf");
      await pdfFile.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueGrey[600],
          content: Text(
            'Xuất báo cáo thành công!\nExcel: ${excelFile.path}\nPDF: ${pdfFile.path}',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            'Lỗi khi xuất báo cáo: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}

class _InboundBarChart extends StatelessWidget {
  final Map<int, int> data;
  const _InboundBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = (data.values.isNotEmpty)
        ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
        : 10.0;
    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey[300], strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.toDouble(),
                    color: Colors.green[400],
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            )
            .toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) => Text(
                'Th ${value.toInt()}',
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(
                  'Tháng ${group.x}: ${rod.toY.toInt()}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                ),
          ),
        ),
      ),
    );
  }
}

class _OutboundLineChart extends StatelessWidget {
  final Map<int, int> data;
  const _OutboundLineChart(this.data);

  @override
  Widget build(BuildContext context) {
    final maxY = (data.values.fold<int>(0, (a, b) => a > b ? a : b) * 1.2)
        .toDouble();

    return LineChart(
      LineChartData(
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey[300], strokeWidth: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots:
                data.entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                    .toList()
                  ..sort((a, b) => a.x.compareTo(b.x)),
            isCurved: true,
            barWidth: 3,
            color: Colors.red[400],
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 5,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    'Ngày ${spot.x.toInt()}: ${spot.y.toInt()}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _NgBarChart extends StatelessWidget {
  final Map<int, int> data;
  const _NgBarChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final maxY = (data.values.fold<int>(0, (a, b) => a > b ? a : b) * 1.2)
        .toDouble();
    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey[300], strokeWidth: 1),
        ),
        barGroups: data.entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.toDouble(),
                    color: Colors.amber[600],
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            )
            .toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (v, meta) => Text(
                v.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(
                  '${rod.toY.toInt()}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                ),
          ),
        ),
      ),
    );
  }
}
