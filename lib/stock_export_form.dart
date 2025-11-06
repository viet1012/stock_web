import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_web/widgets/custom_button.dart';

class StockExportForm extends StatefulWidget {
  const StockExportForm({super.key});

  @override
  State<StockExportForm> createState() => _StockExportFormState();
}

class _StockExportFormState extends State<StockExportForm> {
  final TextEditingController orderNoScanController = TextEditingController();
  final TextEditingController changeBlankController = TextEditingController();

  // Confirm fields
  final TextEditingController orderNoConfirmController =
      TextEditingController();
  final TextEditingController productIdConfirmController =
      TextEditingController();
  final TextEditingController poQtyConfirmController = TextEditingController();
  final TextEditingController boxIdStockConfirmController =
      TextEditingController();
  final TextEditingController shelfIdConfirmController =
      TextEditingController();

  final FocusNode qtyFocusNode = FocusNode();
  bool isQtyHighlighted = false;

  // Danh sách dữ liệu
  List<Map<String, dynamic>> orderWaitList = [];
  List<Map<String, dynamic>> filteredOrderList = [];
  List<Map<String, dynamic>> allBoxes = [];
  List<Map<String, dynamic>> displayedBoxes = [];

  int boxQty = 0;
  int remainQty = 0;

  String? selectedPOBoxId;

  Map<String, dynamic>? selectedBox;
  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _calculateTotals();
  }

  void _initializeMockData() {
    orderWaitList = [
      {
        'No': 1,
        'PartID': 'P1001',
        'PName': 'Ống thép 20mm',
        'QtyPO': 100,
        'QtyInOut': 0,
        'ShelfIDWait': 'Shelf-1',
        'BoxIDStock': '123',
        'Status': 'Chờ',
        'BoxID': 'BX501',
        'Remark': '',
      },
    ];

    allBoxes = [
      {
        'Firsttime': '2025-11-01 08:00',
        'BoxID': 'BX501',
        'QtyStock': 60,
        'CheckSt': 'OK',
        'ShelfID': 'Shelf-1',
      },
    ];

    // ✅ Thay bằng:
    filteredOrderList = []; // Bảng trống ban đầu

    displayedBoxes = [];
  }

  void _calculateTotals() {
    boxQty = allBoxes.fold(0, (sum, e) => sum + (e['QtyStock'] as int));
    int totalPO = orderWaitList.fold(0, (sum, e) => sum + (e['QtyPO'] as int));
    int totalExport = orderWaitList.fold(
      0,
      (sum, e) => sum + (e['QtyInOut'] as int),
    );
    remainQty = totalPO - totalExport;
    setState(() {});
  }

  void _filterByPO(String po) {
    setState(() {
      if (po.isEmpty) return;

      // Tìm PO hợp lệ trong danh sách tổng
      final matches = orderWaitList
          .where((e) => e['BoxIDStock'].toString().contains(po))
          .toList();

      for (var match in matches) {
        final exists = filteredOrderList.any(
          (item) => item['BoxIDStock'] == match['BoxIDStock'],
        );
        if (!exists) filteredOrderList.add(match);
      }

      orderNoScanController.clear(); // Xóa input sau khi nhập
    });
  }

  void _selectPO(Map<String, dynamic> po) {
    setState(() {
      selectedPOBoxId = po['BoxIDStock'];
      displayedBoxes = allBoxes
          .where((box) => box['ShelfID'] == po['ShelfIDWait'])
          .toList();

      orderNoConfirmController.text = po['BoxIDStock'];
      productIdConfirmController.text = po['PartID'];
      poQtyConfirmController.text = po['QtyPO'].toString();
      shelfIdConfirmController.text = po['ShelfIDWait'];
      boxIdStockConfirmController.text = po['BoxID'];

      // ✅ Bật highlight
      isQtyHighlighted = true;
    });

    // ✅ Delay nhẹ để đảm bảo UI build xong trước khi focus
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(qtyFocusNode);
    });
  }

  void _updateExportQty(int qtyExport, String boxId) {
    if (qtyExport <= 0 || selectedPOBoxId == null) return;

    setState(() {
      final poIndex = orderWaitList.indexWhere(
        (e) => e['BoxIDStock'] == selectedPOBoxId,
      );
      if (poIndex == -1) return;

      final po = orderWaitList[poIndex];
      final boxIndex = allBoxes.indexWhere((e) => e['BoxID'] == boxId);
      if (boxIndex == -1) return;

      final box = allBoxes[boxIndex];

      int currentStock = box['QtyStock'] as int;
      int currentInOut = po['QtyInOut'] as int;
      int poQty = po['QtyPO'] as int;

      // 🔹 Tồn kho không đủ
      if (qtyExport > currentStock) {
        _showMessage('❌ Số lượng vượt quá tồn kho!');
        FocusScope.of(context).requestFocus(qtyFocusNode);
        return;
      }

      // 🔹 Không được xuất vượt PO
      int remainingPO = poQty - currentInOut;
      if (qtyExport > remainingPO) {
        _showMessage('⚠️ Số lượng vượt quá số còn lại của PO!');
        return;
      }

      // ✅ Cập nhật tồn kho & PO
      box['QtyStock'] = currentStock - qtyExport;
      po['QtyInOut'] = currentInOut + qtyExport;

      // 🔹 Nếu đã đủ 100% thì cập nhật trạng thái
      if (po['QtyInOut'] >= poQty) {
        po['Status'] = 'Hoàn tất';
      }

      // 🔹 Cập nhật remainQty toàn màn hình
      _calculateTotals();

      displayedBoxes = allBoxes
          .where((b) => b['ShelfID'] == po['ShelfIDWait'])
          .toList();

      _showMessage(
        '✅ Xuất $qtyExport từ Box $boxId cho PO ${po['BoxIDStock']}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildLeftPanel()),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: _buildRightPanel()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ?? Ch?n thao tác
            Row(
              children: [
                const Text(
                  'Chọn thao tác:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 170,
                  child: DropdownButtonFormField<String>(
                    value: 'CheckBox',
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    items: ['CheckBox', 'Other']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ?? Ô nh?p OrderNo
            _buildInputField(
              'OrderNo:',
              orderNoScanController,
              Icons.qr_code_scanner,
              (val) => _filterByPO(val),
            ),

            const SizedBox(height: 16),
            if (selectedPOBoxId != null)
              // ?? Hành d?ng
              Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: CustomButton(
                      label: 'Xóa tất cả',
                      color: Colors.red.shade600,
                      icon: Icons.delete_forever,
                      onPressed: _clearAll,
                    ),
                  ),

                  // const Spacer(),
                  //
                  // // ?? Hi?n th? s? lu?ng box
                  // _buildBadge('Box: $boxQty', Colors.orange),
                ],
              ),

            const SizedBox(height: 12),
            const Divider(thickness: 1),

            // ?? B?ng danh sách PO
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildPOListTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPOListTable() {
    final columns = [
      'SPO No',
      'PartID',
      'PName',
      'QtyPO',
      'QtyInOut',
      'ShelfIDWait',
      'BoxIDStock',
      'Status',
      'Remark',
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.indigo.shade800,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: columns.map((c) {
                return Expanded(
                  child: Text(
                    c,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),

          // Body
          Expanded(
            child: filteredOrderList.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có dữ liệu - vui lòng nhập số PO',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOrderList.length,
                    itemBuilder: (ctx, i) {
                      final po = filteredOrderList[i];
                      final isSelected = po['BoxIDStock'] == selectedPOBoxId;
                      return GestureDetector(
                        onTap: () => _selectPO(po),
                        child: Container(
                          color: isSelected
                              ? Colors.yellow.shade100
                              : (i % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.shade100),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: columns.map((col) {
                              final val = po[col]?.toString() ?? '';
                              final isNumber = [
                                'QtyPO',
                                'QtyInOut',
                              ].contains(col);
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    val,
                                    textAlign: isNumber
                                        ? TextAlign.right
                                        : TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: col == 'BoxIDStock'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.blue.shade800
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
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

  Widget _buildRightPanel() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Kiểm tra & xác nhận Box cần lấy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Nhóm input (sử dụng Wrap để responsive)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildInputBox(
                    'Order No',
                    orderNoConfirmController,
                    width: 180,
                  ),
                  _buildInputBox(
                    'Product ID',
                    productIdConfirmController,
                    width: 180,
                  ),
                  _buildInputBox('PO Qty', poQtyConfirmController, width: 120),
                  _buildInputBox(
                    'Box ID',
                    boxIdStockConfirmController,
                    width: 180,
                  ),
                  _buildInputBox(
                    'Shelf ID',
                    shelfIdConfirmController,
                    width: 150,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔹 Nhập số lượng + Remain
          if (selectedPOBoxId != null)
            Row(
              children: [
                SizedBox(
                  width: 140,
                  child: TextField(
                    focusNode: qtyFocusNode,
                    controller: TextEditingController(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Thực tế xuất',
                      labelStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isQtyHighlighted
                              ? Colors.blue
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blue.shade600,
                          width: 2,
                        ),
                      ),
                      fillColor: isQtyHighlighted
                          ? Colors.blue.shade50
                          : Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (val) {
                      final qty = int.tryParse(val) ?? 0;
                      if (qty > 0 && selectedPOBoxId != null) {
                        _updateExportQty(qty, boxIdStockConfirmController.text);
                      }
                      setState(() => isQtyHighlighted = false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                _buildBadge('Còn lại: $remainQty', Colors.red),
              ],
            ),

          const SizedBox(height: 16),

          // 🔹 Bảng danh sách Box
          Expanded(child: _buildBoxListTable()),
        ],
      ),
    );
  }

  Widget _buildInputBox(
    String label,
    TextEditingController controller, {
    double width = 150,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          isDense: true,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildBoxListTable() {
    final columns = ['Firsttime', 'BoxID', 'QtyStock', 'CheckSt', 'ShelfID'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // ?? Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: columns
                  .map(
                    (c) => Expanded(
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // ?? Danh sách box
          Expanded(
            child: displayedBoxes.isEmpty
                ? const Center(
                    child: Text(
                      'Không có box nào trong kệ chờ',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: displayedBoxes.length,
                    itemBuilder: (ctx, i) {
                      final box = displayedBoxes[i];
                      return Container(
                        color: i.isEven ? Colors.white : Colors.grey.shade50,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: columns.map((col) {
                            final val = box[col]?.toString() ?? '';
                            final isNumber = ['QtyStock'].contains(col);
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  val,
                                  textAlign: isNumber
                                      ? TextAlign.right
                                      : TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
    Function(String) onSubmit,
  ) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onSubmitted: onSubmit,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
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

  void _clearAll() {
    setState(() {
      // ?? Xoá text trong toàn b? controller
      orderNoConfirmController.clear();
      productIdConfirmController.clear();
      poQtyConfirmController.clear();
      boxIdStockConfirmController.clear();
      shelfIdConfirmController.clear();

      // ?? Reset bi?n t?m
      selectedPOBoxId = null;
      remainQty = 0;

      // ?? Xoá danh sách hi?n th?
      displayedBoxes.clear();

      // (Tu?: n?u b?n có list khác nhu allBoxes, exportedBoxes,... có th? clear thêm)
      // allBoxes.clear();
      // exportedBoxes.clear();

      // ?? Focus v? ô d?u tiên
      FocusScope.of(context).requestFocus(FocusNode());
    });

    // ? Hi?n th? thông báo nh?
    _showMessage('Ðã xóa toàn bộ dữ liệu trên màn hình!');
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
