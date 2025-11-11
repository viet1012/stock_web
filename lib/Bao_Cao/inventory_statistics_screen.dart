import 'package:flutter/material.dart';

class InventoryStatisticsScreen extends StatefulWidget {
  const InventoryStatisticsScreen({Key? key, required int month})
    : super(key: key);

  @override
  State<InventoryStatisticsScreen> createState() =>
      _InventoryStatisticsScreenState();
}

class _InventoryStatisticsScreenState extends State<InventoryStatisticsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _filteredData;

  // Dữ liệu mẫu
  final List<Map<String, dynamic>> _inventoryData = [
    {
      'STT': 1,
      'Mã BTP': 'BTP001',
      'Tên sản phẩm': 'Vỏ máy A',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 120,
      'Nhập trong kỳ': 50,
      'Xuất trong kỳ': 70,
      'Tồn cuối kỳ': 100,
      'Vị trí kệ': 'Kệ A1-01',
    },
    {
      'STT': 2,
      'Mã BTP': 'BTP002',
      'Tên sản phẩm': 'Khung thép B',
      'ĐVT': 'Bộ',
      'Tồn đầu kỳ': 80,
      'Nhập trong kỳ': 20,
      'Xuất trong kỳ': 30,
      'Tồn cuối kỳ': 70,
      'Vị trí kệ': 'Kệ B2-03',
    },
    {
      'STT': 3,
      'Mã BTP': 'BTP003',
      'Tên sản phẩm': 'Chi tiết CNC C',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 200,
      'Nhập trong kỳ': 100,
      'Xuất trong kỳ': 150,
      'Tồn cuối kỳ': 150,
      'Vị trí kệ': 'Kệ C3-02',
    },
    {
      'STT': 4,
      'Mã BTP': 'BTP003',
      'Tên sản phẩm': 'Chi tiết CNC C',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 200,
      'Nhập trong kỳ': 100,
      'Xuất trong kỳ': 150,
      'Tồn cuối kỳ': 50,
      'Vị trí kệ': 'Kệ C3-03',
    },
    {
      'STT': 5,
      'Mã BTP': 'BTP003',
      'Tên sản phẩm': 'Chi tiết CNC C',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 200,
      'Nhập trong kỳ': 100,
      'Xuất trong kỳ': 150,
      'Tồn cuối kỳ': 100,
      'Vị trí kệ': 'Kệ C3-04',
    },
    {
      'STT': 6,
      'Mã BTP': 'BTP004',
      'Tên sản phẩm': 'Mặt bích D',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 60,
      'Nhập trong kỳ': 40,
      'Xuất trong kỳ': 30,
      'Tồn cuối kỳ': 70,
      'Vị trí kệ': 'Kệ D1-05',
    },
    {
      'STT': 7,
      'Mã BTP': 'BTP005',
      'Tên sản phẩm': 'Trục E',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 50,
      'Nhập trong kỳ': 0,
      'Xuất trong kỳ': 10,
      'Tồn cuối kỳ': 40,
      'Vị trí kệ': 'Kệ E4-01',
    },
    {
      'STT': 8,
      'Mã BTP': 'BTP006',
      'Tên sản phẩm': 'Module F',
      'ĐVT': 'Bộ',
      'Tồn đầu kỳ': 30,
      'Nhập trong kỳ': 20,
      'Xuất trong kỳ': 15,
      'Tồn cuối kỳ': 35,
      'Vị trí kệ': 'Kệ F2-04',
    },
    {
      'STT': 9,
      'Mã BTP': 'BTP007',
      'Tên sản phẩm': 'Tấm chắn G',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 90,
      'Nhập trong kỳ': 30,
      'Xuất trong kỳ': 20,
      'Tồn cuối kỳ': 100,
      'Vị trí kệ': 'Kệ G1-02',
    },
    {
      'STT': 10,
      'Mã BTP': 'BTP008',
      'Tên sản phẩm': 'Cụm lắp H',
      'ĐVT': 'Bộ',
      'Tồn đầu kỳ': 70,
      'Nhập trong kỳ': 10,
      'Xuất trong kỳ': 25,
      'Tồn cuối kỳ': 55,
      'Vị trí kệ': 'Kệ H3-01',
    },
    {
      'STT': 11,
      'Mã BTP': 'BTP009',
      'Tên sản phẩm': 'Thanh nhôm J',
      'ĐVT': 'Mét',
      'Tồn đầu kỳ': 300,
      'Nhập trong kỳ': 120,
      'Xuất trong kỳ': 80,
      'Tồn cuối kỳ': 340,
      'Vị trí kệ': 'Kệ J4-02',
    },
    {
      'STT': 12,
      'Mã BTP': 'BTP010',
      'Tên sản phẩm': 'Vòng kẹp K',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 110,
      'Nhập trong kỳ': 40,
      'Xuất trong kỳ': 50,
      'Tồn cuối kỳ': 100,
      'Vị trí kệ': 'Kệ K2-05',
    },
    {
      'STT': 13,
      'Mã BTP': 'BTP011',
      'Tên sản phẩm': 'Máng dẫn L',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 45,
      'Nhập trong kỳ': 25,
      'Xuất trong kỳ': 15,
      'Tồn cuối kỳ': 55,
      'Vị trí kệ': 'Kệ L1-06',
    },
    {
      'STT': 14,
      'Mã BTP': 'BTP012',
      'Tên sản phẩm': 'Chốt định vị M',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 500,
      'Nhập trong kỳ': 200,
      'Xuất trong kỳ': 250,
      'Tồn cuối kỳ': 450,
      'Vị trí kệ': 'Kệ M3-04',
    },
    {
      'STT': 15,
      'Mã BTP': 'BTP013',
      'Tên sản phẩm': 'Đế gá N',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 35,
      'Nhập trong kỳ': 10,
      'Xuất trong kỳ': 5,
      'Tồn cuối kỳ': 40,
      'Vị trí kệ': 'Kệ N2-01',
    },
    {
      'STT': 16,
      'Mã BTP': 'BTP014',
      'Tên sản phẩm': 'Khớp nối P',
      'ĐVT': 'Bộ',
      'Tồn đầu kỳ': 150,
      'Nhập trong kỳ': 50,
      'Xuất trong kỳ': 70,
      'Tồn cuối kỳ': 130,
      'Vị trí kệ': 'Kệ P4-03',
    },
    {
      'STT': 17,
      'Mã BTP': 'BTP015',
      'Tên sản phẩm': 'Vòng bi Q',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 600,
      'Nhập trong kỳ': 200,
      'Xuất trong kỳ': 300,
      'Tồn cuối kỳ': 500,
      'Vị trí kệ': 'Kệ Q1-02',
    },
    {
      'STT': 18,
      'Mã BTP': 'BTP016',
      'Tên sản phẩm': 'Tấm laser R',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 95,
      'Nhập trong kỳ': 30,
      'Xuất trong kỳ': 20,
      'Tồn cuối kỳ': 105,
      'Vị trí kệ': 'Kệ R5-01',
    },
    {
      'STT': 19,
      'Mã BTP': 'BTP017',
      'Tên sản phẩm': 'Nắp bảo vệ S',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 80,
      'Nhập trong kỳ': 40,
      'Xuất trong kỳ': 35,
      'Tồn cuối kỳ': 85,
      'Vị trí kệ': 'Kệ S1-03',
    },
    {
      'STT': 20,
      'Mã BTP': 'BTP018',
      'Tên sản phẩm': 'Thanh ray T',
      'ĐVT': 'Mét',
      'Tồn đầu kỳ': 180,
      'Nhập trong kỳ': 60,
      'Xuất trong kỳ': 90,
      'Tồn cuối kỳ': 150,
      'Vị trí kệ': 'Kệ T2-02',
    },
    {
      'STT': 21,
      'Mã BTP': 'BTP019',
      'Tên sản phẩm': 'Mô-đun U',
      'ĐVT': 'Bộ',
      'Tồn đầu kỳ': 25,
      'Nhập trong kỳ': 10,
      'Xuất trong kỳ': 5,
      'Tồn cuối kỳ': 30,
      'Vị trí kệ': 'Kệ U3-03',
    },
    {
      'STT': 22,
      'Mã BTP': 'BTP020',
      'Tên sản phẩm': 'Giá đỡ V',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 130,
      'Nhập trong kỳ': 20,
      'Xuất trong kỳ': 40,
      'Tồn cuối kỳ': 110,
      'Vị trí kệ': 'Kệ V4-01',
    },
  ];

  final List<String> _columns = [
    'STT',
    'Mã BTP',
    'Tên sản phẩm',
    'ĐVT',
    'Tồn đầu kỳ',
    'Nhập trong kỳ',
    'Xuất trong kỳ',
    'Tồn cuối kỳ',
    'Vị trí kệ',
  ];

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_inventoryData);
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _inventoryData.where((item) {
        return item['Mã BTP'].toString().toLowerCase().contains(query) ||
            item['Tên sản phẩm'].toString().toLowerCase().contains(query) ||
            item['Vị trí kệ'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  int _calculateTotal(String key) {
    return _filteredData.fold(0, (sum, item) => sum + (item[key] as int));
  }

  @override
  Widget build(BuildContext context) {
    final totalBegin = _calculateTotal('Tồn đầu kỳ');
    final totalIn = _calculateTotal('Nhập trong kỳ');
    final totalOut = _calculateTotal('Xuất trong kỳ');
    final totalEnd = _calculateTotal('Tồn cuối kỳ');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'THỐNG KÊ TỒN KHO VẬT TƯ',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Color(0xFF1E40AF)),
            onPressed: () {
              // In báo cáo
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đang xuất báo cáo PDF...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // === SEARCH & SUMMARY ===
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        'Tìm kiếm theo Mã BTP, Tên sản phẩm, Vị trí kệ...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Summary cards
                Row(
                  children: [
                    _buildSummaryCard('Tồn đầu kỳ', totalBegin, Colors.blue),
                    _buildSummaryCard('Nhập trong kỳ', totalIn, Colors.green),
                    _buildSummaryCard('Xuất trong kỳ', totalOut, Colors.orange),
                    _buildSummaryCard('Tồn cuối kỳ', totalEnd, Colors.purple),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // === DATA TABLE ===
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 56,
                        dataRowHeight: 52,
                        columnSpacing: 16,
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFF1E40AF),
                        ),
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        dataTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        columns: _columns
                            .map(
                              (col) => DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    col,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: _getAlignment(col),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        rows: _filteredData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.blue.shade50;
                              }
                              return index % 2 == 0
                                  ? Colors.grey.shade50
                                  : Colors.white;
                            }),
                            cells: [
                              DataCell(
                                _buildCell(
                                  item['STT'].toString(),
                                  align: TextAlign.center,
                                ),
                              ),
                              DataCell(_buildCell(item['Mã BTP'], bold: true)),
                              DataCell(_buildCell(item['Tên sản phẩm'])),
                              DataCell(
                                _buildCell(
                                  item['ĐVT'],
                                  align: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                _buildCell(
                                  item['Tồn đầu kỳ'].toString(),
                                  align: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                _buildCell(
                                  item['Nhập trong kỳ'].toString(),
                                  align: TextAlign.center,
                                  color: Colors.green,
                                ),
                              ),
                              DataCell(
                                _buildCell(
                                  item['Xuất trong kỳ'].toString(),
                                  align: TextAlign.center,
                                  color: Colors.orange,
                                ),
                              ),
                              DataCell(
                                _buildCell(
                                  item['Tồn cuối kỳ'].toString(),
                                  align: TextAlign.center,
                                  bold: true,
                                ),
                              ),
                              DataCell(
                                _buildCell(
                                  item['Vị trí kệ'],
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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

  TextAlign _getAlignment(String col) {
    return [
          'STT',
          'ĐVT',
          'Tồn đầu kỳ',
          'Nhập trong kỳ',
          'Xuất trong kỳ',
          'Tồn cuối kỳ',
        ].contains(col)
        ? TextAlign.center
        : TextAlign.left;
  }

  Widget _buildCell(
    String text, {
    TextAlign align = TextAlign.left,
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black87,
          fontSize: 16,
        ),
        textAlign: align,
      ),
    );
  }

  Widget _buildSummaryCard(String label, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
