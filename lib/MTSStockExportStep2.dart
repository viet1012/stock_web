import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MTSStockExportStep2 extends StatefulWidget {
  const MTSStockExportStep2({super.key});

  @override
  State<MTSStockExportStep2> createState() => _MTSStockExportStep2State();
}

class _MTSStockExportStep2State extends State<MTSStockExportStep2> {
  final TextEditingController orderItoController = TextEditingController();
  final TextEditingController boxStockController = TextEditingController();

  List<String> shelfSuggestions = [];
  String? selectedShelf;
  bool isLoadingShelf = false;
  String? shelfError;

  // ✅ Data ảo
  final Map<String, List<Map<String, dynamic>>> dummyPartsByPO = {
    "PO123": [
      {
        "No": 1,
        "ProductID": "P1001",
        "PName": "Hoa Hồng",
        "POQty": 10,
        "TQty": 0,
        "IDBox": "BOX001",
      },
      {
        "No": 2,
        "ProductID": "P1002",
        "PName": "Hoa Ly",
        "POQty": 5,
        "TQty": 0,
        "IDBox": "BOX002",
      },
    ],
    "PO456": [
      {
        "No": 1,
        "ProductID": "P2001",
        "PName": "Hoa Cúc",
        "POQty": 8,
        "TQty": 0,
        "IDBox": "BOX003",
      },
    ],
  };

  List<Map<String, dynamic>> partList = [];
  List<Map<String, dynamic>> successList = [];

  @override
  void dispose() {
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
          const Text(
            "📦 MTS - Xuất Kho Hàng Bộ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print),
            label: const Text("In Lại Tem BoxID"),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {},
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
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildInputRow(
              "PO:",
              "Nhập số đơn hàng (VD: PO123)",
              orderItoController,
              onSubmitted: _onOrderItoEntered,
            ),
            const SizedBox(height: 6),
            _buildShelfSuggestionBox(),
            const SizedBox(height: 10),
            _buildInputRow(
              "Box Stock:",
              "Nhập mã box (VD: BOX001)",
              boxStockController,
              onSubmitted: _onBoxStockEntered,
            ),
            const SizedBox(height: 12),

            _buildSectionTitle("Danh Sách Part Xuất Kho"),
            const SizedBox(height: 6),
            Expanded(
              child: _buildTable(
                headers: ["No", "ProductID", "PName", "POQty", "TQty", "IDBox"],
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
                headers: ["OutputID", "BoxID", "Shelf", "PO", "Date"],
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
    String hint,
    TextEditingController controller, {
    Function(String)? onSubmitted,
  }) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label)),
        Expanded(
          child: TextField(
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
            children: shelfSuggestions.map((shelf) {
              return ChoiceChip(
                label: Text(shelf),
                selected: selectedShelf == shelf,
                onSelected: (val) {
                  setState(() => selectedShelf = val ? shelf : null);
                },
              );
            }).toList(),
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

    setState(() {
      isLoadingShelf = false;
      shelfSuggestions = shelfMap[upper] ?? [];
      partList = dummyPartsByPO[upper]!;
      if (shelfSuggestions.length == 1) selectedShelf = shelfSuggestions.first;
    });
  }

  void _onBoxStockEntered(String boxId) {
    final upperBox = boxId.toUpperCase();
    final po = orderItoController.text.trim().toUpperCase();

    if (po.isEmpty) {
      _showSnackBar("⚠️ Vui lòng nhập PO trước khi quét Box!", Colors.orange);
      SystemSound.play(SystemSoundType.alert);
      return;
    }

    if (partList.isEmpty) {
      _showSnackBar("⚠️ Chưa có dữ liệu Part cho PO $po!", Colors.orange);
      SystemSound.play(SystemSoundType.alert);
      return;
    }

    final matchedPart = partList.firstWhere(
      (p) => p["IDBox"].toString().toUpperCase() == upperBox,
      orElse: () => {},
    );

    if (matchedPart.isEmpty) {
      _showSnackBar("❌ Box $upperBox không khớp với IDBox nào!", Colors.red);
      SystemSound.play(SystemSoundType.alert);
      return;
    }

    // ✅ Cập nhật TQty
    setState(() {
      matchedPart["TQty"] = (matchedPart["POQty"] as int);
    });

    final newExport = {
      "OutputID": "OUT-${DateTime.now().millisecondsSinceEpoch}",
      "BoxID": upperBox,
      "Shelf": selectedShelf ?? "Chưa chọn",
      "PO": po,
      "Date": DateTime.now().toString().substring(0, 19),
    };

    setState(() {
      successList.insert(0, newExport);
    });

    _showSnackBar("✅ Xuất kho thành công cho Box $upperBox", Colors.green);
    SystemSound.play(SystemSoundType.click);
    boxStockController.clear();
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
