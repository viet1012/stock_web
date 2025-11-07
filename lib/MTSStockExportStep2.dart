import 'package:flutter/material.dart';

class MTSStockExportStep2 extends StatefulWidget {
  const MTSStockExportStep2({super.key});

  @override
  State<MTSStockExportStep2> createState() => _MTSStockExportStep2State();
}

class _MTSStockExportStep2State extends State<MTSStockExportStep2> {
  final TextEditingController orderItoController = TextEditingController();
  final TextEditingController boxStockController = TextEditingController();

  List<String> shelfSuggestions = []; // Danh sách kệ gợi ý
  String? selectedShelf; // Kệ được chọn

  bool isLoadingShelf = false;
  String? shelfError; // Lỗi hoặc thông báo không có dữ liệu

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
              crossAxisAlignment: CrossAxisAlignment.start,
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

  // ------------------- HEADER -------------------
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  "QUẢN LÝ XUẤT KHO STOCK MTS (Bước 02)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6),
                Text(
                  "Gợi ý kệ chờ theo PO",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
          ),

          // Right buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text("In Lại Tem BoxID"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.qr_code, size: 18),
                      label: const Text("In QR Code"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Thoát"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "💡 Chỉ sử dụng in lại ngay sau khi in tem lỗi.",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- LEFT -------------------
  Widget _buildLeftSection() {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildInputRow(
              "Order Ito:",
              orderItoController,
              onSubmitted: _onOrderItoEntered,
            ),
            const SizedBox(height: 6),
            _buildShelfSuggestionBox(), // ✅ Gợi ý kệ chờ
            const SizedBox(height: 10),
            _buildInputRow("Box Stock:", boxStockController),
            const SizedBox(height: 16),

            _buildSectionTitle("Danh Sách Part Xuất Kho"),
            const SizedBox(height: 6),
            Expanded(
              child: _buildTable(
                headers: ["No", "ProductID", "PName", "POQty", "TQty", "IDBox"],
                data: const [],
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selectedShelf == null
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Đã chọn kệ $selectedShelf để xuất kho hàng bộ.",
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.inventory_outlined),
                label: const Text("Xuất Kho Hàng Bộ MTS"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- RIGHT -------------------
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
                headers: [
                  "OutputID",
                  "No",
                  "BoxID",
                  "ShelfWait",
                  "POQty",
                  "TQty",
                  "Noted",
                  "Date",
                ],
                data: const [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- COMMON UI PARTS -------------------
  Widget _buildInputRow(
    String label,
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

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
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade700,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
            ),
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

          // Body
          Expanded(
            child: data.isEmpty
                ? const Center(
                    child: Text(
                      "Chưa có dữ liệu",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return Container(
                        color: i.isEven ? Colors.grey[100] : Colors.grey[200],
                        child: Row(
                          children: headers.map((h) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  data[i][h]?.toString() ?? '',
                                  textAlign: TextAlign.center,
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

  // ------------------- SHELF SUGGESTION UI -------------------
  Widget _buildShelfSuggestionBox() {
    if (isLoadingShelf) {
      return const Center(child: CircularProgressIndicator());
    }

    if (shelfError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                shelfError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: shelfSuggestions.map((shelf) {
              return ChoiceChip(
                label: Text(shelf),
                selected: selectedShelf == shelf,
                onSelected: (val) {
                  setState(() {
                    selectedShelf = val ? shelf : null;
                  });
                },
                selectedColor: Colors.blue[200],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ------------------- LOGIC -------------------
  Future<void> _onOrderItoEntered(String po) async {
    if (po.isEmpty) return;

    setState(() {
      isLoadingShelf = true;
      shelfError = null;
      shelfSuggestions = [];
      selectedShelf = null;
    });

    // 🔸 Giả lập gọi API (bạn sẽ thay bằng apiService.fetchShelvesByPO(po))
    await Future.delayed(const Duration(seconds: 1));

    // 🔹 Giả lập dữ liệu trả về
    final Map<String, List<String>> dummyData = {
      "PO123": ["KE001", "KE003", "KE004"],
      "PO456": ["KE005"],
      "PO789": [],
    };

    final result = dummyData[po.toUpperCase()] ?? [];

    setState(() {
      isLoadingShelf = false;
      if (result.isEmpty) {
        shelfError = "Không tìm thấy kệ chờ phù hợp cho PO '$po'.";
      } else {
        shelfSuggestions = result;
        // Nếu chỉ có 1 kệ thì chọn sẵn
        if (result.length == 1) selectedShelf = result.first;
      }
    });
  }
}
