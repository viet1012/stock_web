import 'package:flutter/material.dart';

import '../Data/mock_inventory_data.dart';
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
  // List<String> _confirmedBoxIds = []; // 🔹 Danh sách các BoxIDConfirm đã quét
  Map<String, bool> _boxIdScanStatus =
      {}; // Key: BoxID, Value: đã quét đúng chưa
  // XÓA DÒNG NÀY:

  // THAY BẰNG 2 DÒNG SAU:
  Map<String, Color> _productColorMap = {}; // Key: ProductID → Color cố định
  final List<Color> _availableColors = [
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.purple.shade400,
    Colors.blue.shade400,
    Colors.teal.shade400,
    Colors.pink.shade400,
    Colors.red.shade400,
    Colors.indigo.shade400,
  ];
  int _nextColorIndex = 0; // Để cấp phát màu lần lượt
  // Danh sách đã chọn
  List<Map<String, dynamic>> _selectedItems = [];
  List<Map<String, dynamic>> orderWaitList = [];
  List<Map<String, dynamic>> _confirmedItems = [];

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    final mockData = MockInventoryData.initializeAll();
    orderWaitList = MockInventoryData.getOrderWaitList();
    // Lọc ra các item theo yêu cầu
    final shelfItems = mockData['shelfItems'] as List<Map<String, dynamic>>;
    _allItems = filterByProductAndUniqueBoxList(shelfItems);
    _sortItems(_allItems); // Sắp xếp danh sách gốc
    _filteredItems = List.from(_allItems);
  }

  List<Map<String, dynamic>> filterUniqueBoxList(
    List<Map<String, dynamic>> items,
  ) {
    final seenBoxLists = <String>{};
    final filtered = <Map<String, dynamic>>[];

    for (var item in items) {
      final boxList = item['BoxList'] as String;
      if (!seenBoxLists.contains(boxList)) {
        seenBoxLists.add(boxList);
        filtered.add(item);
      }
    }

    return filtered;
  }

  List<Map<String, dynamic>> filterByProductAndUniqueBoxList(
    List<Map<String, dynamic>> items,
  ) {
    // Map key: 'ProductID|ProductName' -> Set chứa BoxList đã gặp
    final Map<String, Set<String>> productBoxLists = {};
    final List<Map<String, dynamic>> result = [];

    for (var item in items) {
      final productKey = '${item['ProductID']}|${item['ProductName']}';
      final boxList = item['BoxList'] as String;

      if (!productBoxLists.containsKey(productKey)) {
        productBoxLists[productKey] = <String>{};
      }

      // Nếu boxList này chưa xuất hiện trong nhóm product đó
      if (!productBoxLists[productKey]!.contains(boxList)) {
        productBoxLists[productKey]!.add(boxList);
        result.add(item);
      }
      // Nếu đã có rồi thì bỏ qua để tránh trùng boxList cho cùng product
    }

    return result;
  }

  void _sortItems(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      int cmp = (a['ProductName'] as String).compareTo(
        b['ProductName'] as String,
      );
      if (cmp != 0) return cmp;
      return (a['Qty'] as int).compareTo(b['Qty'] as int);
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

      _sortItems(_filteredItems); // Sắp xếp danh sách sau khi filter
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

  void _onBoxScanned(String boxId) {
    final scanned = boxId.trim().toUpperCase();

    setState(() {
      if (_boxIdScanStatus.containsKey(scanned)) {
        if (!_boxIdScanStatus[scanned]!) {
          _boxIdScanStatus[scanned] = true;

          // Đếm số BoxID đã quét đúng
          final totalRequired = _boxIdScanStatus.length;
          final scannedCorrectly = _boxIdScanStatus.values
              .where((v) => v)
              .length;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đúng BoxID! Đã quét đúng $scannedCorrectly/$totalRequired',
              ),
              backgroundColor: Colors.green,
            ),
          );

          if (scannedCorrectly == totalRequired) {
            setState(() {
              _selectedIndices.clear();
              _selectedItems.clear();
              _confirmedItems.clear();
              _boxIdConfirmController.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('HOÀN TẤT! Đã quét đúng tất cả BoxID!'),
                backgroundColor: Colors.deepPurple,
                duration: Duration(seconds: 4),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('BoxID này đã quét rồi!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SAI BoxID! Không thuộc danh sách cần gom!'),
            backgroundColor: Colors.red,
          ),
        );
      }

      _boxIdConfirmController.clear();
    });
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

  void _confirmSelection() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất một hàng!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      // Lấy ProductID của lô hàng đang chọn (tất cả cùng 1 loại nên lấy cái đầu)
      final String productId = _selectedItems.first['ProductID'];

      // Nếu chưa có màu cho sản phẩm này → gán màu mới (cố định mãi mãi)
      if (!_productColorMap.containsKey(productId)) {
        _productColorMap[productId] =
            _availableColors[_nextColorIndex % _availableColors.length];
        _nextColorIndex++;
      }

      final Color productColor = _productColorMap[productId]!;

      for (var item in _selectedItems) {
        bool exists = _confirmedItems.any(
          (e) => e['ShelfId'] == item['ShelfId'],
        );
        if (!exists) {
          _confirmedItems.add(item);

          // Khởi tạo trạng thái quét BoxID
          final boxList = item['BoxList'] as String;
          final boxIds = boxList
              .split(',')
              .map((e) => e.trim().toUpperCase())
              .toList();
          for (var boxId in boxIds) {
            _boxIdScanStatus[boxId] = false;
          }
        }
      }

      // Reset lựa chọn
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
                      const SizedBox(width: 12),
                      _buildActionButton(
                        'Xác nhận',
                        Icons.done_all,
                        Colors.blue,
                        _confirmSelection, // Hàm mới bạn cần tạo
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
                      DataCell(SelectableText(item['TT'].toString())),
                      DataCell(
                        SelectableText(
                          item['ShelfId'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      DataCell(SelectableText(item['ProductID'])),
                      DataCell(
                        SelectableText(
                          item['ProductName'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: SelectableText(
                            item['Qty'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataCell(SelectableText(item['BoxList'])),

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
                  _confirmedItems.isNotEmpty
                      ? _confirmedItems.first['ProductID']
                      : '',
                ),
                // _buildConfirmRow('+ TQty :', _selectedItems.fold(0, (sum, e) => sum + e['Qty']).toString()),
                _buildConfirmRow(
                  '+ BoxIDStock :',
                  _confirmedItems.map((e) => e['BoxList']).join(', '),
                ),
                _buildConfirmRow(
                  '+ ShelfId :',
                  _confirmedItems.map((e) => e['ShelfId']).join(', '),
                ),
                const SizedBox(height: 12),
                _buildConfirmRow(
                  '+ BoxIDConfirm :',
                  '',
                  controller: _boxIdConfirmController,
                  icon: Icons.qr_code_scanner,
                  onSubmitted: _onBoxScanned, // 🔹 gọi khi người dùng quét xong
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _confirmedItems.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa chọn hàng nào',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _confirmedItems.length,
                    itemBuilder: (ctx, i) {
                      final item = _confirmedItems[i];
                      return ListTile(
                        dense: true,
                        tileColor: _productColorMap[item['ProductID']]
                            ?.withOpacity(0.15),
                        leading:
                            _confirmedItems[i]['BoxList']
                                .toString()
                                .split(',')
                                .map((e) => e.trim().toUpperCase())
                                .every((box) => _boxIdScanStatus[box] == true)
                            ? Icon(
                                Icons.check_circle,
                                color: _productColorMap[item['ProductID']],
                              )
                            : const Icon(Icons.pending, color: Colors.grey),
                        title: Text(
                          item['ShelfId'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: _productColorMap[item['ProductID']],
                          ),
                        ),
                        subtitle: Text(
                          '${item['ProductName']} - Qty: ${item['Qty']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _productColorMap[item['ProductID']],
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              final index = _confirmedItems.indexWhere(
                                (e) => e['ShelfId'] == item['ShelfId'],
                              );
                              if (index != -1) {
                                final removedItem = _confirmedItems.removeAt(
                                  index,
                                );
                                final boxList = removedItem['BoxList']
                                    .toString()
                                    .split(',')
                                    .map((e) => e.trim().toUpperCase());
                                for (var box in boxList) {
                                  _boxIdScanStatus.remove(box);
                                }

                                // Nếu không còn dòng nào của sản phẩm này → có thể xóa màu (tùy anh)
                                // Hoặc giữ lại để lần sau dùng lại màu cũ → em giữ lại cho đẹp
                              }
                            });
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
    Function(String)? onSubmitted, // ✅ thêm callback
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
                    onSubmitted: onSubmitted, // ✅ thêm chỗ này
                    decoration: InputDecoration(
                      prefixIcon: icon != null ? Icon(icon, size: 16) : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      isDense: true,
                    ),
                  )
                : SelectableText(
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
