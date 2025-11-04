import 'package:flutter/material.dart';
import 'dart:math';

import '../../../Data/mock_data.dart';

class OrderInfoSection extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddOrder;
  const OrderInfoSection({super.key, required this.onAddOrder});

  @override
  State<OrderInfoSection> createState() => _OrderInfoSectionState();
}

class _OrderInfoSectionState extends State<OrderInfoSection> {
  final _poController = TextEditingController();
  final _qtyController = TextEditingController();
  final FocusNode _qtyFocusNode = FocusNode(); // ✅ Focus node cho ô số lượng

  Map<String, dynamic>? _selectedOrder;

  void _fetchOrder(String po) {
    final key = po.trim().toUpperCase();
    setState(() {
      _selectedOrder = mockOrderData[key]; // ✅ lấy từ mock chung
    });

    if (_selectedOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Không tìm thấy đơn hàng "$po"')),
      );
    } else {
      FocusScope.of(
        context,
      ).requestFocus(_qtyFocusNode); // ✅ focus qua ô số lượng
    }
  }

  void _addOrder() {
    if (_selectedOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Vui lòng nhập PO hợp lệ')),
      );
      return;
    }

    final qty = int.tryParse(_qtyController.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('⚠️ Nhập số lượng hợp lệ')));
      return;
    }

    final data = {
      'po': _poController.text.trim(),
      'product': _selectedOrder!['product']!,
      'code': _selectedOrder!['code']!,
      'lot': _selectedOrder!['lot']!,
      'weight': _selectedOrder!['weight']!,
      'quantity': qty,
      'inDateTime': DateTime.now().toString().split('.')[0],
      'machine': 'MC-${100 + Random().nextInt(50)}',
    };

    widget.onAddOrder(data);
    _poController.clear();
    _qtyController.clear();
    setState(() => _selectedOrder = null);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPOValid = _selectedOrder != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('NHẬP ĐƠN HÀNG', Icons.assignment, Colors.teal),
        const SizedBox(height: 8),

        /// --- Input PO + Số lượng ---
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _poController,
                onSubmitted: _fetchOrder,
                decoration: InputDecoration(
                  labelText: 'Nhập số PO (VD: ODR1001)',
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _qtyController,
                focusNode: _qtyFocusNode,
                enabled: isPOValid, // ✅ Chỉ bật khi có PO hợp lệ
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _addOrder(), // ✅ ENTER là thêm luôn
                decoration: InputDecoration(
                  labelText: 'Số lượng',
                  filled: true,
                  fillColor: isPOValid
                      ? const Color(0xFFFAFAFA)
                      : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// --- Hiển thị thông tin đơn hàng ---
        if (_selectedOrder != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile('Tên hàng', _selectedOrder!['product']!),
                _infoTile('Mã SP', _selectedOrder!['code']!),
                _infoTile('Lot', _selectedOrder!['lot']!),
                _infoTile('Trọng lượng', _selectedOrder!['weight']!),
              ],
            ),
          ),
      ],
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
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
}
