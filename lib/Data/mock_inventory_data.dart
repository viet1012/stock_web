class MockInventoryData {
  /// 🔹 Mock danh sách sản phẩm trên kệ
  static List<Map<String, dynamic>> getShelfItems() {
    final products = [
      {'ProductID': 'HN000009', 'ProductName': 'Vòng bi Q'},
      {'ProductID': 'HN000010', 'ProductName': 'Bánh răng A'},
      {'ProductID': 'HN000011', 'ProductName': 'Trục thép B'},
      {'ProductID': 'HN000012', 'ProductName': 'Bulong M6'},
    ];

    return List.generate(80, (i) {
      final product = products[i % products.length]; // chia đều 4 loại
      final boxCount = (i % 3) + 1; // mỗi sản phẩm có 1–3 box

      return {
        'TT': i + 1,
        'ShelfId': 'PR-${['K', 'J', 'L'][i % 3]}${i + 1}-${(i % 5) + 1}',
        'ProductID': product['ProductID'],
        'ProductName': product['ProductName'],
        'Qty': (i % 5) + 1,
        'BoxList': '[VT]_B_${boxCount}_Box [VT]',
        'checked': false,
      };
    });
  }

  /// 🔹 Mock danh sách đơn hàng chờ xử lý
  static List<Map<String, dynamic>> getOrderWaitList() {
    return [
      {
        'No': 1,
        'PartID': 'P1001',
        'PName': 'Ống thép 20mm',
        'QtyPO': 100,
        'QtyInOut': 0,
        'ShelfIDWait': '',
        'POCode': '456',
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

  /// 🔹 Mock danh sách box tồn kho (liên kết với POCode)
  static List<Map<String, dynamic>> getAllBoxes() {
    return [
      {
        'Firsttime': '2025-11-01 08:00',
        'BoxID': 'BX501',
        'QtyStock': 60,
        'CheckSt': 'OK',
        'ShelfID': '',
        'POCode': '123',
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

  /// 🔹 Hàm tổng hợp tiện lợi (nếu cần khởi tạo 1 lần)
  static Map<String, dynamic> initializeAll() {
    return {
      'shelfItems': getShelfItems(),
      'orderWaitList': getOrderWaitList(),
      'allBoxes': getAllBoxes(),
    };
  }
}
