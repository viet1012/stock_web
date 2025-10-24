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
            const Text(
              'MSNV: ',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Text(
              '20616',
              style: TextStyle(
                fontSize: 14,
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
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                const Text(
                  'QUẢN LÝ XUẤT KHO STOCK MTS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '(Bước 01)',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  'Xác nhận lấy hàng xuất kho',
                  style: TextStyle(
                    fontSize: 14,
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
                // Left Section
                Expanded(child: _buildLeftSection()),

                // Right Section
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
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
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Phân Loại:')),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        items: ['MTO', 'MTS'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('Chọn Thao Tác:')),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedAction,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        items: ['CheckBox', 'Other'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAction = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('+ OrderIto Scan:')),
                    Expanded(
                      child: TextField(
                        controller: orderIdController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('+ Change Blank:')),
                    Expanded(
                      child: TextField(
                        controller: changeBlankController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('Xóa (Clear)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Thoát (Exit)'),
                      ),
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
                    Expanded(
                      child: _buildFormRow('Box Qty :', leftBoxQtyController),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFormRow(
                        '+ BoxIDConfirm:',
                        leftBoxIdConfirmController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.green[700]),
            child: const Text(
              'Danh sách đơn hàng chờ xuất kho:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Table
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Top Section
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFormRow('+ OrderIto :', rightOrderController),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormRow(
                        '+ ProductID :',
                        rightProductIdController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildFormRow('+ P0Qty :', rightP0QtyController),
                _buildFormRow('+ IDBoxStock :', rightIdBoxStockController),
                _buildFormRow('+ ShelfID :', rightShelfIdController),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormRow('+ TQty :', rightTQtyController),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          const Text('+ Remain : '),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.purple[200]!),
                            ),
                            child: const Text(
                              '0',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Đưa Hàng Lên Kệ Chờ'),
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.green[700]),
            child: const Text(
              'Danh sách hàng đang có trong kho:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Table
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

  Widget _buildFormRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
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
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
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
          // Table Header
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Table Body (Empty State)
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: data.isEmpty
                  ? const Center(
                      child: Text(
                        'Chưa có dữ liệu',
                        style: TextStyle(color: Colors.black54),
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
                                      right: BorderSide(
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    data[index][header]?.toString() ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
