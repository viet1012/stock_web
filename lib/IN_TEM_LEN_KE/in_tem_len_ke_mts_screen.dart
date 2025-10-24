import 'package:flutter/material.dart';
import 'action_button.dart';
import 'order_info_section.dart';
import 'order_list_section.dart';

class InTemLenKeMTSScreen extends StatefulWidget {
  const InTemLenKeMTSScreen({super.key});

  @override
  State<InTemLenKeMTSScreen> createState() => _InTemLenKeMTSScreenState();
}

class _InTemLenKeMTSScreenState extends State<InTemLenKeMTSScreen> {
  List<Map<String, dynamic>> orderList = [];

  // Khi bấm Enter trong trường số lượng, dữ liệu sẽ được thêm
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
    setState(() {
      orderList.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa tất cả dữ liệu')));
  }

  int get _totalQty =>
      orderList.fold(0, (sum, e) => sum + e['quantity'] as int);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IN TEM VÀ LÊN KỆ MTS',

          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 1️⃣ Phần nhập thông tin đơn hàng
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1️⃣ Form nhập thông tin đơn hàng
                Expanded(
                  flex: 2,
                  child: OrderInfoSection(onAddOrder: _onOrderAdded),
                ),
                const SizedBox(width: 16),

                /// 2️⃣ Cột chứa các nút thao tác
                Column(
                  children: [
                    SizedBox(
                      width: 130,
                      child: ActionButton(
                        label: 'In Tem',
                        color: Colors.green,
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
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 130,
                      child: ActionButton(
                        label: 'Xóa tất cả',
                        color: Colors.red,
                        icon: Icons.delete_forever,
                        onPressed: _clearAll,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 2️⃣ Hành động chính
            const SizedBox(height: 16),

            /// 3️⃣ Danh sách đơn hàng
            Expanded(
              child: OrderListSection(
                orderList: orderList,
                onDelete: _deleteOrder,
              ),
            ),

            /// 4️⃣ Tổng cộng
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng đơn hàng: ${orderList.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
