import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_web/widgets/custom_button.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final TextEditingController _boxIdConfirmController = TextEditingController();
  final TextEditingController _qtyActualController = TextEditingController();

  String _selectedCondition = 'By Shelf';
  String _selectedRange = '1 tháng'; // mặc định
  final TextEditingController _conditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeftPanel(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCenterPanel()),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBottomTables()),
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text(
                'TỔNG: 0   ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              Text(
                'Đã kiểm: 0   ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                'Còn lại: 0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // LEFT PANEL
  Widget _buildLeftPanel() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(14),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Điều kiện kiểm kê',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          const Text('Chọn điều kiện:'),
          const SizedBox(height: 4),

          // 🔹 Dropdown chọn loại điều kiện
          DropdownButtonFormField<String>(
            value: _selectedCondition,
            items: const [
              DropdownMenuItem(value: 'By Shelf', child: Text('By Shelf')),
              DropdownMenuItem(value: 'By Name', child: Text('By Name')),
              DropdownMenuItem(value: 'All', child: Text('All')),
            ],
            onChanged: (val) {
              setState(() {
                _selectedCondition = val!;
                _conditionController
                    .clear(); // reset ô nhập mỗi khi đổi điều kiện
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Hiện ô nhập nếu không phải "All"
          if (_selectedCondition == 'By Shelf' ||
              _selectedCondition == 'By Name') ...[
            Text(
              _selectedCondition == 'By Shelf'
                  ? 'Nhập tên kệ:'
                  : 'Nhập tên hàng:',
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _conditionController,
              decoration: InputDecoration(
                hintText: _selectedCondition == 'By Shelf'
                    ? 'Ví dụ: Kệ A1'
                    : 'Ví dụ: Hoa hồng',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // 🔹 Dropdown chọn khoảng thời gian
          const Text('Khoảng thời gian:'),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: _selectedRange,
            items: const [
              DropdownMenuItem(value: '1 tuần', child: Text('1 tuần')),
              DropdownMenuItem(value: '1 tháng', child: Text('1 tháng')),
              DropdownMenuItem(value: '3 tháng', child: Text('3 tháng')),
              DropdownMenuItem(value: '6 tháng', child: Text('6 tháng')),
            ],
            onChanged: (val) => setState(() => _selectedRange = val!),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Xóa',
                  color: Colors.red.shade600,
                  icon: Icons.delete_forever,
                  onPressed: () => setState(() => _conditionController.clear()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  label: 'Thực hiện',
                  color: Colors.blue,
                  width: double.infinity,
                  icon: Icons.play_arrow,
                  onPressed: () {
                    print('Điều kiện: $_selectedCondition');
                    print('Giá trị nhập: ${_conditionController.text}');
                    print('Khoảng thời gian: $_selectedRange');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // CENTER PANEL
  Widget _buildCenterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputRow(),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          _buildLabelRow('BoxId:', 'PName:', 'PId:'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Input Qty Actual:',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 140,
                    child: TextField(
                      controller: _qtyActualController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Danh sách Box cần lấy khỏi kê (NG)',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 150,
                child: CustomButton(
                  label: 'Làm mới',
                  color: Colors.blue,
                  width: double.infinity,
                  icon: Icons.refresh,
                  onPressed: () {
                    print('Điều kiện: $_selectedCondition');
                    print('Giá trị nhập: ${_conditionController.text}');
                    print('Khoảng thời gian: $_selectedRange');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        const Text(
          '+ BoxID Confirm: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 500,
          child: TextField(
            controller: _boxIdConfirmController,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelRow(String a, String b, String c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          a,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          b,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          c,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // BOTTOM TABLES
  Widget _buildBottomTables() {
    return Row(
      children: [
        Expanded(child: _buildDataTable(title: 'Danh sách kiểm kê')),
        const SizedBox(width: 10),
        Expanded(child: _buildDataTable(title: 'Danh sách NG')),
      ],
    );
  }

  Widget _buildDataTable({required String title}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _panelDecoration(),

      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
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
                columnSpacing: 80,
                columns: const [
                  DataColumn(label: Text('STT')),
                  DataColumn(label: Text('BoxID')),
                  DataColumn(label: Text('PID')),
                  DataColumn(label: Text('PName')),
                  DataColumn(label: Text('StatusCheck')),
                  DataColumn(label: Text('DateInventory')),
                  DataColumn(label: Text('ShelfID')),
                ],
                rows: const [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
