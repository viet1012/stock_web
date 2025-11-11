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

  // Dữ liệu mẫu (giữ nguyên dữ liệu cũ)
  final List<Map<String, dynamic>> _inventoryData = [
    {
      'STT': 1,
      'Mã BTP': 'BTP001',
      'Tên sản phẩm': 'Ống nhựa PVC 20mm',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 50,
      'Nhập trong kỳ': 20,
      'Xuất trong kỳ': 15,
      'Tồn cuối kỳ': 55,
      'Vị trí kệ': 'Kệ A1',
    },
    {
      'STT': 2,
      'Mã BTP': 'BTP002',
      'Tên sản phẩm': 'Băng keo điện 5cm',
      'ĐVT': 'Cuộn',
      'Tồn đầu kỳ': 100,
      'Nhập trong kỳ': 50,
      'Xuất trong kỳ': 30,
      'Tồn cuối kỳ': 120,
      'Vị trí kệ': 'Kệ B3',
    },
    {
      'STT': 3,
      'Mã BTP': 'BTP003',
      'Tên sản phẩm': 'Vít nở 6x50',
      'ĐVT': 'Hộp',
      'Tồn đầu kỳ': 40,
      'Nhập trong kỳ': 10,
      'Xuất trong kỳ': 5,
      'Tồn cuối kỳ': 45,
      'Vị trí kệ': 'Kệ C2',
    },
    {
      'STT': 4,
      'Mã BTP': 'BTP004',
      'Tên sản phẩm': 'Dây điện 1.5mm2',
      'ĐVT': 'Cuộn',
      'Tồn đầu kỳ': 200,
      'Nhập trong kỳ': 100,
      'Xuất trong kỳ': 80,
      'Tồn cuối kỳ': 220,
      'Vị trí kệ': 'Kệ D4',
    },
    {
      'STT': 5,
      'Mã BTP': 'BTP005',
      'Tên sản phẩm': 'Ổ cắm đôi',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 60,
      'Nhập trong kỳ': 30,
      'Xuất trong kỳ': 20,
      'Tồn cuối kỳ': 70,
      'Vị trí kệ': 'Kệ A2',
    },
    {
      'STT': 6,
      'Mã BTP': 'BTP006',
      'Tên sản phẩm': 'Cầu chì 10A',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 150,
      'Nhập trong kỳ': 50,
      'Xuất trong kỳ': 70,
      'Tồn cuối kỳ': 130,
      'Vị trí kệ': 'Kệ B1',
    },
    {
      'STT': 7,
      'Mã BTP': 'BTP007',
      'Tên sản phẩm': 'Bóng đèn LED 9W',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 80,
      'Nhập trong kỳ': 40,
      'Xuất trong kỳ': 25,
      'Tồn cuối kỳ': 95,
      'Vị trí kệ': 'Kệ C3',
    },
    {
      'STT': 8,
      'Mã BTP': 'BTP008',
      'Tên sản phẩm': 'Dây cáp mạng Cat6',
      'ĐVT': 'Cuộn',
      'Tồn đầu kỳ': 120,
      'Nhập trong kỳ': 60,
      'Xuất trong kỳ': 50,
      'Tồn cuối kỳ': 130,
      'Vị trí kệ': 'Kệ D1',
    },
    {
      'STT': 9,
      'Mã BTP': 'BTP009',
      'Tên sản phẩm': 'Ổ khóa số 3 số',
      'ĐVT': 'Cái',
      'Tồn đầu kỳ': 70,
      'Nhập trong kỳ': 30,
      'Xuất trong kỳ': 20,
      'Tồn cuối kỳ': 80,
      'Vị trí kệ': 'Kệ A3',
    },
    {
      'STT': 10,
      'Mã BTP': 'BTP010',
      'Tên sản phẩm': 'Keo dán silicone 300ml',
      'ĐVT': 'Tuýp',
      'Tồn đầu kỳ': 90,
      'Nhập trong kỳ': 40,
      'Xuất trong kỳ': 35,
      'Tồn cuối kỳ': 95,
      'Vị trí kệ': 'Kệ B2',
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

  Future<void> _exportToExcel() async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Xuất Excel thành công')));
  }

  Future<void> _importFromExcel() async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Nhập Excel thành công')));
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.print, color: Color(0xFF1E40AF)),
                onPressed: () {
                  // In báo cáo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang xuất báo cáo PDF...')),
                  );
                },
              ),
              const SizedBox(width: 12),

              IconButton(
                icon: const Icon(Icons.file_upload, color: Color(0xFF1E40AF)),
                onPressed: _importFromExcel,
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.file_download, color: Color(0xFF1E40AF)),
                onPressed: _exportToExcel,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // === SEARCH & SUMMARY + IMPORT/EXPORT BUTTONS ===
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Tìm kiếm theo Mã BTP, Tên sản phẩm, Vị trí kệ...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
