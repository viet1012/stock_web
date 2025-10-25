import 'package:flutter/material.dart';

class MTSStockExportScreen extends StatefulWidget {
  const MTSStockExportScreen({super.key});

  @override
  State<MTSStockExportScreen> createState() => _MTSStockExportScreenState();
}

class _MTSStockExportScreenState extends State<MTSStockExportScreen> {
  String selectedType = 'MTO';
  String selectedAction = 'CheckBox';

  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController changeBlankController = TextEditingController();

  // Left section controllers
  final TextEditingController leftOrderController = TextEditingController();
  final TextEditingController leftProductIdController = TextEditingController();
  final TextEditingController leftTQtyController = TextEditingController();
  final TextEditingController leftBoxIdStockController =
      TextEditingController();
  final TextEditingController leftShelfIdWaitController =
      TextEditingController();
  final TextEditingController leftBoxQtyController = TextEditingController();
  final TextEditingController leftBoxIdConfirmController =
      TextEditingController();

  // Right section controllers
  final TextEditingController rightOrderController = TextEditingController();
  final TextEditingController rightProductIdController =
      TextEditingController();
  final TextEditingController rightP0QtyController = TextEditingController();
  final TextEditingController rightIdBoxStockController =
      TextEditingController();
  final TextEditingController rightShelfIdController = TextEditingController();
  final TextEditingController rightTQtyController = TextEditingController();
  final TextEditingController rightRemainController = TextEditingController();

  List<Map<String, dynamic>> leftTableData = [];
  List<Map<String, dynamic>> rightTableData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            const Text('MSNV: ', style: TextStyle(color: Colors.black87)),
            Text(
              '20616',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(4),
            color: Colors.white,
            child: Column(
              children: [
                const Text(
                  'QUẢN LÝ XUẤT KHO STOCK (Bước 01)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Xác nhận lấy hàng xuất kho',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildLeftSection()),
                Expanded(child: _buildRightSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          // Top Controls
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                _buildDropdownRow('Phân Loại:', selectedType, ['MTO', 'MTS'], (
                  val,
                ) {
                  setState(() => selectedType = val!);
                }),
                const SizedBox(height: 12),
                _buildDropdownRow(
                  'Chọn Thao Tác:',
                  selectedAction,
                  ['CheckBox', 'Other'],
                  (val) {
                    setState(() => selectedAction = val!);
                  },
                ),
                const SizedBox(height: 12),
                _buildFormRow('+ OrderIto Scan:', orderIdController),
                _buildFormRow('+ Change Blank:', changeBlankController),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildButton(
                      label: 'Xóa (Clear)',
                      color: Colors.grey[400]!,
                      textColor: Colors.black87,
                      onPressed: () {},
                    ),
                    _buildButton(
                      label: 'Thoát (Exit)',
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormRow('+ OrderIto :', leftOrderController),
                _buildFormRow('+ ProductID :', leftProductIdController),
                _buildFormRow('+ TQty :', leftTQtyController),
                _buildFormRow('+ BoxIDStock :', leftBoxIdStockController),
                _buildFormRow('+ ShelfIDWait :', leftShelfIdWaitController),
                Row(
                  children: [
                    _buildFormRow(
                      'Box Qty :',
                      leftBoxQtyController,
                      width: 150,
                    ),
                    const SizedBox(width: 8),
                    _buildFormRow(
                      '+ BoxIDConfirm:',
                      leftBoxIdConfirmController,
                      width: 180,
                    ),
                  ],
                ),
              ],
            ),
          ),

          _buildTableTitle('Danh sách đơn hàng chờ xuất kho:'),
          Expanded(
            child: _buildDataTable([
              'SPCNo',
              'PartID',
              'QtyPO',
              'QtyPOut',
              'ShelfIDWait',
              'BoxIDStock',
              'StatusD',
              'BoxIDCo',
              'PName',
              'Remark',
            ], leftTableData),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kiểm tra, xác nhận box cần lấy',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFormRow('+ OrderIto :', rightOrderController),
                Row(
                  children: [
                    _buildFormRow('+ ProductID :', rightProductIdController),
                    const SizedBox(width: 8),
                    const Text(
                      '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildFormRow('+ P0Qty :', rightP0QtyController),
                _buildFormRow('+ IDBoxStock :', rightIdBoxStockController),
                _buildFormRow('+ ShelfID :', rightShelfIdController),
                Row(
                  children: [
                    _buildFormRow('+ TQty :', rightTQtyController, width: 150),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Text('+ Remain :'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.purple[200]!),
                          ),
                          child: const Text(
                            '0',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildButton(
                  label: 'Đưa Hàng Lên Kệ Chờ',
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {},
                  paddingV: 14,
                ),
              ],
            ),
          ),

          _buildTableTitle('Danh sách hàng đang có trong kho:'),
          Expanded(
            child: _buildDataTable([
              'Firsttime',
              'BoxID',
              'QtyStock',
              'CheckSt',
              'ShelfID',
              'PID',
            ], rightTableData),
          ),
        ],
      ),
    );
  }

  // --- COMMON WIDGETS BELOW ---

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey[300]!),
  );

  Widget _buildDropdownRow(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label)),
        const SizedBox(width: 8),
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormRow(
    String label,
    TextEditingController controller, {
    double width = 200,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: width,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    double width = 150,
    double paddingV = 10,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(vertical: paddingV),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildTableTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.green[700],
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataTable(
    List<String> headers,
    List<Map<String, dynamic>> data,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.grey[200],
            child: Row(
              children: headers.map((header) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                    child: Text(
                      header,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Body
          Expanded(
            child: data.isEmpty
                ? Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'Chưa có dữ liệu',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[400]!),
                          ),
                        ),
                        child: Row(
                          children: headers.map((header) {
                            return Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.grey[400]!),
                                  ),
                                ),
                                child: Text(
                                  data[index][header]?.toString() ?? '',
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
}
