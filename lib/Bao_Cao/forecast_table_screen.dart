import 'package:flutter/material.dart';

class ForecastTableScreen extends StatefulWidget {
  ForecastTableScreen({Key? key}) : super(key: key);

  @override
  State<ForecastTableScreen> createState() => _ForecastTableScreenState();
}

class _ForecastTableScreenState extends State<ForecastTableScreen> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  static List<Map<String, dynamic>> data = [
    {
      'SKU': 'SKU-A3-100',
      'Tồn kho': 161,
      'Trung bình 6 tháng': 323,
      'Trung bình 3 tháng': 452,
      'LT đặt hàng (ngày)': 15,
      'MOQ': 200,
      'Tuần 1 Nhận': '-',
      'Tuần 2 Nhận': '-',
      'Tuần 3 Nhận': '-',
      'Tuần 4 Nhận': 80,
      'Tuần 5 Nhận': '-',
      'Tuần 6 Nhận': 51,
      'Tuần 7 Nhận': '-',
      'Tuần 8 Nhận': 39,
      'Tuần 1 Xuất': '-',
      'Tuần 2 Xuất': '-',
      'Tuần 3 Xuất': '-',
      'Tuần 4 Xuất': 75,
      'Tuần 5 Xuất': 86,
      'Tuần 6 Xuất': '-',
      'Tuần 7 Xuất': '-',
      'Tuần 8 Xuất': '-',
      'Tuần 1 Kho': 161,
      'Tuần 2 Kho': 161,
      'Tuần 3 Kho': 161,
      'Tuần 4 Kho': 166,
      'Tuần 5 Kho': 80,
      'Tuần 6 Kho': 131,
      'Tuần 7 Kho': 131,
      'Tuần 8 Kho': 170,
    },
  ];

  // Tạo nhiều bản sao với thay đổi SKU và một số giá trị
  final List<Map<String, dynamic>> bigData = List.generate(50, (index) {
    final base = data[index % data.length];

    // Clone map để không thay đổi gốc
    final Map<String, dynamic> newItem = Map<String, dynamic>.from(base);

    // Sửa SKU cho khác nhau
    newItem['SKU'] = base['SKU'] + '-${index + 1}';

    // Thay đổi 'Tồn kho' + tăng dần cho demo
    if (newItem['Tồn kho'] is int) {
      newItem['Tồn kho'] = (newItem['Tồn kho'] as int) + index * 5;
    }

    // Bạn có thể thêm chỉnh sửa các trường khác nếu muốn

    return newItem;
  });

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  Color _getCellColor(String columnName, dynamic value) {
    if (columnName.contains('Nhận')) {
      return value != '-' ? Colors.green[50]! : Colors.grey[50]!;
    } else if (columnName.contains('Xuất')) {
      return value != '-' ? Colors.orange[50]! : Colors.grey[50]!;
    } else if (columnName.contains('Kho')) {
      if (value < 100) return Colors.red[50]!;
      if (value < 200) return Colors.yellow[50]!;
      return Colors.blue[50]!;
    }
    return Colors.white;
  }

  TextStyle _getCellTextStyle(String columnName, dynamic value) {
    if (columnName.contains('SKU')) {
      return const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    }
    if (columnName.contains('Kho') && value != '-') {
      int val = int.tryParse(value.toString()) ?? 0;
      if (val < 100)
        return TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold);
      if (val < 200)
        return TextStyle(
          color: Colors.orange[700],
          fontWeight: FontWeight.bold,
        );
      return TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold);
    }
    return const TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    final columns = bigData.isNotEmpty
        ? bigData.first.keys.toList()
        : <String>[];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.analytics, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'Bảng dự báo kế hoạch',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Tổng SKU: ${data.length}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Legend
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _buildLegendItem('Nhập kho', Colors.green[50]!),
                SizedBox(width: 20),
                _buildLegendItem('Xuất kho', Colors.orange[50]!),
                SizedBox(width: 20),
                _buildLegendItem('Kho <100', Colors.red[50]!),
                SizedBox(width: 20),
                _buildLegendItem('Kho 100-200', Colors.yellow[50]!),
                SizedBox(width: 20),
                _buildLegendItem('Kho >200', Colors.blue[50]!),
              ],
            ),
          ),
          // Table
          Expanded(
            child: Container(
              color: Colors.white,
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(scrollbars: true),
                child: Scrollbar(
                  controller: _horizontalController,
                  child: Scrollbar(
                    controller: _verticalController,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: _verticalController,
                        child: SizedBox(
                          width: (columns.length * 100.0).clamp(
                            0,
                            double.infinity,
                          ),
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            columnWidths: {
                              for (int i = 0; i < columns.length; i++)
                                i: FixedColumnWidth(100),
                            },
                            children: [
                              // Header row
                              TableRow(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue[800]!,
                                      Colors.blue[600]!,
                                    ],
                                  ),
                                ),
                                children: columns.map((col) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: Text(
                                        col,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Data rows
                              ...bigData.map((row) {
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  children: columns.map((col) {
                                    final value = row[col];
                                    return Container(
                                      color: _getCellColor(col, value),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Center(
                                        child: Text(
                                          value.toString(),
                                          style: _getCellTextStyle(col, value),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
