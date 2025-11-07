import 'package:flutter/material.dart';

class OrderListSection extends StatelessWidget {
  final List<Map<String, dynamic>> orderList;
  final Function(int) onDelete;

  const OrderListSection({
    super.key,
    required this.orderList,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    if (orderList.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Giới hạn max kích thước icon dựa theo chiều rộng màn hình, min/max để không quá nhỏ hoặc lớn
          double iconSize = (constraints.maxWidth * 0.2).clamp(40, 80);
          double paddingSize = (constraints.maxWidth * 0.1).clamp(16, 48);
          double titleFontSize = (constraints.maxWidth * 0.05).clamp(14, 22);
          double subtitleFontSize = (constraints.maxWidth * 0.035).clamp(
            12,
            18,
          );

          return Container(
            padding: EdgeInsets.all(paddingSize),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(paddingSize * 0.75),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: iconSize,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: paddingSize * 0.33),
                Text(
                  'Chưa có đơn hàng nào',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: titleFontSize,
                  ),
                ),
                SizedBox(height: paddingSize * 0.17),
                Text(
                  'Scan mã để thêm đơn hàng',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: subtitleFontSize,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (isMobile) {
      // Mobile: danh sách thẻ
      return ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          final o = orderList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('STT', '${index + 1}'),
                  _infoRow('Mã đơn hàng', o['po'] ?? ''),
                  _infoRow('Sản phẩm', o['product'] ?? ''),
                  _infoRow('Mã SP', o['code'] ?? ''),
                  _infoRow('Lot', o['lot'] ?? ''),
                  _infoRow('Số lượng', o['quantity']?.toString() ?? ''),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(context, index),
                      tooltip: 'Xóa đơn hàng',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Desktop/Table: bảng Table như hiện tại
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.indigo.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(2.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(1),
                6: FixedColumnWidth(60),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell('STT'),
                    _buildHeaderCell('Mã đơn hàng'),
                    _buildHeaderCell('Sản phẩm'),
                    _buildHeaderCell('Mã SP'),
                    _buildHeaderCell('Lot'),
                    _buildHeaderCell('SL'),
                    _buildHeaderCell(''),
                  ],
                ),
              ],
            ),
          ),

          // Table Body
          Expanded(
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final o = orderList[index];
                final isEven = index % 2 == 0;

                return Container(
                  decoration: BoxDecoration(
                    color: isEven ? Colors.grey[50] : Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(2.5),
                      3: FlexColumnWidth(1.5),
                      4: FlexColumnWidth(1.5),
                      5: FlexColumnWidth(1),
                      6: FixedColumnWidth(60),
                    },
                    children: [
                      TableRow(
                        children: [
                          _buildDataCell('${index + 1}'),
                          _buildDataCell(o['po'] ?? ''),
                          _buildDataCell(o['product'] ?? ''),
                          _buildDataCell(o['code'] ?? ''),
                          _buildDataCell(o['lot'] ?? ''),
                          _buildDataCell(o['quantity']?.toString() ?? ''),
                          _buildActionCell(context, index),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: SelectableText(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black87),
        maxLines: 2,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
          onPressed: () => _showDeleteConfirmation(context, index),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Xác nhận xóa'),
            ],
          ),
          content: const Text('Bạn có chắc chắn muốn xóa đơn hàng này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Xóa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
