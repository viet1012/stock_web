import 'package:flutter/material.dart';
import 'package:stock_web/widgets/action_button.dart';
import 'package:stock_web/widgets/custom_button.dart';

class StockExportForm extends StatefulWidget {
  const StockExportForm({super.key});

  @override
  State<StockExportForm> createState() => _StockExportFormState();
}

class _StockExportFormState extends State<StockExportForm> {
  String selectedAction = 'CheckBox';

  final TextEditingController orderNoScanController = TextEditingController();
  final TextEditingController changeBlankController = TextEditingController();

  // Kiểm tra box cần lấy
  final TextEditingController orderNoConfirmController =
      TextEditingController();
  final TextEditingController productIdConfirmController =
      TextEditingController();
  final TextEditingController poQtyConfirmController = TextEditingController();
  final TextEditingController boxIdStockConfirmController =
      TextEditingController();
  final TextEditingController shelfIdConfirmController =
      TextEditingController();
  final TextEditingController tQtyConfirmController = TextEditingController();

  int boxQty = 0;
  int remainQty = 0;

  // Giả lập dữ liệu bảng
  List<Map<String, dynamic>> orderWaitList = [];
  List<Map<String, dynamic>> stockBoxList = [];

  @override
  void dispose() {
    orderNoScanController.dispose();
    changeBlankController.dispose();
    orderNoConfirmController.dispose();
    productIdConfirmController.dispose();
    poQtyConfirmController.dispose();
    boxIdStockConfirmController.dispose();
    shelfIdConfirmController.dispose();
    tQtyConfirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Dữ liệu mẫu cho bảng orderWaitList
    orderWaitList = List.generate(10, (index) {
      return {
        'No': index + 1,
        'PartID': 'P100${index + 1}',
        'QtyPO': 50 + index * 5,
        'QtyInOut': 30 + index * 3,
        'ShelfIDWait': 'S${100 + index}',
        'BoxIDStock': 'BX${200 + index}',
        'Status': index % 2 == 0 ? 'Đã duyệt' : 'Chờ',
        'BoxID': 'BID${300 + index}',
        'PName': 'Product ${index + 1}',
        'Remark': index % 3 == 0 ? 'Gấp' : '',
      };
    });

    // Dữ liệu mẫu cho bảng stockBoxList
    stockBoxList = List.generate(8, (index) {
      return {
        'Firsttime': '2025-11-${(index + 1).toString().padLeft(2, '0')} 08:00',
        'BoxID': 'BOX${500 + index}',
        'QtyStock': 100 + index * 10,
        'CheckSt': index % 2 == 0 ? 'OK' : 'Pending',
        'ShelfID': 'Shelf-${index + 1}',
      };
    });

    // Ví dụ số lượng box và remainQty cũng giả lập
    boxQty = 25;
    remainQty = 12;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // HEADER
              _buildHeaderBar(),

              const SizedBox(height: 8),

              // MAIN CONTENT: Left and Right parts
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildLeftPanel()),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _buildRightPanel()),
                  ],
                ),
              ),
            ],
          ),
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
            'XUẤT KHO BƯỚC 1',
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
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần chọn thao tác và nhập liệu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Chọn thao tác:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedAction,
                items: ['CheckBox', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() => selectedAction = val!);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Input OrderNo Scan
          _buildLabeledInput('+ OrderNo Scan:', orderNoScanController),

          const SizedBox(height: 8),

          // Input Change blank
          _buildLabeledInput('+ Change blank:', changeBlankController),

          const SizedBox(height: 16),

          // Buttons Row (2 buttons with equal width and spacing)
          Row(
            children: [
              CustomButton(
                label: 'Xóa PO',
                color: Colors.red.shade600,
                icon: Icons.delete_forever,
                width: 130,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              CustomButton(
                label: 'Thoát',
                color: Colors.grey.shade600,
                icon: Icons.exit_to_app,
                width: 130,
                onPressed: () {},
              ),
              Spacer(),

              // Box Qty label aligned right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Box Qty: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '$boxQty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Bảng danh sách đơn hàng chờ xuất kho với border-radius và shadow
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: _buildTable(
                columns: const [
                  'No',
                  'PartID',
                  'QtyPO',
                  'QtyInOut',
                  'ShelfIDWait',
                  'BoxIDStock',
                  'Status',
                  'BoxID',
                  'PName',
                  'Remark',
                ],
                rows: orderWaitList,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Phần nhập liệu xác nhận box cần lấy
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.grey[100],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildLabelValueRow(
                  'Kiểm tra, xác nhận box cần lấy',
                  isBold: true,
                  color: Colors.green[800],
                ),
                _buildLabeledInput(
                  '+ OrderNo :',
                  orderNoConfirmController,
                  width: 160,
                ),
                _buildLabeledInput(
                  '+ ProductID :',
                  productIdConfirmController,
                  width: 160,
                ),
                _buildLabeledInput(
                  '+ POQty :',
                  poQtyConfirmController,
                  width: 160,
                ),
                _buildLabeledInput(
                  '+ IDBoxStock :',
                  boxIdStockConfirmController,
                  width: 160,
                ),
                _buildLabeledInput(
                  '+ ShelfID :',
                  shelfIdConfirmController,
                  width: 160,
                ),
                Row(
                  children: [
                    _buildLabeledInput(
                      '+ TQty :',
                      tQtyConfirmController,
                      width: 120,
                    ),
                    const SizedBox(width: 12),
                    RichText(
                      text: TextSpan(
                        text: '+ Remain : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '$remainQty',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ActionButton(
                    label: 'Đưa lên kệ chờ',
                    color: Colors.grey[300]!,
                    icon: Icons.upload,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Bảng danh sách hàng đang có trong kho
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: _buildTable(
                columns: const [
                  'Firsttime',
                  'BoxID',
                  'QtyStock',
                  'CheckSt',
                  'ShelfID',
                ],
                rows: stockBoxList,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(String text, {bool isBold = false, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
          color: color ?? Colors.black,
        ),
      ),
    );
  }

  Widget _buildLabeledInput(
    String label,
    TextEditingController controller, {
    double width = 400,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: width,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable({
    required List<String> columns,
    required List<Map<String, dynamic>> rows,
  }) {
    return Column(
      children: [
        // Header row
        Container(
          color: Colors.grey[300],
          child: Row(
            children: columns.map((col) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  child: Text(
                    col,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Data rows
        Expanded(
          child: rows.isEmpty
              ? const Center(
                  child: Text(
                    'Chưa có dữ liệu',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: Row(
                        children: columns.map((col) {
                          return Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              child: Text(
                                row[col]?.toString() ?? '',
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
      ],
    );
  }
}
