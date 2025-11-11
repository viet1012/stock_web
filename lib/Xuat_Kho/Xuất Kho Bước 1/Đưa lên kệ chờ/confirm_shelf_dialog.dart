import 'package:flutter/material.dart';

class ConfirmShelfDialog extends StatefulWidget {
  final List<Map<String, dynamic>> orderWaitList;
  final void Function(List<Map<String, dynamic>> updatedOrderWaitList)
  onUpdate; // Callback trả về dữ liệu sau cập nhật

  const ConfirmShelfDialog({
    Key? key,
    required this.orderWaitList,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ConfirmShelfDialog> createState() => _ConfirmShelfDialogState();
}

class _ConfirmShelfDialogState extends State<ConfirmShelfDialog> {
  final TextEditingController boxConfirmController = TextEditingController();
  final TextEditingController shelfConfirmController = TextEditingController();

  // Hàm show message (bạn có thể tùy chỉnh hoặc truyền callback riêng)
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _tryUpdateShelfWait() {
    final boxId = boxConfirmController.text.trim();
    final shelf = shelfConfirmController.text.trim();

    if (boxId.isEmpty || shelf.isEmpty) {
      _showMessage('⚠️ Vui lòng nhập đủ Mã Box và Mã Kệ Chờ!');
      return;
    }

    final poIndex = widget.orderWaitList.indexWhere(
      (po) => po['BoxIDStock'] == boxId,
    );
    if (poIndex == -1) {
      _showMessage('❌ Không tìm thấy PO có BoxID này!');
      return;
    }

    setState(() {
      widget.orderWaitList[poIndex]['ShelfIDWait'] = shelf;
    });

    _showMessage('✅ Cập nhật thành công kệ chờ: $shelf');

    // Gọi callback trả về dữ liệu đã cập nhật
    widget.onUpdate(widget.orderWaitList);

    // Đóng dialog
    Navigator.of(context).pop();

    // Clear input sau khi đóng
    boxConfirmController.clear();
    shelfConfirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Xác nhận kệ chờ cho Box',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: boxConfirmController,
              decoration: InputDecoration(
                labelText: 'Mã Box (Ví dụ: VT1012)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.inventory),
              ),
              onSubmitted: (_) => _tryUpdateShelfWait(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: shelfConfirmController,
              decoration: InputDecoration(
                labelText: 'Mã kệ chờ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.warehouse),
              ),
              onSubmitted: (_) => _tryUpdateShelfWait(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _tryUpdateShelfWait,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          label: const Text(
            'Cập nhật kệ chờ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
