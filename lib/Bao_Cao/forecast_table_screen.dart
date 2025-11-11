import 'package:flutter/material.dart';

class ForecastTableScreen extends StatefulWidget {
  const ForecastTableScreen({Key? key, required int month}) : super(key: key);

  @override
  State<ForecastTableScreen> createState() => _ForecastTableScreenState();
}

class _ForecastTableScreenState extends State<ForecastTableScreen> {
  late ScrollController _hController;
  late ScrollController _vController;

  static const int weekCount = 4;

  late List<Map<String, dynamic>> bigData;

  @override
  void initState() {
    super.initState();
    _hController = ScrollController();
    _vController = ScrollController();

    // ==== DỮ LIỆU MẪU (ĐÃ CÓ KẾ HOẠCH ĐẶT HÀNG) ====
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
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
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
        'T1_ĐH': 200,
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
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
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
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
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
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
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
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
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
      },
      {
        'SKU': 'SKU-A13-100',
        'Tồn kho': 600,
        'Trung bình 6 tháng': 187,
        'Trung bình 3 tháng': 41,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 100,
        'T1_Nhận': 70,
        'T2_Nhận': '-',
        'T3_Nhận': '-',
        'T4_Nhận': 92,
        'T1_Xuất': 100,
        'T2_Xuất': 200,
        'T3_Xuất': '-',
        'T4_Xuất': 500,
        'T1_Kho': 570,
        'T2_Kho': 370,
        'T3_Kho': 370,
        'T4_Kho': -38,
        'T1_ĐH': '-',
        'T2_ĐH': 100,
        'T3_ĐH': '-',
        'T4_ĐH': '-',
      },
      {
        'SKU': 'SKU-A16-100',
        'Tồn kho': 1501,
        'Trung bình 6 tháng': 240,
        'Trung bình 3 tháng': 217,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 100,
        'T1_Nhận': '-',
        'T2_Nhận': 74,
        'T3_Nhận': '-',
        'T4_Nhận': 9,
        'T1_Xuất': '-',
        'T2_Xuất': 82,
        'T3_Xuất': 73,
        'T4_Xuất': '-',
        'T1_Kho': 1501,
        'T2_Kho': 1493,
        'T3_Kho': 1420,
        'T4_Kho': 1429,
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
      },
      {
        'SKU': 'SKU-A20-100',
        'Tồn kho': 161,
        'Trung bình 6 tháng': 18,
        'Trung bình 3 tháng': 72,
        'LT đặt hàng (ngày)': 15,
        'MOQ': 100,
        'T1_Nhận': '-',
        'T2_Nhận': '-',
        'T3_Nhận': '-',
        'T4_Nhận': '-',
        'T1_Xuất': '-',
        'T2_Xuất': 22,
        'T3_Xuất': '-',
        'T4_Xuất': '-',
        'T1_Kho': 161,
        'T2_Kho': 139,
        'T3_Kho': 139,
        'T4_Kho': 139,
        'T1_ĐH': '-',
        'T2_ĐH': '-',
        'T3_ĐH': '-',
        'T4_ĐH': '-',
      },
    ];
  }

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  // Màu nền
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
    if (col.contains('_ĐH')) {
      return val != '-' ? Colors.purple.shade100 : Colors.grey.shade50;
    }
    return Colors.white;
  }

  // Style chữ
  TextStyle _textStyle(String col, dynamic val) {
    if (col == 'SKU') {
      return const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      );
    }

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
      if (col.contains('_ĐH'))
        return const TextStyle(
          color: Colors.purple,
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
                _legend('Có đặt hàng', Colors.purple[400]!),
                _legend('Tồn < 100', Colors.red[400]!),
                _legend('Tồn 100-199', Colors.amber[600]!),
                _legend('Tồn ≥ 200', Colors.blue[600]!),
              ],
            ),
          ),

          // BẢNG DỮ LIỆU
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
                          0: const FixedColumnWidth(140),
                          for (int i = 1; i < 6 + (4 * 4); i++)
                            i: const FixedColumnWidth(120),
                        },
                        children: [
                          // HÀNG 1: Nhóm cột
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
                              _groupHeader(
                                'KẾ HOẠCH NHẬN',
                                Colors.green.shade700,
                              ),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              _groupHeader(
                                'KẾ HOẠCH XUẤT',
                                Colors.orange.shade700,
                              ),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              _groupHeader(
                                'TỒN KHO DỰ BÁO',
                                Colors.blue.shade700,
                              ),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              _groupHeader(
                                'KẾ HOẠCH ĐẶT HÀNG',
                                Colors.purple.shade700,
                              ),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                            ],
                          ),

                          // HÀNG 2: Tuần
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
                                _cell(row['Tồn kho'].toString(), ''),
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
                                for (int w = 1; w <= 4; w++)
                                  _cell(row['T${w}_ĐH'], 'T${w}_ĐH'),
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
