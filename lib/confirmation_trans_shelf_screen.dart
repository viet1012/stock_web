import 'package:flutter/material.dart';
import 'package:stock_web/widgets/custom_button.dart';

class FrmTransShelfScreen extends StatefulWidget {
  const FrmTransShelfScreen({super.key});

  @override
  State<FrmTransShelfScreen> createState() => _FrmTransShelfScreenState();
}

class _FrmTransShelfScreenState extends State<FrmTransShelfScreen> {
  final TextEditingController _boxController = TextEditingController();
  final TextEditingController _shelfController = TextEditingController();
  final FocusNode _boxFocus = FocusNode();
  final FocusNode _shelfFocus = FocusNode();

  String _statusMessage = "";
  Color _statusColor = Colors.black;

  List<Map<String, dynamic>> _waitingBoxes = [
    {
      "id": "800125",
      "shelfId": "Waiting",
      "productId": "H0077923",
      "productName": "[HF].SSB4-40-0",
      "qty": "95",
      "idBlock": "Box_[HF]_VEPN3-250-0_20251104062931",
      "MSNV": "9999",
      "firstTime": "",
      "POFirst": "MTSBox_[HF]_VEPAJ4-250-0_20251103072306",
      "remark": "A01",
    },
    {
      "id": "800185",
      "shelfId": "Waiting",
      "productId": "H0100573",
      "productName": "[HF].Set Part_R3",
      "qty": "1",
      "idBlock": "Box_[HF]_VEPN3-250-0_20251104062932",
      "MSNV": "9999",
      "firstTime": "",
      "POFirst": "MTSBox_[HF]_VEPAJ4-250-0_20251103072307",
      "remark": "A02",
    },
  ];

  @override
  void dispose() {
    _boxController.dispose();
    _shelfController.dispose();
    _boxFocus.dispose();
    _shelfFocus.dispose();
    super.dispose();
  }

  void _confirmTransfer() {
    final boxId = _boxController.text.trim();
    final shelfId = _shelfController.text.trim();

    if (boxId.isEmpty) {
      _setStatus("Vui lòng nhập BoxID cần chuyển", Colors.red);
      _boxFocus.requestFocus();
      return;
    }
    if (shelfId.isEmpty || shelfId.length > 15) {
      _setStatus("Quẹt sai kệ, vui lòng kiểm tra lại", Colors.red);
      _shelfController.clear();
      _shelfFocus.requestFocus();
      return;
    }

    // ✅ Giả lập cập nhật kệ thành công
    setState(() {
      for (var box in _waitingBoxes) {
        if (box['id'] == boxId) {
          box['shelfId'] = shelfId;
        }
      }
      _setStatus("Xác nhận chuyển kệ thành công", Colors.green);
      _boxController.clear();
      _shelfController.clear();
      _boxFocus.requestFocus();
    });
  }

  void _setStatus(String msg, Color color) {
    setState(() {
      _statusMessage = msg;
      _statusColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildTopPanel()),
                  Expanded(flex: 2, child: _buildBottomPanel()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("MSNV: 9999", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "XÁC NHẬN BOX CẦN CHUYỂN LÊN KỆ",
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Icon(Icons.calendar_month, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                'Ngày: ${DateTime.now().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopPanel() {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            "NHẬP THÔNG TIN BOX",
            Icons.qr_code_2,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildLabeledTextField(
            "Scan Box",
            _boxController,
            Icons.qr_code_scanner,
            focusNode: _boxFocus,
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_shelfFocus),
          ),
          const SizedBox(height: 12),
          _buildLabeledTextField(
            "Scan ShelfID",
            _shelfController,
            Icons.inventory_2,
            focusNode: _shelfFocus,
            onSubmitted: (_) => _confirmTransfer(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "Box còn lại: ${_waitingBoxes.where((b) => b['shelfId'] == 'Waiting').length}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: "XÁC NHẬN",
                        color: Colors.green,
                        icon: Icons.check_circle_outline,
                        onPressed: _confirmTransfer,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        label: "XÓA DỮ LIỆU",
                        color: Colors.red,
                        icon: Icons.delete_outline,
                        onPressed: () {
                          _boxController.clear();
                          _shelfController.clear();
                          _setStatus("", Colors.black);
                          _boxFocus.requestFocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            _statusMessage,
            style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            "DANH SÁCH F2_MTS_ShelfActualStock",
            Icons.table_chart,
            Colors.indigo,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (_) => Colors.grey.shade200,
                  ),
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("ShelfID")),
                    DataColumn(label: Text("ProductID")),
                    DataColumn(label: Text("ProductName")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("idBlock")),
                    DataColumn(label: Text("MSNV")),
                    DataColumn(label: Text("firstTime")),
                    DataColumn(label: Text("POFirst")),
                    DataColumn(label: Text("Remark")),
                  ],
                  rows: _waitingBoxes.map((e) {
                    return DataRow(
                      color: MaterialStateProperty.resolveWith(
                        (_) => e['shelfId'] == 'Waiting'
                            ? Colors.white
                            : Colors.green.shade50,
                      ),
                      cells: [
                        DataCell(Text(e['id'] ?? '')),
                        DataCell(Text(e['shelfId'] ?? '')),
                        DataCell(Text(e['productId'] ?? '')),
                        DataCell(Text(e['productName'] ?? '')),
                        DataCell(Text(e['qty'] ?? '')),
                        DataCell(Text(e['idBlock'] ?? '')),
                        DataCell(Text(e['MSNV'] ?? '')),
                        DataCell(Text(e['firstTime'] ?? '')),
                        DataCell(Text(e['POFirst'] ?? '')),
                        DataCell(Text(e['remark'] ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    FocusNode? focusNode,
    void Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  BoxDecoration _panelStyle() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
