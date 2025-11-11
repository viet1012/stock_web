import 'package:flutter/material.dart';

class ForecastTableScreen extends StatefulWidget {
  const ForecastTableScreen({Key? key}) : super(key: key);

  @override
  State<ForecastTableScreen> createState() => _ForecastTableScreenState();
}

class _ForecastTableScreenState extends State<ForecastTableScreen> {
  late ScrollController _hController;
  late ScrollController _vController;

  static const List<Map<String, dynamic>> baseData = [
    {
      'SKU': 'SKU-A3-100',
      'Tồn kho': 161,
      'Trung bình 6 tháng': 323,
      'Trung bình 3 tháng': 452,
      'LT đặt hàng (ngày)': 15,
      'MOQ': 200,
      'T1_Nhận': '-',
      'T2_Nhận': '-',
      'T3_Nhận': '-',
      'T4_Nhận': 80,
      'T5_Nhận': '-',
      'T6_Nhận': 51,
      'T7_Nhận': '-',
      'T8_Nhận': 39,
      'T1_Xuất': '-',
      'T2_Xuất': '-',
      'T3_Xuất': '-',
      'T4_Xuất': 75,
      'T5_Xuất': 86,
      'T6_Xuất': '-',
      'T7_Xuất': '-',
      'T8_Xuất': '-',
      'T1_Kho': 161,
      'T2_Kho': 161,
      'T3_Kho': 161,
      'T4_Kho': 166,
      'T5_Kho': 80,
      'T6_Kho': 131,
      'T7_Kho': 131,
      'T8_Kho': 170,
    },
  ];

  late List<Map<String, dynamic>> bigData;

  @override
  void initState() {
    super.initState();
    _hController = ScrollController();
    _vController = ScrollController();

    bigData = List.generate(50, (i) {
      final item = Map<String, dynamic>.from(baseData[0]);
      item['SKU'] = 'SKU-A3-10${i + 1}';
      item['Tồn kho'] = 161 + i * 3;

      for (int w = 1; w <= 8; w++) {
        if (i % 3 == 0) {
          item['T${w}_Nhận'] = w % 2 == 0 ? 50 + i : '-';
          item['T${w}_Xuất'] = w % 3 == 0 ? 60 + i : '-';
        } else {
          item['T${w}_Nhận'] = '-';
          item['T${w}_Xuất'] = '-';
        }
        item['T${w}_Kho'] = item['Tồn kho'] + (w * 10) - i;
      }
      return item;
    });
  }

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  // === MÀU NỀN Ô ===
  Color _bgColor(String col, dynamic val) {
    if (col.contains('_Nhận'))
      return val != '-' ? Colors.green[50]! : Colors.grey[50]!;
    if (col.contains('_Xuất'))
      return val != '-' ? Colors.orange[50]! : Colors.grey[50]!;
    if (col.contains('_Kho')) {
      final v = int.tryParse(val.toString()) ?? 0;
      if (v < 100) return Colors.red[50]!;
      if (v < 200) return Colors.yellow[50]!;
      return Colors.blue[50]!;
    }
    return Colors.white;
  }

  // === STYLE CHỮ ===
  TextStyle _textStyle(String col, dynamic val) {
    if (col == 'SKU') {
      return const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    }
    if (col.contains('_Kho')) {
      final v = int.tryParse(val.toString()) ?? 0;
      if (v < 100) {
        return TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold);
      }
      if (v < 200) {
        return TextStyle(
          color: Colors.orange[800],
          fontWeight: FontWeight.bold,
        );
      }
      return TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold);
    }
    return const TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    final fixedCols = [
      'SKU',
      'Tồn kho',
      'Trung bình\n6 tháng',
      'Trung bình\n3 tháng',
      'LT đặt hàng (ngày)',
      'MOQ',
    ];
    const List<double> colWidths = [130, 95, 115, 115, 110, 85]; // ĐẸP NHẤT

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Text(
              'BẢNG DỰ BÁO KẾ HOẠCH',
              style: TextStyle(
                color: Color(0xFF1E40AF),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                'Tổng SKU: ${bigData.length}',
                style: const TextStyle(
                  fontSize: 15,
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
          // === LEGEND SIÊU ĐẸP ===
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Wrap(
              spacing: 32,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _legend('Có nhập kho', Colors.green[100]!),
                _legend('Có xuất kho', Colors.orange[100]!),
                _legend('Tồn < 100', Colors.red[100]!),
                _legend('Tồn 100–199', Colors.yellow[100]!),
                _legend('Tồn ≥ 200', Colors.blue[100]!),
              ],
            ),
          ),

          // === BẢNG CHÍNH ===
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Scrollbar(
                  controller: _hController,
                  thumbVisibility: true,
                  thickness: 8,
                  child: Scrollbar(
                    controller: _vController,
                    thumbVisibility: true,
                    thickness: 8,
                    child: SingleChildScrollView(
                      controller: _hController,
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: _vController,
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: {
                            for (int i = 0; i < fixedCols.length; i++)
                              i: FixedColumnWidth(colWidths[i]),
                            for (int i = 0; i < 24; i++)
                              (i + 6): const FixedColumnWidth(
                                140,
                              ), // 8x3 = 24 tuần
                          },
                          children: [
                            // HEADER NHÓM
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E40AF),
                              ),
                              children: List.generate(30, (i) {
                                if (i < 6) return _header(fixedCols[i]);
                                if (i == 6) {
                                  return _groupHeader(
                                    'KẾ HOẠCH NHẬN',
                                    Colors.green[700]!,
                                  );
                                }
                                if (i == 14) {
                                  return _groupHeader(
                                    'KẾ HOẠCH XUẤT',
                                    Colors.orange[700]!,
                                  );
                                }
                                if (i == 22) {
                                  return _groupHeader(
                                    'TỒN KHO DỰ BÁO',
                                    Colors.blue[700]!,
                                  );
                                }
                                return const SizedBox();
                              }),
                            ),

                            // HEADER TUẦN
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                              ),
                              children: [
                                ...List.generate(6, (_) => const SizedBox()),
                                ...List.generate(
                                  8,
                                  (i) => _weekHeader('T${i + 1}'),
                                ),
                                ...List.generate(
                                  8,
                                  (i) => _weekHeader('T${i + 1}'),
                                ),
                                ...List.generate(
                                  8,
                                  (i) => _weekHeader('T${i + 1}'),
                                ),
                              ],
                            ),

                            // DỮ LIỆU
                            ...bigData.map(
                              (row) => TableRow(
                                children: [
                                  _cell(row['SKU'], 'SKU'),
                                  _cell(row['Tồn kho'].toString(), 'Tồn kho'),
                                  _cell(
                                    row['Trung bình 6 tháng'].toString(),
                                    '',
                                  ),
                                  _cell(
                                    row['Trung bình 3 tháng'].toString(),
                                    '',
                                  ),
                                  _cell(
                                    row['LT đặt hàng (ngày)'].toString(),
                                    '',
                                  ),
                                  _cell(row['MOQ'].toString(), ''),
                                  for (int w = 1; w <= 8; w++)
                                    _cell(row['T${w}_Nhận'], 'T${w}_Nhận'),
                                  for (int w = 1; w <= 8; w++)
                                    _cell(row['T${w}_Xuất'], 'T${w}_Xuất'),
                                  for (int w = 1; w <= 8; w++)
                                    _cell(row['T${w}_Kho'], 'T${w}_Kho'),
                                ],
                              ),
                            ),
                          ],
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

  Widget _header(String text) => Container(
    height: 56,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget _groupHeader(String text, Color bg) => Container(
    height: 56,
    color: bg,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );

  Widget _weekHeader(String text) => Container(
    height: 44,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );

  Widget _cell(dynamic value, String col) => Container(
    height: 54,
    alignment: Alignment.center,
    color: _bgColor(col, value),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      value.toString(),
      style: _textStyle(col, value),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    ),
  );

  Widget _legend(String label, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade400),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
