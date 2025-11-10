import 'package:flutter/material.dart';

class ConfirmBoxIdInput extends StatefulWidget {
  final List<Map<String, dynamic>> orderWaitList;
  final void Function(List<Map<String, dynamic>> updatedList) onUpdate;
  final void Function(String message) showMessage;

  const ConfirmBoxIdInput({
    Key? key,
    required this.orderWaitList,
    required this.onUpdate,
    required this.showMessage,
  }) : super(key: key);

  @override
  _ConfirmBoxIdInputState createState() => _ConfirmBoxIdInputState();
}

class _ConfirmBoxIdInputState extends State<ConfirmBoxIdInput> {
  final TextEditingController _controller = TextEditingController();

  void _confirmBoxId(String boxId) {
    if (boxId.isEmpty) {
      widget.showMessage('⚠️ Vui lòng nhập BoxIDStock');
      return;
    }

    final index = widget.orderWaitList.indexWhere(
      (e) => e['BoxIDStock'] == boxId,
    );

    if (index == -1) {
      widget.showMessage('❌ Không tìm thấy BoxIDStock này trong danh sách!');
      return;
    }

    final item = widget.orderWaitList[index];
    final int qtyPO = item['QtyPO'] ?? 0;
    final int qtyInOut = item['QtyInOut'] ?? 0;

    if (qtyInOut < qtyPO) {
      widget.showMessage(
        '⚠️ Số lượng xuất chưa đủ, không thể xác nhận hoàn tất!',
      );
      return;
    }

    setState(() {
      widget.orderWaitList[index]['Status'] = 'Hoàn tất';
      widget.showMessage('✅ Đã xác nhận hoàn tất BoxID: $boxId');
      _controller.clear();
      widget.onUpdate(widget.orderWaitList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Nhập BoxIDStock để xác nhận',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.inventory),
        ),
        onSubmitted: (val) => _confirmBoxId(val.trim()),
      ),
    );
  }
}
