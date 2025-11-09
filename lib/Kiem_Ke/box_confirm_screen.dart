import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class BoxConfirmScreen extends StatefulWidget {
  const BoxConfirmScreen({super.key});

  @override
  State<BoxConfirmScreen> createState() => _BoxConfirmScreenState();
}

class _BoxConfirmScreenState extends State<BoxConfirmScreen> {
  final TextEditingController boxIdController = TextEditingController();
  final TextEditingController qtyController =
      TextEditingController(); // 🆕 ô nhập số lượng

  final List<Map<String, dynamic>> mockBoxes = [
    {'BoxID': '123', 'PName': 'Motor Fan', 'PID': 'P1001', 'QtyBox': 50},
    {'BoxID': 'BX002', 'PName': 'Cooler Cover', 'PID': 'P1002', 'QtyBox': 80},
    {'BoxID': 'BX003', 'PName': 'Filter Mesh', 'PID': 'P1003', 'QtyBox': 40},
  ];

  final List<Map<String, dynamic>> confirmedBoxes = [];

  Map<String, dynamic>? currentBoxInfo;

  void handleConfirm(String boxId) {
    final foundBox = mockBoxes.firstWhere(
      (b) => b['BoxID'].toString().toUpperCase() == boxId.toUpperCase(),
      orElse: () => {},
    );

    if (foundBox.isNotEmpty) {
      setState(() {
        currentBoxInfo = foundBox;
        qtyController.text = foundBox['QtyBox']
            .toString(); // 🆕 gợi ý số lượng ban đầu
      });
    } else {
      setState(() => currentBoxInfo = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ BoxID không tồn tại'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    boxIdController.clear();
  }

  int get totalQty =>
      confirmedBoxes.fold(0, (sum, item) => sum + (item['QtyBox'] as int));

  void printLabel(Map<String, dynamic> box, int newQty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🖨️ In tem cho BoxID: ${box['BoxID']} với số lượng $newQty',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // 🆕 Cập nhật lại danh sách confirmedBoxes
    setState(() {
      confirmedBoxes.add({...box, 'QtyBox': newQty});
      currentBoxInfo = null;
      qtyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📦 Xác nhận BoxID',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ô nhập BoxID
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: boxIdController,
                        decoration: InputDecoration(
                          labelText: 'Nhập BoxID (VD: 123)',
                          prefixIcon: const Icon(Icons.qr_code_2),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onSubmitted: handleConfirm,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Thông tin box hiện tại + nhập số lượng mới
                if (currentBoxInfo != null)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _infoItem(
                                Icons.inventory_2,
                                "BoxID",
                                currentBoxInfo!['BoxID'],
                              ),
                              _infoItem(
                                Icons.widgets,
                                "PName",
                                currentBoxInfo!['PName'],
                              ),
                              _infoItem(
                                Icons.label,
                                "PID",
                                currentBoxInfo!['PID'],
                              ),
                              _infoItem(
                                Icons.format_list_numbered,
                                "QtyBox",
                                currentBoxInfo!['QtyBox'].toString(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 🆕 Nhập số lượng mới và in tem
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  controller: qtyController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Số lượng thực té',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.print),
                                label: const Text('In tem'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () {
                                  final qty = int.tryParse(qtyController.text);
                                  if (qty == null || qty <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          '⚠️ Nhập số lượng hợp lệ!',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  } else {
                                    printLabel(currentBoxInfo!, qty);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Bảng danh sách
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable2(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (_) => Colors.indigo.shade700,
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      dataRowHeight: 32,
                      headingRowHeight: 34,
                      dividerThickness: 0.6,
                      columns: const [
                        DataColumn(label: Text('BoxID')),
                        DataColumn(label: Text('PName')),
                        DataColumn(label: Text('PID')),
                        DataColumn(label: Text('QtyBox')),
                        DataColumn(label: Text('Thao tác')),
                      ],
                      rows: confirmedBoxes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final box = entry.value;
                        return DataRow(
                          color: MaterialStateColor.resolveWith(
                            (states) => index % 2 == 0
                                ? Colors.grey.shade50
                                : Colors.white,
                          ),
                          cells: [
                            DataCell(Text(box['BoxID'].toString())),
                            DataCell(Text(box['PName'].toString())),
                            DataCell(Text(box['PID'].toString())),
                            DataCell(Text(box['QtyBox'].toString())),
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Xóa dòng',
                                onPressed: () {
                                  setState(() {
                                    confirmedBoxes.remove(box);
                                  });
                                },
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
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.teal, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
