import 'package:flutter/material.dart';

class BoxManagementScreen extends StatefulWidget {
  const BoxManagementScreen({Key? key}) : super(key: key);

  @override
  State<BoxManagementScreen> createState() => _BoxManagementScreenState();
}

class _BoxManagementScreenState extends State<BoxManagementScreen> {
  final TextEditingController _boxIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _partIdController = TextEditingController();
  final TextEditingController _lotNoController = TextEditingController();
  final TextEditingController _quantityDetailController =
      TextEditingController();
  final TextEditingController _confirmBoxIdController = TextEditingController();

  List<Map<String, dynamic>> tableData = [];

  @override
  void dispose() {
    _boxIdController.dispose();
    _quantityController.dispose();
    _productNameController.dispose();
    _partIdController.dispose();
    _lotNoController.dispose();
    _quantityDetailController.dispose();
    _confirmBoxIdController.dispose();
    super.dispose();
  }

  void _addRow() {
    if (_quantityController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập Số đơn hàng');
      return;
    }

    setState(() {
      tableData.add({
        'SPCNo': tableData.length + 1,
        'POQty': _quantityController.text,
        'PName': _productNameController.text,
        'PartID': _partIdController.text,
        'InDateTime': DateTime.now().toString().split('.')[0],
        'BoxWait': _lotNoController.text,
      });
    });
    _quantityController.clear();
  }

  void _clearAll() {
    setState(() {
      tableData.clear();
      _boxIdController.clear();
      _quantityController.clear();
      _productNameController.clear();
      _partIdController.clear();
      _lotNoController.clear();
      _quantityDetailController.clear();
      _confirmBoxIdController.clear();
    });
    _showSnackBar('Đã xóa tất cả dữ liệu');
  }

  void _deleteRow(int index) {
    setState(() {
      tableData.removeAt(index);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,

        elevation: 0,
        title: const Text(
          'PHÂN LOẠI HÀNG ĐƯA VÀO BOX',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel
              Expanded(flex: 1, child: Column(children: [_buildLeftPanel()])),
              const SizedBox(width: 24),
              // Middle Panel
              Expanded(flex: 2, child: _buildMiddlePanel()),
              const SizedBox(width: 24),
              // Right Panel
              Expanded(flex: 1, child: _buildRightPanel()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Column(
      children: [
        // Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'MSNV: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF5A6C7D),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '20616',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LẤY HÀNG RA KỆ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color(0xFF6A1B9A),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('BOX ID'),
              const SizedBox(height: 8),
              _buildTextField(_boxIdController),
              const SizedBox(height: 16),
              _buildButton(
                label: 'Clear All',
                onPressed: _clearAll,
                backgroundColor: const Color(0xFFECEFF1),
                textColor: const Color(0xFFD32F2F),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Input Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF59D),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: const Text(
                  'Danh sách đã nhập',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color(0xFF5A4A00),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabelWithIcon('Số đơn hàng'),
              const SizedBox(height: 8),
              _buildTextField(_quantityController),
              const SizedBox(height: 12),
              _buildLabelWithIcon('Box Number'),
              const SizedBox(height: 8),
              _buildTextField(_lotNoController),
              const SizedBox(height: 16),
              _buildButton(
                label: 'Thêm',
                onPressed: _addRow,
                backgroundColor: const Color(0xFF1565C0),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiddlePanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin đơn hàng',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoField('Số đơn hàng', _quantityController),
          const SizedBox(height: 12),
          _buildInfoField('Tên hàng', _productNameController),
          const SizedBox(height: 12),
          _buildInfoField('Mã SP', _partIdController),
          const SizedBox(height: 12),
          _buildInfoField('LotNo', _lotNoController),
          const SizedBox(height: 12),
          _buildInfoField('Số lượng', _quantityDetailController),
          const SizedBox(height: 24),
          if (tableData.isNotEmpty) ...[
            const Divider(color: Color(0xFFECEFF1)),
            const SizedBox(height: 16),
            const Text(
              'Danh sách chi tiết',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            _buildDataTable(),
          ],
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF59D),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: const Text(
              'XÁC NHẬN FULL BOX',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF5A4A00),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLabel('BOX ID'),
          const SizedBox(height: 8),
          _buildTextField(_confirmBoxIdController),
          const SizedBox(height: 20),
          _buildButton(
            label: 'XÁC NHẬN',
            icon: Icons.check_circle,
            onPressed: () {
              _showSnackBar('Box đã được xác nhận!');
            },
            backgroundColor: const Color(0xFF1565C0),
            textColor: Colors.white,
            isFullWidth: true,
          ),
          const SizedBox(height: 10),
          _buildButton(
            label: 'Xóa',
            icon: Icons.refresh,
            onPressed: _clearAll,
            backgroundColor: const Color(0xFFECEFF1),
            textColor: const Color(0xFF424242),
            isFullWidth: true,
          ),
          const SizedBox(height: 10),
          _buildButton(
            label: 'Thoát',
            icon: Icons.logout,
            onPressed: () {},
            backgroundColor: const Color(0xFFD32F2F),
            textColor: Colors.white,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xFF5A6C7D),
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildLabelWithIcon(String text) {
    return Row(
      children: [
        const Text(
          '+ ',
          style: TextStyle(
            color: Color(0xFF6A1B9A),
            fontWeight: FontWeight.w700,
          ),
        ),
        _buildLabel(text),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '+ ',
              style: TextStyle(
                color: Color(0xFFCCCC00),
                fontWeight: FontWeight.w700,
              ),
            ),
            _buildLabel(label),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextField(controller),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    bool isFullWidth = false,
  }) {
    Widget button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon, color: textColor, size: 18)
          : const SizedBox.shrink(),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        headingRowColor: MaterialStateColor.resolveWith(
          (_) => const Color(0xFFF5F5F5),
        ),
        dataRowColor: MaterialStateColor.resolveWith((_) => Colors.white),
        columns: const [
          DataColumn(
            label: Text(
              'SPCNo',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          DataColumn(
            label: Text(
              'POQty',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          DataColumn(
            label: Text(
              'Product Name',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          DataColumn(
            label: Text(
              'PartID',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          DataColumn(
            label: Text(
              'DateTime',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          DataColumn(
            label: Text(
              'Action',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
        rows: tableData.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> data = entry.value;
          return DataRow(
            cells: [
              DataCell(Text(data['SPCNo'].toString())),
              DataCell(Text(data['POQty'].toString())),
              DataCell(Text(data['PName'].toString())),
              DataCell(Text(data['PartID'].toString())),
              DataCell(Text(data['InDateTime'].toString())),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                  iconSize: 18,
                  onPressed: () => _deleteRow(index),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
