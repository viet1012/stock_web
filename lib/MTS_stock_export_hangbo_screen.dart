import 'package:flutter/material.dart';
import 'package:stock_web/widgets/custom_button.dart';

class MTSStockExportHangBoForm extends StatefulWidget {
  const MTSStockExportHangBoForm({super.key});

  @override
  State<MTSStockExportHangBoForm> createState() =>
      _MTSStockExportHangBoFormState();
}

class _MTSStockExportHangBoFormState extends State<MTSStockExportHangBoForm> {
  String selectedAction = 'CheckBox';
  final TextEditingController orderItoScanController = TextEditingController();
  final TextEditingController changeBlankController = TextEditingController();

  // Left section
  final TextEditingController leftOrderController = TextEditingController();
  final TextEditingController leftProductIdController = TextEditingController();
  final TextEditingController leftTQtyController = TextEditingController();
  final TextEditingController leftBoxIdStockController =
      TextEditingController();
  final TextEditingController leftShelfIdWaitController =
      TextEditingController();
  final TextEditingController leftBoxIdConfirmController =
      TextEditingController();

  // Right section
  final TextEditingController rightOrderController = TextEditingController();
  final TextEditingController rightProductIdController =
      TextEditingController();
  final TextEditingController rightP0QtyController = TextEditingController();
  final TextEditingController rightIdBoxStockController =
      TextEditingController();
  final TextEditingController rightShelfIdController = TextEditingController();
  final TextEditingController rightTQtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Main Content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Section
                Expanded(child: _buildLeftSection()),

                // Divider
                Container(width: 2, color: Colors.black),

                // Right Section
                Expanded(child: _buildRightSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'MSNV: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '20616',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'QUẢN LÝ XUẤT KHO STOCK HÀNG BỘ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Controls
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xác nhận lấy hàng xuất kho',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Chọn thao tác
                Row(
                  children: [
                    const SizedBox(width: 120, child: Text('+ Chọn thao tác:')),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: selectedAction,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        items: ['CheckBox', 'Other'].map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedAction = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // OrderIto Scan
                Row(
                  children: [
                    const SizedBox(width: 120, child: Text('+ OrderIto Scan:')),
                    Expanded(
                      child: TextField(
                        controller: orderItoScanController,
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
                const SizedBox(height: 8),

                // Change blank
                Row(
                  children: [
                    const SizedBox(width: 120, child: Text('+ Change blank:')),
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

                // Exit Button
                SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Thoát (Exit)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Form Fields
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildLabelValueRow(
                  '+ OrderIto :',
                  leftOrderController,
                  'Orderno',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildLabelValueRow(
                  '+ ProductID :',
                  leftProductIdController,
                  'ProductID',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildLabelValueRow(
                  '+ TQty :',
                  leftTQtyController,
                  'TQty',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildLabelValueRow(
                  '+ BoxIDStock :',
                  leftBoxIdStockController,
                  'BoxIdStock',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabelValueRow(
                        '+ ShelfIDWait :',
                        leftShelfIdWaitController,
                        'ShelfIDWait',
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Box Qty :'),
                    const SizedBox(width: 8),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildLabelInputRow(
                  '+ BoxIDConfirm:',
                  leftBoxIdConfirmController,
                ),
              ],
            ),
          ),

          // Table
          Expanded(
            child: _buildTable(
              headers: [
                'SPCNo',
                'PartID',
                'QtyPO',
                'QtyInOu',
                'ShelfIDWait',
                'BoxIDStock',
                'StatusCl',
                'BoxIDCo',
                'PName',
                'Remark',
              ],
              data: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Label
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kiểm tra, xác nhận box cần lấy',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                _buildLabelValueRow(
                  '+ OrderIto :',
                  rightOrderController,
                  'Orderno',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabelValueRow(
                        '+ ProductID :',
                        rightProductIdController,
                        'ProductID',
                        Colors.purple,
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
                const SizedBox(height: 8),
                _buildLabelValueRow(
                  '+ P0Qty :',
                  rightP0QtyController,
                  'lbiP0Qty',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildLabelValueRow(
                  '+ IDBoxStock :',
                  rightIdBoxStockController,
                  'lblIBBoxStock',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildLabelValueRow(
                  '+ ShelfID :',
                  rightShelfIdController,
                  'lblshelfID',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabelInputRow(
                        '+ TQty :',
                        rightTQtyController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('+ Remain :'),
                    const SizedBox(width: 8),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Button
                SizedBox(
                  width: 130,
                  child: CustomButton(
                    label: 'Đưa hàng lên kệ',
                    color: Colors.green,
                    icon: Icons.transfer_within_a_station_rounded,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Table
          Expanded(
            child: _buildTable(
              headers: ['Firsttime', 'BoxID', 'QtyStock', 'CheckSt', 'ShelfID'],
              data: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(
    String label,
    TextEditingController controller,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelInputRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label)),
        Expanded(
          child: TextField(
            controller: controller,
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

  Widget _buildTable({
    required List<String> headers,
    required List<Map<String, dynamic>> data,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Row(
              children: headers.map((header) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: headers.last == header
                              ? Colors.transparent
                              : Colors.black,
                          width: 1,
                        ),
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
                              bottom: BorderSide(color: Colors.black, width: 1),
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
                                        color: headers.last == header
                                            ? Colors.transparent
                                            : Colors.black,
                                        width: 1,
                                      ),
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
          ),
        ],
      ),
    );
  }
}
