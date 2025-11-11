import 'package:flutter/material.dart';

class ConfirmShelfDialog extends StatefulWidget {
  final List<Map<String, dynamic>> orderWaitList;
  final void Function(List<Map<String, dynamic>> updatedOrderWaitList) onUpdate;
  final List<String> allowedBoxIds;

  const ConfirmShelfDialog({
    Key? key,
    required this.orderWaitList,
    required this.onUpdate,
    required this.allowedBoxIds,
  }) : super(key: key);

  @override
  State<ConfirmShelfDialog> createState() => _ConfirmShelfDialogState();
}

class _ConfirmShelfDialogState extends State<ConfirmShelfDialog> {
  final TextEditingController boxConfirmController = TextEditingController();
  final TextEditingController shelfConfirmController = TextEditingController();
  final FocusNode shelfFocusNode = FocusNode();

  final Set<String> confirmedBoxes = {};
  bool _isCompleted = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _tryUpdateShelfWait() {
    final boxId = boxConfirmController.text.trim().toUpperCase();
    final shelf = shelfConfirmController.text.trim();

    print('--- [LOG] Xác nhận kệ ---');
    print('Box nhập: $boxId');
    print('Shelf nhập: $shelf');

    if (boxId.isEmpty || shelf.isEmpty) {
      _showMessage('⚠️ Vui lòng nhập đủ Mã Box và Mã Kệ Chờ!');
      return;
    }

    if (!widget.allowedBoxIds.contains(boxId)) {
      _showMessage('❌ BoxID này chưa được xác nhận trong gom hàng!');
      return;
    }

    final poIndex = widget.orderWaitList.indexWhere((po) {
      final boxList = po['BoxList']?.toString().toUpperCase() ?? '';
      final boxes = boxList.split(',').map((e) => e.trim()).toList();
      return boxes.contains(boxId);
    });

    if (poIndex == -1) {
      _showMessage('⚠️ BoxID hợp lệ nhưng chưa có trong danh sách kệ chờ!');
      return;
    }

    // ✅ Cập nhật dữ liệu
    setState(() {
      widget.orderWaitList[poIndex]['ShelfIDWait'] = shelf;
      confirmedBoxes.add(boxId);
    });

    widget.onUpdate(widget.orderWaitList);

    // ✅ Nếu đã quét đủ tất cả BoxID
    if (confirmedBoxes.length == widget.allowedBoxIds.length) {
      setState(() {
        _isCompleted = true;
      });

      _showMessage('🎉 Tất cả Box đã được xác nhận kệ chờ!');
      print('[LOG] ✅ Hoàn tất toàn bộ - ${confirmedBoxes.length} box');

      // ✅ Tự đóng dialog sau 1 giây
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      _showMessage(
        '✅ Cập nhật thành công ($boxId → $shelf)\n'
        'Còn lại: ${widget.allowedBoxIds.length - confirmedBoxes.length} Box',
      );
    }

    boxConfirmController.clear();
    shelfConfirmController.clear();
  }

  @override
  void dispose() {
    shelfFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Xác nhận kệ chờ cho Box',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
      content: SizedBox(
        width: 400,
        child: _isCompleted
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.celebration, color: Colors.green, size: 60),
                  SizedBox(height: 10),
                  Text(
                    'Tất cả Box đã được xác nhận thành công!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            : Column(
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
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(shelfFocusNode),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: shelfConfirmController,
                    focusNode: shelfFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Mã kệ chờ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.warehouse),
                    ),
                    onSubmitted: (_) => _tryUpdateShelfWait(),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Danh sách Box cần quét:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 150),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allowedBoxIds.length,
                      itemBuilder: (context, index) {
                        final boxId = widget.allowedBoxIds[index];
                        final isConfirmed = confirmedBoxes.contains(boxId);
                        return ListTile(
                          dense: true,
                          title: Text(
                            boxId,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isConfirmed ? Colors.green : Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            isConfirmed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isConfirmed ? Colors.green : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Đóng'),
        ),
        if (!_isCompleted)
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
