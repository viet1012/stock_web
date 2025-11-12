class MockInventoryData {
  /// 🔹 Mock danh sách sản phẩm trên kệ
  static List<Map<String, dynamic>> getShelfItems() {
    final products = [
      {'ProductID': 'HN000009', 'ProductName': 'Vòng bi Q'},
      {'ProductID': 'HN000010', 'ProductName': 'Bánh răng A'},
      {'ProductID': 'HN000011', 'ProductName': 'Trục thép B'},
      {'ProductID': 'HN000012', 'ProductName': 'Bulong M6'},
    ];

    // ✅ Tạo danh sách Box duy nhất trên toàn hệ thống
    final List<String> allBoxes = List.generate(
      20,
      (i) => '[VT]_B_${i + 1}_BOX [VT]',
    );

    final List<Map<String, dynamic>> items = [];
    int boxIndex = 0;

    for (int i = 0; i < 80; i++) {
      final product = products[i % products.length];

      // ✅ Mỗi Product có thể nhận 1–3 box khác nhau, nhưng Box không trùng giữa các Product khác nhau
      final boxList = allBoxes[boxIndex % allBoxes.length];
      boxIndex++;

      items.add({
        'TT': i + 1,
        'ShelfId': 'PR-${['K', 'J', 'L'][i % 3]}${i + 1}-${(i % 5) + 1}',
        'ProductID': product['ProductID'],
        'ProductName': product['ProductName'],
        'Qty': (i % 5) + 1,
        'BoxList': boxList,
        'checked': false,
      });
    }

    return items;
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
        'BoxIDStock': 'BX501',
      },
      {
        'No': 2,
        'PartID': 'P1002',
        'PName': 'Trục thép B',
        'QtyPO': 100,
        'QtyInOut': 0,
        'ShelfIDWait': '',
        'POCode': '123',
        'Status': 'Chờ',
        'Remark': '',
        'BoxIDStock': 'BX502',
      },
    ];
  }

  /// 🔹 Mock danh sách box tồn kho
  static List<Map<String, dynamic>> getAllBoxes() {
    return [
      {
        'Firsttime': '2025-11-01 08:00',
        'BoxID': 'BX501',
        'QtyStock': 60,
        'CheckSt': 'OK',
        'ShelfID': 'SHELF-A',
        'POCode': '123',
      },
      {
        'Firsttime': '2025-11-01 08:10',
        'BoxID': 'BX502',
        'QtyStock': 40,
        'CheckSt': 'OK',
        'ShelfID': 'SHELF-B',
        'POCode': '123',
      },
      {
        'Firsttime': '2025-11-01 08:20',
        'BoxID': 'BX503',
        'QtyStock': 20,
        'CheckSt': 'NG',
        'ShelfID': 'SHELF-C',
        'POCode': '789',
      },
    ];
  }

  /// 🔹 Hàm tổng hợp tiện lợi
  static Map<String, dynamic> initializeAll() {
    return {
      'shelfItems': getShelfItems(),
      'orderWaitList': getOrderWaitList(),
      'allBoxes': getAllBoxes(),
    };
  }
}
