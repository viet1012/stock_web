import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_web/widgets/custom_button.dart';

class InventoryItem {
  final String boxId;
  final String pid;
  final String pName;
  final String status;
  final String date;
  final String shelfId;
  final int qty;

  InventoryItem({
    required this.boxId,
    required this.pid,
    required this.pName,
    required this.status,
    required this.date,
    required this.shelfId,
    required this.qty,
  });
}

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final TextEditingController _boxIdConfirmController = TextEditingController();
  final TextEditingController _qtyActualController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  String _selectedCondition = 'By Shelf';
  String _selectedRange = '1 tháng';

  // Mock data
  List<InventoryItem> _allItems = [];
  List<InventoryItem> _filteredItems = [];
  List<InventoryItem> _ngItems = [];

  InventoryItem? _selectedItem; // dòng đang được chọn
  final FocusNode _boxFocus = FocusNode();
  final FocusNode _qtyFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _mockData();
    _filteredItems = List.from(_allItems);
  }

  @override
  void dispose() {
    _boxIdConfirmController.dispose();
    _qtyActualController.dispose();
    _conditionController.dispose();
    _boxFocus.dispose();
    _qtyFocus.dispose();
    super.dispose();
  }

  void _mockData() {
    _allItems = List.generate(20, (i) {
      return InventoryItem(
        boxId: 'BOX${1000 + i}',
        pid: 'P${i + 1}',
        pName: i % 2 == 0 ? 'Hoa hồng' : 'Hoa lan',
        status: 'Chưa kiểm',
        date: '2025-11-05',
        shelfId: i % 3 == 0
            ? 'A1'
            : i % 3 == 1
            ? 'B2'
            : 'C3',
        qty: 100 + i * 5, // ví dụ: số lượng chuẩn trong hệ thống
      );
    });
  }

  void _filterItems() {
    String condition = _selectedCondition;
    String value = _conditionController.text.trim().toLowerCase();

    setState(() {
      if (condition == 'All' || value.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else if (condition == 'By Shelf') {
        _filteredItems = _allItems
            .where((e) => e.shelfId.toLowerCase().contains(value))
            .toList();
      } else if (condition == 'By Name') {
        _filteredItems = _allItems
            .where((e) => e.pName.toLowerCase().contains(value))
            .toList();
      }
    });
  }

  void _confirmBox() {
    if (_selectedItem == null) {
      _showMessage('Vui lòng quét BoxID hợp lệ trước!');
      return;
    }

    int? qtyActual = int.tryParse(_qtyActualController.text.trim());
    if (qtyActual == null) {
      _showMessage('Vui lòng nhập số lượng thực tế!');
      return;
    }

    final item = _selectedItem!;
    setState(() {
      if (qtyActual < item.qty) {
        // ❌ NG
        _ngItems.add(
          InventoryItem(
            boxId: item.boxId,
            pid: item.pid,
            pName: item.pName,
            status: 'NG - Thiếu hàng',
            date: DateTime.now().toString().split(' ')[0],
            shelfId: item.shelfId,
            qty: item.qty,
          ),
        );
        _allItems.removeWhere((e) => e.boxId == item.boxId);
        _showMessage('❌ Box ${item.boxId} thiếu hàng → chuyển NG');
      } else {
        // ✅ Đúng
        final index = _allItems.indexWhere((e) => e.boxId == item.boxId);
        if (index != -1) {
          _allItems[index] = InventoryItem(
            boxId: item.boxId,
            pid: item.pid,
            pName: item.pName,
            status: 'Đã kiểm',
            date: DateTime.now().toString().split(' ')[0],
            shelfId: item.shelfId,
            qty: item.qty,
          );
        }
        _showMessage('✅ Box ${item.boxId} đã kiểm');
      }

      _selectedItem = null;
      _boxIdConfirmController.clear();
      _qtyActualController.clear();
      _filterItems();

      // Tự focus lại về BoxID để quét tiếp
      Future.delayed(const Duration(milliseconds: 200), () {
        FocusScope.of(context).requestFocus(_boxFocus);
      });
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800; // < 800px coi là mobile/tablet

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),

                // 🔹 Panel trên
                Expanded(
                  flex: isMobile ? 0 : 2,
                  child: isMobile
                      ? Column(
                          children: [
                            _buildLeftPanel(),
                            const SizedBox(height: 12),
                            _buildCenterPanel(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(flex: 3, child: _buildLeftPanel()),
                            const SizedBox(width: 12),
                            Expanded(flex: 5, child: _buildCenterPanel()),
                          ],
                        ),
                ),

                const SizedBox(height: 8),

                // 🔹 Bảng dưới
                Expanded(
                  flex: 3,
                  child: isMobile
                      ? Column(
                          children: [
                            Expanded(
                              child: _buildDataTable(
                                title: 'Danh sách kiểm kê',
                                items: _filteredItems,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _buildDataTable(
                                title: 'Danh sách NG',
                                items: _ngItems,
                              ),
                            ),
                          ],
                        )
                      : _buildBottomTables(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    int total = _allItems.length;
    int checked = _allItems.where((e) => e.status == 'Đã kiểm').length;
    int remain = total - checked;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            'TỔNG: $total   ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          Text(
            'Đã kiểm: $checked   ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(
            'Còn lại: $remain',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // LEFT PANEL
  Widget _buildLeftPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: _panelDecoration(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điều kiện kiểm kê',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: isMobile ? 16 : 18,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Chọn điều kiện:'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'By Shelf',
                      child: Text('By Shelf'),
                    ),
                    DropdownMenuItem(value: 'By Name', child: Text('By Name')),
                    DropdownMenuItem(value: 'All', child: Text('All')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedCondition = val!;
                      _conditionController.clear();
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (_selectedCondition != 'All') ...[
                  Text(
                    _selectedCondition == 'By Shelf'
                        ? 'Nhập tên kệ:'
                        : 'Nhập tên hàng:',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _conditionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const Text('Khoảng thời gian:'),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _selectedRange,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: '1 tuần', child: Text('1 tuần')),
                    DropdownMenuItem(value: '1 tháng', child: Text('1 tháng')),
                    DropdownMenuItem(value: '3 tháng', child: Text('3 tháng')),
                    DropdownMenuItem(value: '6 tháng', child: Text('6 tháng')),
                  ],
                  onChanged: (val) => setState(() => _selectedRange = val!),
                ),
                const SizedBox(height: 12),
                if (isMobile)
                  Column(
                    children: [
                      CustomButton(
                        label: 'Xóa',
                        color: Colors.red.shade600,
                        icon: Icons.delete_forever,
                        onPressed: () =>
                            setState(() => _conditionController.clear()),
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                        label: 'Thực hiện',
                        color: Colors.blue,
                        icon: Icons.play_arrow,
                        onPressed: _filterItems,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Xóa',
                          color: Colors.red.shade600,
                          icon: Icons.delete_forever,
                          onPressed: () =>
                              setState(() => _conditionController.clear()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          label: 'Thực hiện',
                          color: Colors.blue,
                          icon: Icons.play_arrow,
                          onPressed: _filterItems,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // CENTER PANEL
  Widget _buildCenterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputRow(),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          if (_selectedItem != null) _buildBoxDetail(_selectedItem!),
          if (_selectedItem == null)
            const Text(
              '⚠️ Hãy quét hoặc nhập BoxID để xem chi tiết.',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Cột nhập BoxID
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📦 BoxID:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  focusNode: _boxFocus,
                  controller: _boxIdConfirmController,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: 'Quét hoặc nhập mã thùng...',
                  ),
                  onSubmitted: (value) {
                    _selectBoxById(value.trim().toUpperCase());
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 🔹 Cột nhập số lượng thực tế
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Số lượng thực tế:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  focusNode: _qtyFocus,
                  controller: _qtyActualController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done, // 🔹 thêm dòng này
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: 'Nhập số lượng kiểm thực tế...',
                  ),
                  onSubmitted: (value) {
                    _confirmBox(); // Gọi luôn xác nhận khi nhấn Enter
                    _boxFocus.requestFocus(); // Trả focus lại cho ô BoxID
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectBoxById(String boxId) {
    if (boxId.isEmpty) return;

    final found = _allItems.firstWhere(
      (e) => e.boxId.toUpperCase() == boxId,
      orElse: () => InventoryItem(
        boxId: '',
        pid: '',
        pName: '',
        status: '',
        date: '',
        shelfId: '',
        qty: 0,
      ),
    );

    if (found.boxId.isEmpty) {
      _showMessage('❌ BoxID "$boxId" không tồn tại trong danh sách!');
      setState(() => _selectedItem = null);
      return;
    }

    setState(() {
      _selectedItem = found;
    });

    // Tự động focus qua ô nhập số lượng
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_qtyFocus);
    });
  }

  Widget _buildLabelRow(String a, String b, String c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          a,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          b,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          c,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBoxDetail(InventoryItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📦 BoxID: ${item.boxId}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PID: ${item.pid}'),
              Text('Tên hàng: ${item.pName}'),
              Text('Số lượng (Qty Box): ${item.qty}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kệ: ${item.shelfId}'),
              Text('Ngày: ${item.date}'),
              Text('Trạng thái: ${item.status}'),
            ],
          ),
        ],
      ),
    );
  }

  // BOTTOM TABLES
  Widget _buildBottomTables() {
    return Row(
      children: [
        Expanded(
          child: _buildDataTable(
            title: 'Danh sách kiểm kê',
            items: _filteredItems,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDataTable(title: 'Danh sách NG', items: _ngItems),
        ),
      ],
    );
  }

  Widget _buildDataTable({
    required String title,
    required List<InventoryItem> items,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _panelDecoration(),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (_) => Colors.indigo.shade700,
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      dataRowHeight: isMobile ? 28 : 32,

                      headingRowHeight: 34,
                      dividerThickness: 0.6,
                      columnSpacing: 40,
                      columns: const [
                        DataColumn(label: Text('STT')),
                        DataColumn(label: Text('BoxID')),
                        DataColumn(label: Text('PID')),
                        DataColumn(label: Text('PName')),
                        DataColumn(label: Text('Qty')),
                        DataColumn(label: Text('StatusCheck')),
                        DataColumn(label: Text('DateInventory')),
                        DataColumn(label: Text('ShelfID')),
                      ],
                      rows: items.asMap().entries.map((e) {
                        final i = e.key;
                        final item = e.value;
                        final isSelected = _selectedItem?.boxId == item.boxId;
                        return DataRow(
                          color: MaterialStateProperty.resolveWith(
                            (_) => isSelected
                                ? Colors.yellow.shade100
                                : i.isEven
                                ? Colors.white
                                : Colors.grey.shade50,
                          ),
                          cells: [
                            DataCell(Text('${i + 1}')),
                            DataCell(SelectableText(item.boxId)),
                            DataCell(SelectableText(item.pid)),
                            DataCell(SelectableText(item.pName)),
                            DataCell(SelectableText(item.qty.toString())),
                            DataCell(SelectableText(item.status)),
                            DataCell(SelectableText(item.date)),
                            DataCell(SelectableText(item.shelfId)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
