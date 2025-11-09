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
  bool _isBoxValid = false; // ✅ Cờ kiểm tra Box hợp lệ

  List<Map<String, dynamic>> _waitingBoxes = [
    {
      "id": "800125",
      "shelfId": "Waiting",
      "productId": "H0077923",
      "productName": "[VT].BTHNB4-40-0",
      "qty": "95",
      "idBlock": "Box_[HN]_VTPN3-250-0_20251104062931",
      "MSNV": "9999",
      "firstTime": "",
      "POFirst": "MTSBox_[HN]_VEPAJ4-250-0_20251103072306",
      "remark": "A01",
    },
    {
      "id": "800185",
      "shelfId": "Waiting",
      "productId": "H0100573",
      "productName": "[HN].Set Part_R3",
      "qty": "1",
      "idBlock": "Box_[VT]_VEPN3-250-0_20251104062932",
      "MSNV": "9999",
      "firstTime": "",
      "POFirst": "Box_[HN]_VEPAJ4-250-0_20251103072307",
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

  // ✅ Hàm xác nhận Box trước khi cho nhập ShelfID
  void _checkBoxValid() {
    final idBlockInput = _boxController.text.trim();

    if (idBlockInput.isEmpty) {
      _setStatus("⚠️ Vui lòng nhập mã BoxID", Colors.red);
      _isBoxValid = false;
      _boxFocus.requestFocus();
      return;
    }

    final exists = _waitingBoxes.any((b) => b['idBlock'] == idBlockInput);

    if (!exists) {
      _setStatus("❌ BoxID không tồn tại, vui lòng kiểm tra lại", Colors.red);
      _isBoxValid = false;
      _shelfController.clear();
      _boxFocus.requestFocus();
    } else {
      _setStatus("✅ Box hợp lệ! Vui lòng nhập ShelfID", Colors.green);
      _isBoxValid = true;
      FocusScope.of(context).requestFocus(_shelfFocus);
    }

    setState(() {});
  }

  void _confirmTransfer() {
    if (!_isBoxValid) {
      _setStatus("⚠️ Box chưa hợp lệ, không thể nhập ShelfID!", Colors.red);
      _boxFocus.requestFocus();
      return;
    }

    final idBlockInput = _boxController.text.trim();
    final shelfId = _shelfController.text.trim();

    if (shelfId.isEmpty || shelfId.length > 15) {
      _setStatus("❌ Quẹt sai kệ, vui lòng kiểm tra lại", Colors.red);
      _shelfController.clear();
      _shelfFocus.requestFocus();
      return;
    }

    final existingBoxIndex = _waitingBoxes.indexWhere(
      (box) => box['idBlock'] == idBlockInput,
    );

    if (existingBoxIndex == -1) {
      _setStatus("❌ idBlock không tồn tại, vui lòng kiểm tra lại", Colors.red);
      _boxController.clear();
      _isBoxValid = false;
      _boxFocus.requestFocus();
      return;
    }

    setState(() {
      _waitingBoxes[existingBoxIndex]['shelfId'] = shelfId;
      _setStatus("✅ Xác nhận chuyển kệ thành công", Colors.green);
      _boxController.clear();
      _shelfController.clear();
      _isBoxValid = false; // reset lại
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
    final media = MediaQuery.of(context);
    final isPhone = media.size.width < 600; // Tiêu chuẩn điện thoại dưới 600px

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // HeaderBar(msnv: '9999', title: "XÁC NHẬN BOX CẦN CHUYỂN LÊN KỆ"),
            // const SizedBox(height: 10),
            // Dùng Flexible để không bị bó chặt khi chiều cao nhỏ
            Flexible(
              child: isPhone
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTopPanel(isPhone),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 400,
                            child: _buildBottomPanel(isPhone),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(child: _buildTopPanel(isPhone)),
                        Expanded(flex: 2, child: _buildBottomPanel(isPhone)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPanel(bool isPhone) {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            "NHẬP THÔNG TIN BOX",
            Icons.qr_code_2,
            Colors.blue,
          ),
          const SizedBox(height: 8),

          // ✅ Scan BoxID
          _buildLabeledTextField(
            "Scan BoxID",
            _boxController,
            Icons.qr_code_scanner,
            focusNode: _boxFocus,
            onSubmitted: (_) => _checkBoxValid(), // kiểm tra ngay khi nhập xong
          ),
          const SizedBox(height: 8),

          // ✅ Scan ShelfID — chỉ bật khi Box hợp lệ
          TextField(
            controller: _shelfController,
            focusNode: _shelfFocus,
            enabled: _isBoxValid, // ✅ chỉ bật khi box hợp lệ
            onSubmitted: (_) => _confirmTransfer(),
            decoration: InputDecoration(
              labelText: _isBoxValid
                  ? "Scan ShelfID"
                  : "Vui lòng quét đúng Box trước",
              prefixIcon: const Icon(Icons.inventory_2),
              filled: true,
              fillColor: _isBoxValid ? Colors.white : Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Nút reset + trạng thái
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Box còn lại: ${_waitingBoxes.where((b) => b['shelfId'] == 'Waiting').length}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              CustomButton(
                label: "XÓA DỮ LIỆU",
                color: Colors.red,
                icon: Icons.delete_outline,
                onPressed: () {
                  _boxController.clear();
                  _shelfController.clear();
                  _isBoxValid = false;
                  _setStatus("", Colors.black);
                  _boxFocus.requestFocus();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _statusMessage,
            style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(bool isPhone) {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("DANH SÁCH ", Icons.table_chart, Colors.indigo),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: isPhone
                        ? 800
                        : 1000, // Bảng có chiều ngang tối thiểu để scroll ngang trên điện thoại
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (_) => Colors.indigo.shade700,
                    ),
                    headingTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("ShelfID")),
                      DataColumn(label: Text("ProductID")),
                      DataColumn(label: Text("ProductName")),
                      DataColumn(label: Text("Qty")),
                      DataColumn(label: Text("IdBlock")),
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
                          DataCell(SelectableText(e['id'] ?? '')),
                          DataCell(SelectableText(e['shelfId'] ?? '')),
                          DataCell(SelectableText(e['productId'] ?? '')),
                          DataCell(SelectableText(e['productName'] ?? '')),
                          DataCell(SelectableText(e['qty'] ?? '')),
                          DataCell(SelectableText(e['idBlock'] ?? '')),
                          DataCell(SelectableText(e['MSNV'] ?? '')),
                          DataCell(SelectableText(e['firstTime'] ?? '')),
                          DataCell(SelectableText(e['POFirst'] ?? '')),
                          DataCell(SelectableText(e['remark'] ?? '')),
                        ],
                      );
                    }).toList(),
                  ),
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
    return TextField(
      autofocus: true,
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
