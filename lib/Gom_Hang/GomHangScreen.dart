import 'package:flutter/material.dart';

import '../Xuat_Kho/Xuất Kho Bước 1/Đưa lên kệ chờ/confirm_shelf_dialog.dart';
import '../widgets/custom_button.dart';

class GomHangScreen extends StatefulWidget {
  const GomHangScreen({super.key});

  @override
  State<GomHangScreen> createState() => _GomHangScreenState();
}

class _GomHangScreenState extends State<GomHangScreen> {
  final TextEditingController _tenHangController = TextEditingController();
  final TextEditingController _boxIdConfirmController = TextEditingController();

  // Danh sách cần gom
  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filteredItems = [];
  Set<int> _selectedIndices = {};

  // Danh sách đã chọn
  List<Map<String, dynamic>> _selectedItems = [];
  List<Map<String, dynamic>> orderWaitList = [];

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _filteredItems = List.from(_allItems);
  }

  void _initializeMockData() {
    final products = [
      {'ProductID': 'HN000009', 'ProductName': 'Vòng bi Q'},
      {'ProductID': 'HN000010', 'ProductName': 'Bánh răng A'},
      {'ProductID': 'HN000011', 'ProductName': 'Trục thép B'},
      {'ProductID': 'HN000012', 'ProductName': 'Bulong M6'},
    ];

    _allItems = List.generate(80, (i) {
      final product = products[i % products.length]; // chia đều 4 loại
      final boxCount = (i % 3) + 1; // mỗi sản phẩm có 1–3 box

      return {
        'TT': i + 1,
        'ShelfId': 'PR-${['K', 'J', 'L'][i % 3]}${i + 1}-${(i % 5) + 1}',
        'ProductID': product['ProductID'],
        'ProductName': product['ProductName'],
        'Qty': (i % 5) + 1,
        'BoxList': '[VT]_B_${boxCount}_Box [VT]', // thay đổi box
        'checked': false,
      };
    });
  }

  void _search() {
    final tenHang = _tenHangController.text.toLowerCase();

    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchTenHang =
            tenHang.isEmpty ||
            item['ProductName'].toString().toLowerCase().contains(tenHang);
        return matchTenHang;
      }).toList();
      _selectedIndices.clear();
    });
  }

  void _toggleSelection(int index) {
    final selectedItem = _filteredItems[index];

    setState(() {
      // Nếu chưa chọn gì, cho phép chọn dòng đầu tiên
      if (_selectedIndices.isEmpty) {
        _selectedIndices.add(index);
      } else {
        // Lấy item đầu tiên trong danh sách đã chọn để so sánh
        final firstSelected = _filteredItems[_selectedIndices.first];

        final sameProduct =
            selectedItem['ProductID'] == firstSelected['ProductID'] &&
            selectedItem['ProductName'] == firstSelected['ProductName'];

        if (!sameProduct) {
          // Nếu khác ProductID hoặc ProductName → báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Chỉ được chọn các hàng có cùng Tên hàng và ProductID!',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Nếu cùng loại → toggle bình thường
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
        } else {
          _selectedIndices.add(index);
        }
      }

      _updateSelectedItems();
    });
  }

  void _updateSelectedItems() {
    _selectedItems = _selectedIndices
        .map((idx) => Map<String, dynamic>.from(_filteredItems[idx]))
        .toList();
  }

  void _confirmGomHang() {
    if (_boxIdConfirmController.text.isEmpty || _selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn hàng và nhập BoxID xác nhận!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Reset sau khi gom
    setState(() {
      _selectedIndices.clear();
      _selectedItems.clear();
      _boxIdConfirmController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // === SEARCH BAR ===
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // canh trái
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSearchField(
                          'Tên hàng',
                          _tenHangController,
                          Icons.inventory_2,
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        'Tìm kiếm',
                        Icons.search,
                        Colors.blue,
                        _search,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // === MAIN CONTENT ===
          Expanded(
            child: Row(
              children: [
                // === LEFT TABLE: Cần gom ===
                Expanded(flex: 3, child: _buildLeftTable()),
                const SizedBox(width: 8),

                // === RIGHT PANEL: Đã chọn + Xác nhận ===
                Expanded(flex: 2, child: _buildRightPanel()),
              ],
            ),
          ),

          // === BOTTOM BAR ===
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Items: ${_selectedItems.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
                Row(
                  children: [
                    _buildActionButton(
                      'Xác nhận gom hàng',
                      Icons.check_circle,
                      Colors.green,
                      _confirmGomHang,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Hủy gom hàng',
                      Icons.cancel,
                      Colors.red,
                      () {
                        setState(() {
                          _selectedIndices.clear();
                          _updateSelectedItems();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      onPressed: _openConfirmShelfDialog,
                      label: 'Xác nhận kệ chờ',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openConfirmShelfDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmShelfDialog(
        orderWaitList: orderWaitList,
        onUpdate: (updatedList) {
          setState(() {
            orderWaitList = updatedList;
          });
        },
      ),
    );
  }

  Widget _buildLeftTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E40AF),
            child: const Text(
              'DANH SÁCH CẦN GOM HÀNG',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                headingRowHeight: 40,
                dataRowHeight: 48,
                columnSpacing: 32,
                headingRowColor: MaterialStateColor.resolveWith(
                  (_) => Colors.grey.shade200,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'TT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ShelfId',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ProductID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ProductName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Qty',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'BoxList',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Chọn',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: _filteredItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = _selectedIndices.contains(index);
                  return DataRow(
                    color: MaterialStateProperty.resolveWith((states) {
                      return isSelected
                          ? Colors.cyan.shade50
                          : (index % 2 == 0
                                ? Colors.white
                                : Colors.grey.shade50);
                    }),
                    cells: [
                      DataCell(Text(item['TT'].toString())),
                      DataCell(
                        Text(
                          item['ShelfId'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      DataCell(Text(item['ProductID'])),
                      DataCell(
                        Text(
                          item['ProductName'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            item['Qty'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataCell(Text(item['BoxList'])),

                      DataCell(
                        Center(
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleSelection(index),
                            activeColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade600,
            child: const Text(
              'DANH SÁCH ĐÃ CHỌN - XÁC NHẬN GOM HÀNG',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConfirmRow(
                  '+ ProductID :',
                  _selectedItems.isNotEmpty
                      ? _selectedItems.first['ProductID']
                      : '',
                ),
                // _buildConfirmRow('+ TQty :', _selectedItems.fold(0, (sum, e) => sum + e['Qty']).toString()),
                _buildConfirmRow(
                  '+ BoxIDStock :',
                  _selectedItems.map((e) => e['BoxList']).join(', '),
                ),

                const SizedBox(height: 12),
                _buildConfirmRow(
                  '+ BoxIDConfirm :',
                  '',
                  controller: _boxIdConfirmController,
                  icon: Icons.qr_code_scanner,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _selectedItems.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa chọn hàng nào',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedItems.length,
                    itemBuilder: (ctx, i) {
                      final item = _selectedItems[i];
                      return ListTile(
                        dense: true,
                        title: Text(
                          item['ShelfId'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item['ProductName']} - Qty: ${item['Qty']}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            final globalIndex = _filteredItems.indexWhere(
                              (e) => e['ShelfId'] == item['ShelfId'],
                            );
                            if (globalIndex != -1)
                              _toggleSelection(globalIndex);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    String label,
    TextEditingController controller,
    IconData icon, {
    Function(String)? onSubmitted,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildConfirmRow(
    String label,
    String value, {
    TextEditingController? controller,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: controller != null
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: icon != null ? Icon(icon, size: 16) : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      isDense: true,
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
