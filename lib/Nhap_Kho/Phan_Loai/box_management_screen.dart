import 'package:flutter/material.dart';
import 'package:stock_web/widgets/custom_button.dart';

import '../../Data/mock_data.dart';

class OrderItem {
  final String No;
  final String poQty;
  final String pName;
  final String partID;
  final String inDateTime;
  final String boxWait;

  OrderItem({
    required this.No,
    required this.poQty,
    required this.pName,
    required this.partID,
    required this.inDateTime,
    required this.boxWait,
  });
}

class BoxManagementScreen extends StatefulWidget {
  const BoxManagementScreen({super.key});

  @override
  State<BoxManagementScreen> createState() => _BoxManagementScreenState();
}

class _BoxManagementScreenState extends State<BoxManagementScreen> {
  final TextEditingController _boxIdController = TextEditingController();
  final TextEditingController _sodonhangController = TextEditingController();
  final TextEditingController _boxNumberController = TextEditingController();
  final TextEditingController _confirmBoxIdController = TextEditingController();

  final FocusNode _boxFocusNode = FocusNode();

  late List<OrderItem> _orderItems;
  Map<String, dynamic>? _selectedOrder;

  @override
  void initState() {
    super.initState();
    _orderItems = [];
  }

  void _fetchOrder(String po) {
    final key = po.trim().toUpperCase();
    if (mockOrderData.containsKey(key)) {
      setState(() => _selectedOrder = mockOrderData[key]);
      Future.delayed(const Duration(milliseconds: 200), () {
        FocusScope.of(context).requestFocus(_boxFocusNode);
      });
    } else {
      setState(() => _selectedOrder = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Không tìm thấy đơn hàng "$po"')),
      );
    }
  }

  void _addOrderItem() {
    if (_selectedOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Vui lòng nhập PO hợp lệ')),
      );
      return;
    }

    if (_boxNumberController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('⚠️ Nhập số Box')));
      return;
    }

    setState(() {
      _orderItems.add(
        OrderItem(
          No: (_orderItems.length + 1).toString().padLeft(3, '0'),
          poQty: _sodonhangController.text,
          pName: _selectedOrder!['product'],
          partID: _selectedOrder!['code'],
          inDateTime: DateTime.now().toString().split('.')[0],
          boxWait: _boxNumberController.text,
        ),
      );
      _boxNumberController.clear();
      _sodonhangController.clear();
      _selectedOrder = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Đã thêm vào danh sách nhập tem box')),
    );
  }

  @override
  void dispose() {
    _boxIdController.dispose();
    _sodonhangController.dispose();
    _boxNumberController.dispose();
    _confirmBoxIdController.dispose();
    _boxFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildHeaderBar(),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isNarrow = constraints.maxWidth < 1100;
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: isNarrow ? double.infinity : 320,
                          child: _buildLeftPanel(),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: isNarrow
                                  ? double.infinity
                                  : constraints.maxWidth - 680,
                              child: _buildMiddlePanel(),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: isNarrow
                                  ? double.infinity
                                  : constraints.maxWidth - 680,
                              child: _buildBottomTable(),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: isNarrow ? double.infinity : 320,
                          child: _buildRightPanel(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('MSNV: 9999', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            'PHÂN LOẠI HÀNG ĐƯA VÀO BOX CHỜ',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
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

  Widget _buildLeftPanel() {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('NHẬP ĐƠN HÀNG', Icons.assignment, Colors.teal),
          const SizedBox(height: 10),
          TextField(
            controller: _sodonhangController,
            onSubmitted: _fetchOrder,
            decoration: InputDecoration(
              labelText: 'Nhập số đơn hàng (VD: ODR1001)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              prefixIcon: const Icon(Icons.receipt_long),
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedOrder != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên hàng: ${_selectedOrder!['product']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Mã SP: ${_selectedOrder!['code']}'),
                  Text('Lot: ${_selectedOrder!['lot']}'),
                  Text('Trọng lượng: ${_selectedOrder!['weight']}'),
                  const SizedBox(height: 8),
                  const Text(
                    'Box trống:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    children: (_selectedOrder!['emptyBoxes'] as List<String>)
                        .map((b) => Chip(label: Text(b)))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _boxNumberController,
              focusNode: _boxFocusNode,
              onSubmitted: (_) => _addOrderItem(),
              decoration: InputDecoration(
                labelText: 'Nhập BOX cần thêm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: const Icon(Icons.inventory_2),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: 'Thêm vào danh sách',
              color: Colors.blue,
              icon: Icons.add,
              width: double.infinity, // full width như cũ
              onPressed: _addOrderItem,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiddlePanel() {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('THÔNG TIN ĐƠN HÀNG', Icons.info, Colors.green),
          const SizedBox(height: 12),
          if (_selectedOrder != null) ...[
            _buildInfoRow('Tên hàng', _selectedOrder!['product']),
            _buildInfoRow('Mã SP', _selectedOrder!['code']),
            _buildInfoRow('Lot', _selectedOrder!['lot']),
            _buildInfoRow('Trọng lượng', _selectedOrder!['weight']),
          ] else
            const Text('Chưa có đơn hàng nào được chọn'),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      decoration: _panelStyle(color: const Color(0xFFFFFAF0)),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionTitle('XÁC NHẬN FULL BOX', Icons.verified, Colors.green),
          const SizedBox(height: 18),
          _buildLabeledTextField(
            'BOX ID',
            _confirmBoxIdController,
            Icons.qr_code_2,
          ),
          const SizedBox(height: 18),
          CustomButton(
            label: 'XÁC NHẬN',
            color: Colors.green,
            icon: Icons.check_circle,
            width: double.infinity,
            onPressed: () {
              if (_confirmBoxIdController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Box ${_confirmBoxIdController.text} đã được xác nhận!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTable() {
    return Container(
      decoration: _panelStyle(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Danh sách đơn hàng đang chờ nhập tem box:',
            style: TextStyle(
              color: Color(0xFF1E40AF),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(height: 400, child: _buildDataTable()),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (_) => Colors.grey.shade200,
        ),
        headingTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        dataRowHeight: 32,
        headingRowHeight: 34,
        dividerThickness: 0.6,
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('POQty')),
          DataColumn(label: Text('PName')),
          DataColumn(label: Text('PartID')),
          DataColumn(label: Text('InDateTime')),
          DataColumn(label: Text('BoxWait')),
        ],
        rows: _orderItems.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return DataRow(
            color: MaterialStateProperty.resolveWith(
              (_) => i.isEven ? Colors.white : Colors.grey.shade50,
            ),
            cells: [
              DataCell(Text(item.No)),
              DataCell(Text(item.poQty)),
              DataCell(Text(item.pName)),
              DataCell(Text(item.partID)),
              DataCell(Text(item.inDateTime.split(' ')[0])),
              DataCell(Text(item.boxWait)),
            ],
          );
        }).toList(),
      ),
    );
  }

  BoxDecoration _panelStyle({Color? color}) {
    return BoxDecoration(
      color: color ?? Colors.white,
      border: Border.all(color: Colors.grey.shade300),
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

  Widget _buildLabeledTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: Colors.grey[600]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
