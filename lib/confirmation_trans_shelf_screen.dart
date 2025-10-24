import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xác Nhận Box Cần Chuyển Kệ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ConfirmationScreen(),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'XÁC NHẬN CẦN BOX CHUYỂN LÊN KỆ',

          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Scan Box Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Scan Box',
                        prefixIcon: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.blue[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue[700]!,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Box Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2,
                                color: Colors.orange[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Box còn lại: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '37',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            'BoxID',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Scan ShelfID Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Scan ShelfID',
                        prefixIcon: Icon(
                          Icons.shelves,
                          color: Colors.blue[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue[700]!,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Table Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Danh Sách Box',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Data Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey[100],
                    ),
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                      fontSize: 13,
                    ),
                    dataTextStyle: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12,
                    ),
                    columnSpacing: 24,
                    horizontalMargin: 16,
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('ShelfID')),
                      DataColumn(label: Text('ProductID')),
                      DataColumn(label: Text('ProductName')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('IDBlock')),
                      DataColumn(label: Text('MSNV')),
                      DataColumn(label: Text('Remark')),
                      DataColumn(label: Text('Firsttime')),
                      DataColumn(label: Text('PO_First')),
                    ],
                    rows: [
                      _buildDataRow(
                        '800125',
                        'Wating',
                        'H0077923',
                        '[HF].SSB4-40-0',
                        '95',
                        'Box_[HF].S...',
                        '22207',
                        '',
                        '10/2/2025',
                        'Box_[HF].S...',
                        Colors.blue[50],
                      ),
                      _buildDataRow(
                        '800185',
                        'Wating',
                        'H0100573',
                        '[HF].Set Part_R...',
                        '1',
                        'Box_[HF].S...',
                        '22259',
                        '',
                        '5/28/2025',
                        'Box_[HF].S...',
                        null,
                      ),
                      _buildDataRow(
                        '800222',
                        'Wating',
                        'H0063869',
                        '[HF].HSB8P-10...',
                        '2',
                        'Box_[HF].S...',
                        '22707',
                        '',
                        '9/29/2025',
                        'Box_[HF].S...',
                        Colors.blue[50],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    String id,
    String shelfId,
    String productId,
    String productName,
    String qty,
    String idBlock,
    String msnv,
    String remark,
    String firsttime,
    String poFirst,
    Color? backgroundColor,
  ) {
    return DataRow(
      color: MaterialStateProperty.all(backgroundColor),
      cells: [
        DataCell(Text(id, style: TextStyle(fontWeight: FontWeight.w600))),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              shelfId,
              style: TextStyle(color: Colors.orange[800], fontSize: 11),
            ),
          ),
        ),
        DataCell(Text(productId)),
        DataCell(Text(productName)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              qty,
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(Text(idBlock)),
        DataCell(Text(msnv)),
        DataCell(Text(remark)),
        DataCell(Text(firsttime)),
        DataCell(Text(poFirst)),
      ],
    );
  }
}
