import 'package:flutter/material.dart';

class ForecastTableScreen extends StatefulWidget {
  const ForecastTableScreen({Key? key, required int month}) : super(key: key);

  @override
  State<ForecastTableScreen> createState() => _ForecastTableScreenState();
}

class _ForecastTableScreenState extends State<ForecastTableScreen> {
  late ScrollController _hController;
  late ScrollController _vController;

  // Chỉ còn 4 tuần thôi nha
  static const int weekCount = 4;

  late List<Map<String, dynamic>> bigData;

  @override
  void initState() {
    super.initState();
    _hController = ScrollController();
    _vController = ScrollController();

    //   bigData = List.generate(80, (i) {
    //     final item = <String, dynamic>{
    //       'SKU': 'SKU-A${1000 + i}',
    //       'Tồn kho': 50 + (i * 7) % 300,
    //       'Trung bình 6 tháng': 200 + (i * 5) % 400,
    //       'Trung bình 3 tháng': 220 + (i * 3) % 350,
    //       'LT đặt hàng (ngày)': [7, 10, 14, 15, 21][i % 5],
    //       'MOQ': [100, 200, 300, 500][i % 4],
    //     };
    //
    //     for (int w = 1; w <= weekCount; w++) {
    //       item['T${w}_Nhận'] = (i % 5 == 0) ? 100 + w * 20 : '-';
    //       item['T${w}_Xuất'] = (i % 4 == 0) ? 80 + w * 15 : '-';
    //       item['T${w}_Kho'] = item['Tồn kho'] + (w * 25) - (i % 50);
    //     }
    //     return item;
    //   });

    // === DỮ LIỆU THẬT ===
    bigData = [
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
        'T1_Xuất': '-',
        'T2_Xuất': '-',
        'T3_Xuất': '-',
        'T4_Xuất': 75,
        'T1_Kho': 161,
        'T2_Kho': 161,
        'T3_Kho': 161,
        'T4_Kho': 166,
      },
      {
        'SKU': 'SKU-A4-100',
        'Tồn kho': 500,
        'Trung bình 6 tháng': 81,
        'Trung bình 3 tháng': 437,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 200,
        'T1_Nhận': 59,
        'T2_Nhận': 5,
        'T3_Nhận': 19,
        'T4_Nhận': '-',
        'T1_Xuất': 500,
        'T2_Xuất': '-',
        'T3_Xuất': 200,
        'T4_Xuất': 56,
        'T1_Kho': 59,
        'T2_Kho': 64,
        'T3_Kho': -117,
        'T4_Kho': -173,
      },
      {
        'SKU': 'SKU-A5-100',
        'Tồn kho': 600,
        'Trung bình 6 tháng': 494,
        'Trung bình 3 tháng': 343,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 200,
        'T1_Nhận': '-',
        'T2_Nhận': '-',
        'T3_Nhận': '-',
        'T4_Nhận': '-',
        'T1_Xuất': 58,
        'T2_Xuất': 46,
        'T3_Xuất': 40,
        'T4_Xuất': '-',
        'T1_Kho': 542,
        'T2_Kho': 496,
        'T3_Kho': 456,
        'T4_Kho': 456,
      },
      {
        'SKU': 'SKU-A6-100',
        'Tồn kho': 664,
        'Trung bình 6 tháng': 113,
        'Trung bình 3 tháng': 341,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 200,
        'T1_Nhận': '-',
        'T2_Nhận': 59,
        'T3_Nhận': '-',
        'T4_Nhận': 97,
        'T1_Xuất': '-',
        'T2_Xuất': '-',
        'T3_Xuất': '-',
        'T4_Xuất': 43,
        'T1_Kho': 664,
        'T2_Kho': 723,
        'T3_Kho': 723,
        'T4_Kho': 777,
      },
      {
        'SKU': 'SKU-A8-100',
        'Tồn kho': 1622,
        'Trung bình 6 tháng': 307,
        'Trung bình 3 tháng': 189,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 100,
        'T1_Nhận': 95,
        'T2_Nhận': 46,
        'T3_Nhận': 78,
        'T4_Nhận': '-',
        'T1_Xuất': '-',
        'T2_Xuất': 19,
        'T3_Xuất': '-',
        'T4_Xuất': '-',
        'T1_Kho': 1717,
        'T2_Kho': 1744,
        'T3_Kho': 1822,
        'T4_Kho': 1822,
      },
      {
        'SKU': 'SKU-A10-100',
        'Tồn kho': 1181,
        'Trung bình 6 tháng': 430,
        'Trung bình 3 tháng': 3,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 100,
        'T1_Nhận': 45,
        'T2_Nhận': 72,
        'T3_Nhận': 84,
        'T4_Nhận': 6,
        'T1_Xuất': 25,
        'T2_Xuất': 20,
        'T3_Xuất': '-',
        'T4_Xuất': 42,
        'T1_Kho': 1201,
        'T2_Kho': 1253,
        'T3_Kho': 1337,
        'T4_Kho': 1301,
      },
      // 👉 bạn copy tương tự cho toàn bộ dữ liệu còn lại
    ];
  }

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  Color _bgColor(String col, dynamic val) {
    if (col.contains('_Nhận')) {
      return val != '-' ? Colors.green.shade100 : Colors.grey.shade50;
    }
    if (col.contains('_Xuất')) {
      return val != '-' ? Colors.orange.shade100 : Colors.grey.shade50;
    }
    if (col.contains('_Kho')) {
      final v = int.tryParse(val.toString()) ?? 0;
      if (v < 100) return Colors.red.shade100;
      if (v < 200) return Colors.amber.shade100;
      return Colors.blue.shade100;
    }
    return Colors.white;
  }

  TextStyle _textStyle(String col, dynamic val) {
    if (col == 'SKU')
      return const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      );

    if (col.contains('_Kho')) {
      final v = int.tryParse(val.toString()) ?? 0;
      if (v < 100)
        return const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
      if (v < 200)
        return const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        );
      return const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
    }

    if (val != '-') {
      if (col.contains('_Nhận'))
        return const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w600,
        );
      if (col.contains('_Xuất'))
        return const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        );
    }

    return const TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            const Text(
              'BẢNG DỰ BÁO KẾ HOẠCH - 4 TUẦN',
              style: TextStyle(
                color: Color(0xFF1E40AF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Chip(
              backgroundColor: Colors.blue[50],
              label: Text(
                'Tổng SKU: ${bigData.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // LEGEND SIÊU ĐẸP
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Wrap(
              spacing: 40,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _legend('Có nhập kho', Colors.green[400]!),
                _legend('Có xuất kho', Colors.orange[400]!),
                _legend('Tồn < 100', Colors.red[400]!),
                _legend('Tồn 100-199', Colors.amber[600]!),
                _legend('Tồn ≥ 200', Colors.blue[600]!),
              ],
            ),
          ),

          // BẢNG CHÍNH - ĐẸP NHƯ ERP THẬT
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Scrollbar(
                  controller: _hController,
                  thumbVisibility: true,
                  thickness: 10,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _hController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: _vController,
                      child: Table(
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          width: 1.2,
                        ),
                        columnWidths: {
                          // Cột cố định
                          0: const FixedColumnWidth(140), // SKU
                          1: const FixedColumnWidth(100), // Tồn kho
                          2: const FixedColumnWidth(120),
                          3: const FixedColumnWidth(120),
                          4: const FixedColumnWidth(130),
                          5: const FixedColumnWidth(90), // MOQ
                          // 12 cột tuần (4 tuần x 3 nhóm)
                          for (int i = 0; i < 12; i++)
                            (i + 6): const FixedColumnWidth(130),
                        },
                        children: [
                          // HEADER NHÓM - MERGE ĐẸP LUNG LINH
                          // HEADER NHÓM - ĐÃ SỬA ĐỂ SPAN ĐÚNG 4 CỘT MỖI NHÓM
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E40AF),
                            ),
                            children: [
                              _fixedHeader('SKU'),
                              _fixedHeader('Tồn kho'),
                              _fixedHeader('TB 6 tháng'),
                              _fixedHeader('TB 3 tháng'),
                              _fixedHeader('LT (ngày)'),
                              _fixedHeader('MOQ'),

                              // Mỗi nhóm chiếm đúng 4 cột → dùng TableCell + colspan thủ công
                              TableCell(
                                child: _groupHeader(
                                  'KẾ HOẠCH NHẬN',
                                  Colors.green.shade700,
                                ),
                              ),
                              // 3 ô trống để span 4 cột
                              const TableCell(child: SizedBox()),
                              const TableCell(child: SizedBox()),
                              const TableCell(child: SizedBox()),

                              TableCell(
                                child: _groupHeader(
                                  'KẾ HOẠCH XUẤT',
                                  Colors.orange.shade700,
                                ),
                              ),
                              const TableCell(child: SizedBox()),
                              const TableCell(child: SizedBox()),
                              const TableCell(child: SizedBox()),

                              TableCell(
                                child: _groupHeader(
                                  'TỒN KHO DỰ BÁO',
                                  Colors.blue.shade700,
                                ),
                              ),
                              const TableCell(child: SizedBox()),
                              const TableCell(child: SizedBox()),
                              const TableCell(child: SizedBox()),
                            ],
                          ),

                          // HEADER TUẦN
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color(0xFF2563EB),
                            ),
                            children: [
                              ...List.generate(
                                6,
                                (_) => const SizedBox(height: 50),
                              ),
                              ...List.generate(
                                4,
                                (i) => _weekHeader('T${i + 1}'),
                              ),
                              ...List.generate(
                                4,
                                (i) => _weekHeader('T${i + 1}'),
                              ),
                              ...List.generate(
                                4,
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
                                _cell(row['Trung bình 6 tháng'].toString(), ''),
                                _cell(row['Trung bình 3 tháng'].toString(), ''),
                                _cell(row['LT đặt hàng (ngày)'].toString(), ''),
                                _cell(row['MOQ'].toString(), ''),
                                for (int w = 1; w <= 4; w++)
                                  _cell(row['T${w}_Nhận'], 'T${w}_Nhận'),
                                for (int w = 1; w <= 4; w++)
                                  _cell(row['T${w}_Xuất'], 'T${w}_Xuất'),
                                for (int w = 1; w <= 4; w++)
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

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Header cột cố định
  Widget _fixedHeader(String text) => Container(
    height: 60,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    ),
  );

  // Header nhóm - merge đẹp
  Widget _groupHeader(String text, Color? color) => Container(
    height: 60,
    color: color,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ),
  );

  // Header tuần
  Widget _weekHeader(String text) => Container(
    height: 50,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ),
  );

  // Ô dữ liệu
  Widget _cell(dynamic value, String col) => Container(
    height: 56,
    alignment: Alignment.center,
    color: _bgColor(col, value),
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      value.toString(),
      style: _textStyle(col, value),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    ),
  );

  // Legend item
  Widget _legend(String label, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ],
  );
}
