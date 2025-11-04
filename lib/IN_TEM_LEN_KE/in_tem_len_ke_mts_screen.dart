import 'package:flutter/material.dart';

class BoxListManagementForm extends StatefulWidget {
  const BoxListManagementForm({super.key});

  @override
  State<BoxListManagementForm> createState() => _BoxListManagementFormState();
}

class _BoxListManagementFormState extends State<BoxListManagementForm> {
  String _selectedStatus = 'PRESS';
  final TextEditingController _boxIdController = TextEditingController();
  final TextEditingController _soLuongController = TextEditingController();

  // Mock data
  final Map<String, String> _boxInfo = {
    'sodonhang': '72000020802',
    'tenHang': '[HF]_SSH3-50-0',
    'maSP': 'HOR3524',
    'lotNo': 'S1ND267238',
    'soLuong': '1',
    'pherAufnr': '101007295758',
    'trongLuong': '0',
    'donVi': '(Kg)',
  };

  @override
  void dispose() {
    _boxIdController.dispose();
    _soLuongController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Nha'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.folder, color: Colors.blue[700], size: 20),
                SizedBox(width: 8),
                Text(
                  'LẤY HÀNG ĐƯA KỀ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Left Panel
                Container(
                  width: 280,
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // MSNV
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MSNV:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '20616',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Status
                        Text(
                          'BOX ID :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            _buildRadioOption('PRESS'),
                            _buildRadioOption('HOLD'),
                            _buildRadioOption('GUIDE'),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _boxIdController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Nhập Box ID',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Số lượng
                        Text(
                          '+ Số đơn hàng:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 6),
                        TextField(
                          controller: _soLuongController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Q',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: Icon(Icons.print, size: 18),
                            label: Text(
                              'In Box(Print)',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: Icon(Icons.clear, size: 18),
                            label: Text(
                              'Xóa (Clear)',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              _boxIdController.clear();
                              _soLuongController.clear();
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: Icon(Icons.exit_to_app, size: 18),
                            label: Text(
                              'Thoát (Exit)',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.amber[200]!),
                          ),
                          child: Text(
                            'Danh sách đơn hàng đang chờ trong box :',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Middle Content
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'QUẢN LÝ BOX LIST NHẬP KHO MTS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Info section
                        Text(
                          'Thông tin đơn hàng',
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            _buildInfoItem(
                              '+ Số đơn hàng :',
                              _boxInfo['sodonhang']!,
                            ),
                            _buildInfoItem(
                              '+ Tên hàng :',
                              _boxInfo['tenHang']!,
                            ),
                            _buildInfoItem('+ Mã SP :', _boxInfo['maSP']!),
                            _buildInfoItem('+ LotNo :', _boxInfo['lotNo']!),
                            _buildInfoItem(
                              '+ Số lượng :',
                              _boxInfo['soLuong']!,
                            ),
                            _buildInfoItem(
                              '+ PHER_AUFNR :',
                              _boxInfo['pherAufnr']!,
                            ),
                            _buildInfoItem(
                              '+ Trọng lượng :',
                              _boxInfo['trongLuong']!,
                            ),
                            _buildInfoItem('+ Đơn vị :', _boxInfo['donVi']!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Panel - QR Code
                Container(
                  width: 250,
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'In Lại Tem Box QR (Re-Printer)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // QR Code area
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            'QR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Lưu ý: Chú ý dùng in lại ngay sau khi in lần đầu tiên',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedStatus,
          onChanged: (newValue) {
            setState(() => _selectedStatus = newValue!);
          },
        ),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.amber[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
