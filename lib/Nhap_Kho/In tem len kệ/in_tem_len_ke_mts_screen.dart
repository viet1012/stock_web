import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/header_bar.dart';
import 'widget/order_info_section.dart';
import 'widget/order_list_section.dart';

class InTemLenKeMTSScreen extends StatefulWidget {
  const InTemLenKeMTSScreen({super.key});

  @override
  State<InTemLenKeMTSScreen> createState() => _InTemLenKeMTSScreenState();
}

class _InTemLenKeMTSScreenState extends State<InTemLenKeMTSScreen> {
  List<Map<String, dynamic>> orderList = [];

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
    ).showSnackBar(const SnackBar(content: Text('Đã xóa tất cả dữ liệu')));
  }

  int get _totalQty =>
      orderList.fold(0, (sum, e) => sum + (e['quantity'] as int? ?? 0));
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header bar (responsive rồi)
            HeaderBar(msnv: '9999', title: 'IN TEM & LÊN KỆ'),

            const SizedBox(height: 12),

            // Responsive layout form + buttons
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
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFAF0),
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Row(
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
                                          'Đang in ${orderList.length} đơn hàng...',
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                label: 'Thoát',
                                color: Colors.grey.shade600,
                                icon: Icons.exit_to_app,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFAF0),
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
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
                                          'Đang in ${orderList.length} đơn hàng...',
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
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                label: 'Thoát',
                                color: Colors.grey.shade600,
                                icon: Icons.exit_to_app,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

            const SizedBox(height: 16),

            /// ======== DANH SÁCH ĐƠN HÀNG ==========
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

            /// ======== TỔNG KẾT ==========
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
}
