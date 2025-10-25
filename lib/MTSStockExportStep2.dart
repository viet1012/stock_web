import 'package:flutter/material.dart';

class MTSStockExportStep2 extends StatefulWidget {
  const MTSStockExportStep2({super.key});

  @override
  State<MTSStockExportStep2> createState() => _MTSStockExportStep2State();
}

class _MTSStockExportStep2State extends State<MTSStockExportStep2> {
  final TextEditingController orderItoController = TextEditingController(
    text: 'S',
  );
  final TextEditingController boxStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              children: [
                // Left Section
                Expanded(flex: 2, child: _buildLeftSection()),

                // Right Section
                Expanded(flex: 3, child: _buildRightSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Left side info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'MSNV: ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '20616',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '+ Số lượng PO cần xuất: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: '1',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '+ Số Box trên kệ chờ: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: '0',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Khu vực xuất kho MTS',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '+ PIER_AUFNR :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Center Title
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  'QUẢN LÝ XUẤT KHO STOCK MTS (Bước 02)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Gợi ý kệ chờ',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Right side buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text('In Lại Tem BoxID'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.qr_code, size: 18),
                      label: const Text('In QRCode'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Thoát (Exit)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Lưu ý: Chỉ sử dụng in lại này ngay sau khi in tem return bị lỗi không ra.',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Input fields
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('+ OrderIto:')),
                    Expanded(
                      child: TextField(
                        controller: orderItoController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 100, child: Text('+ Box Stock:')),
                    Expanded(
                      child: TextField(
                        controller: boxStockController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Table 1
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh Sách Part Xuất Kho',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildTable(
              headers: [
                'SPCNo',
                'ProductID',
                'PName',
                'POQty',
                'TQty',
                'IDBox',
              ],
              data: [],
            ),
          ),

          const SizedBox(height: 12),

          // Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'Xuất Kho Hàng Bộ MTS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh Sách Xuất Kho Thành Công',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildTable(
              headers: [
                'OutputID',
                'SPCNo',
                'BoxID',
                'ShelfWait',
                'POQty',
                'TQty',
                'Noted',
                'Dat',
              ],
              data: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable({
    required List<String> headers,
    required List<Map<String, dynamic>> data,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Row(
              children: headers.asMap().entries.map((entry) {
                final isLast = entry.key == headers.length - 1;
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: isLast ? Colors.transparent : Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Body
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: data.isEmpty
                  ? const Center(
                      child: Text(
                        'Chưa có dữ liệu',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: Row(
                            children: headers.asMap().entries.map((entry) {
                              final isLast = entry.key == headers.length - 1;
                              return Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: isLast
                                            ? Colors.transparent
                                            : Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    data[index][entry.value]?.toString() ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
