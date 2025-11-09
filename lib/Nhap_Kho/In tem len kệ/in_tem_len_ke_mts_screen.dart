import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import 'widget/order_info_section.dart';
import 'widget/order_list_section.dart';

class InTemLenKeMTSScreen extends StatefulWidget {
  const InTemLenKeMTSScreen({super.key});

  @override
  State<InTemLenKeMTSScreen> createState() => _InTemLenKeMTSScreenState();
}

class _InTemLenKeMTSScreenState extends State<InTemLenKeMTSScreen> {
  List<Map<String, dynamic>> orderList = [];
  final TextEditingController _boxOutController = TextEditingController();
  final FocusNode _boxOutFocus = FocusNode();

  void _onOrderAdded(Map<String, dynamic> orderData) {
    setState(() {
      orderList.add(orderData);
    });
  }

  void _deleteOrder(int index) {
    setState(() {
      orderList.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() => orderList.clear());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🗑️ Đã xóa tất cả dữ liệu')));
  }

  int get _totalQty =>
      orderList.fold(0, (sum, e) => sum + (e['quantity'] as int? ?? 0));

  /// ✅ Giả lập lấy hàng khỏi kệ
  void _onBoxOut(String boxId) {
    final id = boxId.trim();
    if (id.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade700,
        content: Text('✅ Đã lấy hàng BoxID "$id" khỏi kệ chờ'),
      ),
    );

    _boxOutController.clear();
    FocusScope.of(context).requestFocus(_boxOutFocus);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // HeaderBar(msnv: '9999', title: 'IN TEM & LÊN KỆ'),
            // const SizedBox(height: 12),

            /// ====== Ô LẤY HÀNG RA KHỎI KỆ ======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_outlined,
                    color: Colors.orange,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LẤY HÀNG RA KHỎI KỆ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _boxOutController,
                      focusNode: _boxOutFocus,
                      autofocus: true,
                      onSubmitted: _onBoxOut,
                      decoration: InputDecoration(
                        hintText: 'Nhập BoxID để lấy hàng...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ====== FORM NHẬP PO & NÚT IN ======
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        child: OrderInfoSection(onAddOrder: _onOrderAdded),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButtons(isMobile: true),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 800,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        child: OrderInfoSection(onAddOrder: _onOrderAdded),
                      ),
                      const SizedBox(width: 18),
                      _buildActionButtons(),
                    ],
                  ),

            const SizedBox(height: 16),

            /// ====== DANH SÁCH ĐƠN HÀNG ======
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: OrderListSection(
                  orderList: orderList,
                  onDelete: _deleteOrder,
                ),
              ),
            ),

            /// ====== TỔNG KẾT ======
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng đơn hàng: ${orderList.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Tổng SL: $_totalQty',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoxOutSection(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.inventory_outlined,
                  color: Colors.orange,
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Text(
                  'LẤY HÀNG RA KHỎI KỆ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildBoxInputField()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.inventory_outlined,
                      color: Colors.orange,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LẤY HÀNG RA KHỎI KỆ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildBoxInputField(),
              ],
            ),
    );
  }

  Widget _buildBoxInputField() {
    return TextField(
      controller: _boxOutController,
      focusNode: _boxOutFocus,
      autofocus: true,
      onSubmitted: _onBoxOut,
      decoration: InputDecoration(
        hintText: 'Nhập BoxID để lấy hàng...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  /// ====== TÁCH NÚT HÀNH ĐỘNG RIÊNG ======
  Widget _buildActionButtons({bool isMobile = false}) {
    return Container(
      width: isMobile ? double.infinity : 160,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF0),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      child: isMobile
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'In Tem',
                    color: Colors.green.shade700,
                    icon: Icons.print,
                    onPressed: () {
                      if (orderList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chưa có đơn hàng để in'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🖨️ Đang in ${orderList.length} đơn hàng...',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    label: 'Xóa',
                    color: Colors.red.shade600,
                    icon: Icons.delete_forever,
                    onPressed: _clearAll,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'In Tem',
                    color: Colors.green.shade700,
                    icon: Icons.print,
                    onPressed: () {
                      if (orderList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chưa có đơn hàng để in'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🖨️ Đang in ${orderList.length} đơn hàng...',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Xóa tất cả',
                    color: Colors.red.shade600,
                    icon: Icons.delete_forever,
                    onPressed: _clearAll,
                  ),
                ),
              ],
            ),
    );
  }
}
