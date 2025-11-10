class MockInventoryData {
  // Danh sách đơn hàng chờ
  static List<Map<String, dynamic>> getOrderWaitList() {
    return [
      {
        'No': 1,
        'PartID': 'P1001',
        'PName': 'Ống thép 20mm',
        'QtyPO': 100,
        'QtyInOut': 0,
        'ShelfIDWait': '',
        'POCode': '456', // 🔹 Mã PO riêng
        'Status': 'Chờ',
        'Remark': '',
        'BoxIDStock': 'VT1012',
      },
      {
        'No': 2,
        'PartID': 'P1002',
        'PName': 'Ống thép 20mm',
        'QtyPO': 100,
        'QtyInOut': 0,
        'ShelfIDWait': '',
        'POCode': '123',
        'Status': 'Chờ',
        'Remark': '',
        'BoxIDStock': 'VTA1012',
      },
    ];
  }

  // Danh sách Box tồn kho
  static List<Map<String, dynamic>> getAllBoxes() {
    return [
      {
        'Firsttime': '2025-11-01 08:00',
        'BoxID': 'BX501',
        'QtyStock': 60,
        'CheckSt': 'OK',
        'ShelfID': '',
        'POCode': '123', // 🔹 Liên kết với PO
      },
      {
        'Firsttime': '2025-11-01 08:10',
        'BoxID': 'BX502',
        'QtyStock': 40,
        'CheckSt': 'OK',
        'ShelfID': 'Shelf-2',
        'POCode': '123',
      },
      {
        'Firsttime': '2025-11-01 08:20',
        'BoxID': 'BX503',
        'QtyStock': 20,
        'CheckSt': 'NG',
        'ShelfID': 'Shelf-3',
        'POCode': '456',
      },
    ];
  }
}
