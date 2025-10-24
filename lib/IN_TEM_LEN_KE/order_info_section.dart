import 'package:flutter/material.dart';

class OrderInfoSection extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddOrder;
  const OrderInfoSection({super.key, required this.onAddOrder});

  @override
  State<OrderInfoSection> createState() => _OrderInfoSectionState();
}

class _OrderInfoSectionState extends State<OrderInfoSection> {
  final _orderController = TextEditingController();
  final _productController = TextEditingController();
  final _codeController = TextEditingController();
  final _lotController = TextEditingController();
  final _qtyController = TextEditingController();

  /// Khi nhập số đơn hàng → tự động load dữ liệu demo
  void _fetchOrderInfo(String orderNo) {
    if (orderNo.isEmpty) return;
    setState(() {
      _productController.text = "Bình Nước Nóng 20L";
      _codeController.text = "BNN20-123";
      _lotController.text = "LOT20251023";
    });
  }

  /// Khi Enter số lượng → thêm đơn hàng vào danh sách
  void _onEnterQty(String qtyText) {
    final qty = int.tryParse(qtyText);
    if (qty == null || qty <= 0) return;

    final data = {
      'order': _orderController.text.trim(),
      'product': _productController.text.trim(),
      'code': _codeController.text.trim(),
      'lot': _lotController.text.trim(),
      'quantity': qty,
    };

    // if (data['order']!.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Vui lòng nhập số đơn hàng')),
    //   );
    //   return;
    // }

    widget.onAddOrder(data);
    _clearFields();
  }

  void _clearFields() {
    _orderController.clear();
    _productController.clear();
    _codeController.clear();
    _lotController.clear();
    _qtyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THÔNG TIN ĐƠN HÀNG',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),

          /// Nhập số đơn hàng
          _buildInfoField(
            'Số đơn hàng',
            _orderController,
            onSubmitted: _fetchOrderInfo,
          ),
          const SizedBox(height: 4),

          /// Tên hàng
          _buildInfoField('Tên hàng', _productController, readOnly: true),
          const SizedBox(height: 4),

          /// Mã SP
          _buildInfoField('Mã sản phẩm', _codeController, readOnly: true),
          const SizedBox(height: 4),

          /// Lot No
          _buildInfoField('Lot No.', _lotController, readOnly: true),
          const SizedBox(height: 4),

          /// Số lượng
          _buildInfoField(
            'Số lượng',
            _qtyController,
            inputType: TextInputType.number,
            onSubmitted: _onEnterQty,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller, {
    void Function(String)? onSubmitted,
    TextInputType inputType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '+ ',
              style: TextStyle(
                color: Color(0xFFCCCC00),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF5A6C7D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: inputType,
          onSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? const Color(0xFFF2F2F2)
                : const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}
