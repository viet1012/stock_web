import 'package:flutter/material.dart';
import 'package:stock_web/widgets/custom_button.dart';

class OrderItem {
  final String spCNo;
  final String poQty;
  final String pName;
  final String partID;
  final String inDateTime;
  final String boxWait;

  OrderItem({
    required this.spCNo,
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

  late List<OrderItem> _orderItems;
  late Map<String, String> _orderInfo;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    _orderInfo = {
      'Số đơn hàng': 'DH-2024-001',
      'Tên hàng': 'Linh kiện điện tử A',
      'Mã SP': 'SP-123456',
      'Lot No': 'LOT-2024-Q1',
      'Số lượng': '100',
    };

    _orderItems = [
      OrderItem(
        spCNo: '001',
        poQty: '50',
        pName: 'Resistor 1K',
        partID: 'RES-001',
        inDateTime: '2024-01-15 10:30',
        boxWait: '5',
      ),
      OrderItem(
        spCNo: '002',
        poQty: '30',
        pName: 'Capacitor 100uF',
        partID: 'CAP-002',
        inDateTime: '2024-01-15 11:15',
        boxWait: '3',
      ),
      OrderItem(
        spCNo: '003',
        poQty: '20',
        pName: 'Diode 1N4007',
        partID: 'DIO-003',
        inDateTime: '2024-01-15 12:00',
        boxWait: '2',
      ),
    ];
  }

  @override
  void dispose() {
    _boxIdController.dispose();
    _sodonhangController.dispose();
    _boxNumberController.dispose();
    _confirmBoxIdController.dispose();
    super.dispose();
  }

  void _addOrderItem() {
    if (_sodonhangController.text.isEmpty ||
        _boxNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _orderItems.add(
        OrderItem(
          spCNo: (_orderItems.length + 1).toString().padLeft(3, '0'),
          poQty: _sodonhangController.text,
          pName: 'Sản phẩm mới',
          partID: 'PART-${DateTime.now().millisecondsSinceEpoch}',
          inDateTime: DateTime.now().toString().split('.')[0],
          boxWait: _boxNumberController.text,
        ),
      );
      _sodonhangController.clear();
      _boxNumberController.clear();
    });
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
                  // Nếu nhỏ hơn 1100px → hiển thị dọc
                  bool isNarrow = constraints.maxWidth < 1100;

                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: [
                        SizedBox(
                          width: isNarrow ? double.infinity : 280,
                          child: _buildLeftPanel(),
                        ),
                        SizedBox(
                          width: isNarrow
                              ? double.infinity
                              : constraints.maxWidth - 580, // chừa 2 panel biên
                          child: _buildMiddlePanel(),
                        ),
                        SizedBox(
                          width: isNarrow ? double.infinity : 280,
                          child: _buildRightPanel(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildBottomTable(),
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
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'MSNV: 20616',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            'PHÂN LOẠI HÀNG ĐƯA VÀO BOX CHỜ',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'XÁC NHẬN FULL BOX',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
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
        children: [
          _buildSectionTitle(
            'LẤY HÀNG RA KỆ',
            Icons.inventory_2,
            Colors.orange,
          ),
          const SizedBox(height: 20),
          _buildLabeledTextField('BOX ID', _boxIdController, Icons.qr_code),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Xóa tất cả',
            color: Colors.redAccent,
            icon: Icons.clear_all,
            width: double.infinity,
            radius: 6,
            fontSize: 13,
            onPressed: () {
              _boxIdController.clear();
              _sodonhangController.clear();
              _boxNumberController.clear();
            },
          ),
          const Divider(height: 30),
          _buildLabeledTextField(
            'Số đơn hàng',
            _sodonhangController,
            Icons.receipt_long,
          ),
          const SizedBox(height: 10),
          _buildLabeledTextField(
            'Số Box chờ',
            _boxNumberController,
            Icons.inventory,
          ),
          const SizedBox(height: 10),
          CustomButton(
            label: 'Thêm hàng',
            color: Colors.blue,
            icon: Icons.add_box,
            width: double.infinity,
            radius: 6,
            fontSize: 13,
            onPressed: _addOrderItem,
          ),
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
          const SizedBox(height: 16),
          ..._orderInfo.entries.map((e) => _buildInfoRow(e.key, e.value)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.list_alt, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Đã nhập: ${_orderItems.length} hàng',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
            radius: 6,
            fontSize: 13,
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
          const SizedBox(height: 10),
          CustomButton(
            label: 'Xóa',
            color: Colors.grey,
            icon: Icons.delete_outline,
            width: double.infinity,
            radius: 6,
            fontSize: 13,
            onPressed: _confirmBoxIdController.clear,
          ),
          const SizedBox(height: 10),
          CustomButton(
            label: 'Thoát',
            color: Colors.red,
            icon: Icons.exit_to_app,
            width: double.infinity,
            radius: 6,
            fontSize: 13,
            onPressed: () => Navigator.pop(context),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
        columnSpacing: 150,
        headingRowColor: MaterialStateColor.resolveWith(
          (_) => Colors.grey.shade200,
        ),
        headingTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        dataRowHeight: 32,
        headingRowHeight: 34,
        dividerThickness: 0.6,
        columns: const [
          DataColumn(label: Text('SPCNo')),
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
              DataCell(Text(item.spCNo)),
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
      borderRadius: BorderRadius.circular(6),
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
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 12,
          ),
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
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
          style: const TextStyle(fontSize: 13),
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
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
