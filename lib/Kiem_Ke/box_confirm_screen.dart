import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../widgets/custom_button.dart';

class BoxConfirmScreen extends StatefulWidget {
  const BoxConfirmScreen({super.key});

  @override
  State<BoxConfirmScreen> createState() => _BoxConfirmScreenState();
}

class _BoxConfirmScreenState extends State<BoxConfirmScreen> {
  final TextEditingController boxIdController = TextEditingController();

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
        confirmedBoxes.add(foundBox);
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

  void printLabel(Map<String, dynamic> box) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🖨️ Đang in lại tem cho BoxID: ${box['BoxID']}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
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
                    Text(
                      'Tổng số lượng: $totalQty',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ô nhập BoxID + nút xác nhận
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: boxIdController,
                        decoration: InputDecoration(
                          labelText: 'Nhập BoxIDConfirm (Ví dụ: 123)',
                          prefixIcon: const Icon(Icons.qr_code_2),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onSubmitted: handleConfirm,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Thông tin Box hiện tại
                if (currentBoxInfo != null)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      child: Row(
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
                          _infoItem(Icons.label, "PID", currentBoxInfo!['PID']),
                          _infoItem(
                            Icons.format_list_numbered,
                            "QtyBox",
                            currentBoxInfo!['QtyBox'].toString(),
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
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.print,
                                      color: Colors.blueAccent,
                                    ),
                                    tooltip: 'In lại tem',
                                    onPressed: () => printLabel(box),
                                  ),
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
                                ],
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
