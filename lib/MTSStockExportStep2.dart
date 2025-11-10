import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_web/widgets/header_bar.dart';

import 'Data/mock_inventory_data.dart';

class MTSStockExportStep2 extends StatefulWidget {
  const MTSStockExportStep2({super.key});

  @override
  State<MTSStockExportStep2> createState() => _MTSStockExportStep2State();
}

class _MTSStockExportStep2State extends State<MTSStockExportStep2> {
  final TextEditingController orderItoController = TextEditingController();
  final TextEditingController boxStockController = TextEditingController();

  final FocusNode orderItoFocusNode = FocusNode();
  final FocusNode boxFocusNode = FocusNode();

  List<String> shelfSuggestions = [];
  String? selectedShelf;
  bool isLoadingShelf = false;
  String? shelfError;

  bool isPOScanned = false;

  late final Map<String, List<Map<String, dynamic>>> dummyPartsByPO;

  @override
  void initState() {
    super.initState();
    dummyPartsByPO = buildPartsByPOFromMock();
  }

  Map<String, List<Map<String, dynamic>>> buildPartsByPOFromMock() {
    final orders = MockInventoryData.getOrderWaitList();
    final boxes = MockInventoryData.getAllBoxes();

    final Map<String, List<Map<String, dynamic>>> partsByPO = {};

    for (var order in orders) {
      final po = order['POCode'];
      final boxList = boxes.where((b) => b['POCode'] == po).toList();

      partsByPO[po] = boxList.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final box = entry.value;
        return {
          "No": idx,
          "ProductID": order['PartID'],
          "PName": order['PName'],
          "POQty": order['QtyPO'],
          "TQty": 0,
          "QtyExport": box['QtyStock'],
          "IDBox": box['BoxID'],
        };
      }).toList();
    }

    return partsByPO;
  }

  List<Map<String, dynamic>> partList = [];
  List<Map<String, dynamic>> successList = [];

  @override
  void dispose() {
    orderItoFocusNode.dispose();
    boxFocusNode.dispose();
    orderItoController.dispose();
    boxStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          HeaderBar(msnv: '9999', title: 'XUẤT KHO BƯỚC 2'),
          const SizedBox(height: 12),
          _buildHeader(),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildLeftSection()),
                Expanded(flex: 3, child: _buildRightSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print),
            label: const Text("In Lại Tem BoxID"),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            // ✅ Nút in QR chỉ bấm được nếu đã quét PO
            onPressed: isPOScanned
                ? () {
                    _showSnackBar(
                      "🖨️ In QR Code cho PO ${orderItoController.text}",
                      Colors.blue,
                    );
                  }
                : null, // 🔒 Disable nếu chưa quét PO
            icon: const Icon(Icons.qr_code),
            label: const Text("In QR Code"),
          ),
        ],
      ),
    );
  }

  // ---------------- LEFT ----------------
  Widget _buildLeftSection() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildInputRow(
              "PO:",
              "Nhập số đơn hàng (VD: 123)",
              focus: orderItoFocusNode,
              controller: orderItoController,
              onSubmitted: _onOrderItoEntered,
            ),
            const SizedBox(height: 6),
            _buildShelfSuggestionBox(),
            const SizedBox(height: 10),
            _buildInputRow(
              "Box Stock:",
              "Nhập mã box (VD: BOX001)",
              focus: boxFocusNode,
              controller: boxStockController,
              onSubmitted: _onBoxStockEntered,
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Danh Sách Part Xuất Kho"),
            const SizedBox(height: 6),
            Expanded(
              child: _buildTable(
                headers: [
                  "No",
                  "ProductID",
                  "PName",
                  "POQty",
                  "TQty",
                  "QtyExport",
                  "IDBox",
                ],
                data: partList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- RIGHT ----------------
  Widget _buildRightSection() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSectionTitle("Danh Sách Xuất Kho Thành Công"),
            const SizedBox(height: 6),
            Expanded(
              child: _buildTable(
                headers: [
                  "OutputID",
                  "BoxID",
                  "Shelf",
                  "PO",
                  "QtyExport",
                  "Date",
                ],
                data: successList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI Helpers ----------------
  Widget _buildInputRow(
    String label,
    String hint, {
    required FocusNode focus,
    required TextEditingController controller,
    Function(String)? onSubmitted,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: TextField(
            autofocus: true,
            focusNode: focus,
            controller: controller,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              isDense: true,
              labelText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    ),
  );

  Widget _buildTable({
    required List<String> headers,
    required List<Map<String, dynamic>> data,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.indigo.shade700,
            child: Row(
              children: headers
                  .map(
                    (h) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          h,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text("Chưa có dữ liệu"))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      final row = data[i];
                      return Container(
                        color: i.isEven ? Colors.grey[100] : Colors.grey[200],
                        child: Row(
                          children: headers
                              .map(
                                (h) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      row[h]?.toString() ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------- SHELF BOX ----------------
  Widget _buildShelfSuggestionBox() {
    if (isLoadingShelf) return const Center(child: CircularProgressIndicator());
    if (shelfError != null) {
      return _buildMessageBox(
        Icons.error_outline,
        shelfError!,
        Colors.red[50]!,
      );
    }
    if (shelfSuggestions.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🟦 Gợi ý kệ chờ:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: shelfSuggestions
                .map(
                  (shelf) => ChoiceChip(
                    label: Text(shelf),
                    selected: selectedShelf == shelf,
                    onSelected: (val) =>
                        setState(() => selectedShelf = val ? shelf : null),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBox(IconData icon, String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ---------------- LOGIC ----------------
  Future<void> _onOrderItoEntered(String po) async {
    if (po.isEmpty) return;
    final upper = po.toUpperCase();

    setState(() {
      isLoadingShelf = true;
      partList = [];
      shelfSuggestions = [];
      shelfError = null;
      selectedShelf = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    final shelfMap = {
      "PO123": ["KE001", "KE002"],
      "PO456": ["KE003"],
    };

    if (!dummyPartsByPO.containsKey(upper)) {
      setState(() {
        isLoadingShelf = false;
        shelfError = "❌ Không tìm thấy dữ liệu PO '$upper'";
      });
      _showSnackBar("PO không tồn tại!", Colors.red);
      SystemSound.play(SystemSoundType.alert);
      return;
    }

    // ✅ Load parts và shelf
    setState(() {
      isLoadingShelf = false;
      shelfSuggestions = shelfMap[upper] ?? [];
      partList = List<Map<String, dynamic>>.from(dummyPartsByPO[upper]!);

      // ✅ Nếu chỉ có 1 kệ → chọn luôn
      // ✅ Nếu có nhiều kệ → chọn mặc định kệ đầu tiên
      if (shelfSuggestions.isNotEmpty) {
        selectedShelf = shelfSuggestions.first;
      }

      isPOScanned = true; // ✅ Đánh dấu đã quét PO
    });

    // ✅ Sau khi load xong thì focus vào ô Box
    FocusScope.of(context).requestFocus(boxFocusNode);
  }

  void _onBoxStockEntered(String boxId) {
    final upperBox = boxId.toUpperCase();
    final po = orderItoController.text.trim().toUpperCase();

    if (po.isEmpty) {
      _showSnackBar("⚠️ Vui lòng nhập PO trước khi quét Box!", Colors.orange);
      SystemSound.play(SystemSoundType.alert);
      FocusScope.of(context).requestFocus(orderItoFocusNode);
      return;
    }

    if (partList.isEmpty) {
      _showSnackBar("⚠️ Chưa có dữ liệu Part cho PO $po!", Colors.orange);
      SystemSound.play(SystemSoundType.alert);
      FocusScope.of(context).requestFocus(orderItoFocusNode);
      return;
    }

    final matchedIndex = partList.indexWhere(
      (p) => p["IDBox"].toString().toUpperCase() == upperBox,
    );

    if (matchedIndex == -1) {
      _showSnackBar(
        "❌ Box $upperBox không khớp với IDBox nào trong PO $po!",
        Colors.red,
      );
      SystemSound.play(SystemSoundType.alert);
      boxStockController.clear();
      FocusScope.of(context).requestFocus(boxFocusNode);
      return;
    }

    final matchedPart = partList[matchedIndex];
    final newExport = {
      "OutputID": "OUT-${DateTime.now().millisecondsSinceEpoch}",
      "BoxID": matchedPart["IDBox"],
      "Shelf": selectedShelf ?? "Chưa chọn",
      "PO": po,
      "QtyExport": matchedPart["QtyExport"], // ✅ Thêm dòng này
      "Date": DateTime.now().toString().substring(0, 19),
    };

    setState(() {
      partList.removeAt(matchedIndex);
      successList.insert(0, newExport);
    });

    _showSnackBar("✅ Đã xuất kho Box $upperBox", Colors.green);
    SystemSound.play(SystemSoundType.click);
    boxStockController.clear();

    if (partList.isEmpty) {
      _showSnackBar("🎉 Đã xuất hết tất cả Box của PO $po!", Colors.blueAccent);
      SystemSound.play(SystemSoundType.click);

      setState(() {
        orderItoController.clear();
        boxStockController.clear();
        selectedShelf = null;
        shelfSuggestions = [];
        shelfError = null;
        isPOScanned = false; // ❌ Tắt lại khi PO đã xuất hết
      });

      // ✅ Khi xong thì focus về ô PO
      FocusScope.of(context).requestFocus(orderItoFocusNode);
    } else {
      // ✅ Còn box → focus lại ô Box
      FocusScope.of(context).requestFocus(boxFocusNode);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
