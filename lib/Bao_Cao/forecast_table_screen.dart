import 'package:flutter/material.dart';

class ForecastTableScreen extends StatefulWidget {
  const ForecastTableScreen({Key? key}) : super(key: key);

  @override
  State<ForecastTableScreen> createState() => _ForecastTableScreenState();
}

class _ForecastTableScreenState extends State<ForecastTableScreen> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  // Dữ liệu mẫu
  static List<Map<String, dynamic>> baseData = [
    {
      'SKU': 'SKU-A3-100',
      'Tồn kho': 161,
      'Trung bình 6 tháng': 323,
      'Trung bình 3 tháng': 452,
      'LT đặt hàng (ngày)': 15,
      'MOQ': 200,
      // Nhận
      'T1_Nhận': '-', 'T2_Nhận': '-', 'T3_Nhận': '-', 'T4_Nhận': 80,
      'T5_Nhận': '-', 'T6_Nhận': 51, 'T7_Nhận': '-', 'T8_Nhận': 39,
      // Xuất
      'T1_Xuất': '-', 'T2_Xuất': '-', 'T3_Xuất': '-', 'T4_Xuất': 75,
      'T5_Xuất': 86, 'T6_Xuất': '-', 'T7_Xuất': '-', 'T8_Xuất': '-',
      // Kho
      'T1_Kho': 161, 'T2_Kho': 161, 'T3_Kho': 161, 'T4_Kho': 166,
      'T5_Kho': 80, 'T6_Kho': 131, 'T7_Kho': 131, 'T8_Kho': 170,
    },
  ];

  late List<Map<String, dynamic>> bigData;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();

    // Tạo 50 dòng dữ liệu mẫu
    bigData = List.generate(50, (index) {
      final base = baseData[0];
      final Map<String, dynamic> item = Map.from(base);

      item['SKU'] = 'SKU-A3-10${index + 1}';
      item['Tồn kho'] = 161 + index * 3;

      // Tạo biến động ngẫu nhiên cho nhận/xuất
      for (int w = 1; w <= 8; w++) {
        if (index % 3 == 0) {
          item['T${w}_Nhận'] = w % 2 == 0 ? 50 + index : '-';
          item['T${w}_Xuất'] = w % 3 == 0 ? 60 + index : '-';
        } else {
          item['T${w}_Nhận'] = '-';
          item['T${w}_Xuất'] = '-';
        }
        item['T${w}_Kho'] = item['Tồn kho'] + (w * 10) - index;
      }

      return item;
    });
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  // === Sắp xếp cột theo thứ tự: Nhận → Xuất → Kho cho từng tuần ===
  List<String> _getOrderedColumns() {
    final baseCols = [
      'SKU',
      'Tồn kho',
      'Trung bình 6 tháng',
      'Trung bình 3 tháng',
      'LT đặt hàng (ngày)',
      'MOQ',
    ];
    final weekCols = <String>[];
    for (int w = 1; w <= 8; w++) {
      weekCols.add('T${w}_Nhận');
      weekCols.add('T${w}_Xuất');
      weekCols.add('T${w}_Kho');
    }
    return [...baseCols, ...weekCols];
  }

  Color _getCellColor(String columnName, dynamic value) {
    if (columnName.contains('_Nhận'))
      return value != '-' ? Colors.green[50]! : Colors.grey[50]!;
    if (columnName.contains('_Xuất'))
      return value != '-' ? Colors.orange[50]! : Colors.grey[50]!;
    if (columnName.contains('_Kho')) {
      final val = int.tryParse(value.toString()) ?? 0;
      if (val < 100) return Colors.red[50]!;
      if (val < 200) return Colors.yellow[50]!;
      return Colors.blue[50]!;
    }
    return Colors.white;
  }

  TextStyle _getCellTextStyle(String columnName, dynamic value) {
    if (columnName == 'SKU') {
      return const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      );
    }
    if (columnName.contains('_Kho')) {
      final val = int.tryParse(value.toString()) ?? 0;
      if (val < 100)
        return TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold);
      if (val < 200)
        return TextStyle(
          color: Colors.orange[700],
          fontWeight: FontWeight.bold,
        );
      return TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold);
    }
    return const TextStyle(fontSize: 13);
  }

  @override
  Widget build(BuildContext context) {
    final columns = _getOrderedColumns();
    final fixedColsCount = 6; // Số cột cố định bên trái

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.analytics, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'BẢNG DỰ BÁO KẾ HOẠCH',
              style: TextStyle(
                color: Color(0xFF1E40AF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Tổng SKU: ${bigData.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // === LEGEND ===
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Nhập kho', Colors.green[50]!),
                const SizedBox(width: 24),
                _buildLegendItem('Xuất kho', Colors.orange[50]!),
                const SizedBox(width: 24),
                _buildLegendItem('Kho <100', Colors.red[50]!),
                const SizedBox(width: 24),
                _buildLegendItem('Kho 100-200', Colors.yellow[50]!),
                const SizedBox(width: 24),
                _buildLegendItem('Kho >200', Colors.blue[50]!),
              ],
            ),
          ),

          // === TABLE ===
          Expanded(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Scrollbar(
                  controller: _horizontalController,
                  thumbVisibility: true,
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: _verticalController,
                        child: DataTable(
                          headingRowHeight: 56,
                          dataRowHeight: 52,
                          columnSpacing: 8,
                          headingRowColor: MaterialStateColor.resolveWith(
                            (_) => const Color(0xFF1E40AF),
                          ),
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                          columns: columns.map((col) {
                            final isFixed =
                                columns.indexOf(col) < fixedColsCount;
                            return DataColumn(
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  _formatColumnName(col),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                          rows: bigData.map((row) {
                            return DataRow(
                              cells: columns.map((col) {
                                final value = row[col] ?? '-';
                                final isFixed =
                                    columns.indexOf(col) < fixedColsCount;
                                return DataCell(
                                  Container(
                                    color: _getCellColor(col, value),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Center(
                                      child: Text(
                                        value.toString(),
                                        style: _getCellTextStyle(col, value),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
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

  String _formatColumnName(String col) {
    if (col.contains('_Nhận')) return 'T${col[1]} Nhận';
    if (col.contains('_Xuất')) return 'T${col[1]} Xuất';
    if (col.contains('_Kho')) return 'T${col[1]} Kho';
    return col;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
