import 'package:flutter/material.dart';

import '../Data/mock_inventory_data.dart';

class ConfirmShelfScreen extends StatefulWidget {
  const ConfirmShelfScreen({super.key});

  @override
  State<ConfirmShelfScreen> createState() => _ConfirmShelfScreenState();
}

class _ConfirmShelfScreenState extends State<ConfirmShelfScreen> {
  final TextEditingController _boxController = TextEditingController();
  final TextEditingController _shelfController = TextEditingController();
  bool isValidBox = false;

  Map<String, dynamic>? _matchedBox;

  void _onScanBox(String boxId) {
    final scanned = boxId.trim().toUpperCase();

    // Tìm BoxID trong danh sách tồn kho
    final allBoxes = MockInventoryData.getAllBoxes();
    final box = allBoxes.firstWhere(
      (b) => b['BoxID'].toString().toUpperCase() == scanned,
      orElse: () => {},
    );

    if (box.isNotEmpty && box['CheckSt'] == 'OK') {
      setState(() {
        isValidBox = true;
        _matchedBox = box;
        _shelfController.text = box['ShelfID'];
      });
    } else {
      setState(() {
        isValidBox = false;
        _matchedBox = null;
        _shelfController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Box không hợp lệ hoặc chưa tồn tại!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onConfirm() {
    final boxId = _boxController.text.trim().toUpperCase();
    final shelfId = _shelfController.text.trim();

    if (!isValidBox || boxId.isEmpty || shelfId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng quét BoxID hợp lệ trước khi in tem!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ In tem thành công: Box $boxId → Kệ $shelfId'),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Gọi API hoặc cập nhật DB ở đây
  }

  Widget _buildShelfInfoCard() {
    if (_matchedBox == null) return const SizedBox.shrink();

    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📌 Thông tin kệ chờ:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('ShelfID: ${_matchedBox!['ShelfID']}'),
            Text('POCode: ${_matchedBox!['POCode']}'),
            Text('QtyStock: ${_matchedBox!['QtyStock']}'),
            Text('CheckSt: ${_matchedBox!['CheckSt']}'),
            // Có thể thêm số thứ tự kệ hoặc vị trí nếu có trong dữ liệu
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allowedBoxes = MockInventoryData.getAllBoxes()
        .where((b) => b['CheckSt'] == 'OK')
        .map((b) => b['BoxID'].toString())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận kệ & In tem'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📦 Danh sách Box hợp lệ:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(allowedBoxes.join(', ')),
            const SizedBox(height: 20),

            TextField(
              controller: _boxController,
              decoration: const InputDecoration(
                labelText: 'Nhập hoặc quét BoxID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code_scanner),
              ),
              onSubmitted: _onScanBox,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _shelfController,
              decoration: const InputDecoration(
                labelText: 'Kệ chờ (tự điền nếu quét BoxID)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shelves),
              ),
              readOnly: true,
            ),

            _buildShelfInfoCard(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _onConfirm,
                icon: const Icon(Icons.print),
                label: const Text('Xác nhận & In tem'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
