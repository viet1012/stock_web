import 'package:flutter/material.dart';
import 'package:stock_web/Nhap_Kho/Chuy%E1%BB%83n%20Kho/confirmation_trans_shelf_screen.dart';
import 'Kiem_Ke/inventory_management_screen.dart';
import 'Nhap_Kho/In tem len kệ/in_tem_len_ke_mts_screen.dart';
import 'MTSStockExportStep2.dart';
import 'MTS_stock_export_hangbo_screen.dart';
import 'stock_export_form.dart';
import 'Nhap_Kho/Phan_Loai/box_management_screen.dart';
import 'intro_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeTab = "GIỚI THIỆU HỆ THỐNG";
  String? selectedSubMenu;

  final Map<String, List<Map<String, dynamic>>> tabButtons = {
    "GIỚI THIỆU HỆ THỐNG": [],
    "NHẬP KHO": [
      {"icon": Icons.category, "label": "PHÂN LOẠI BOX LIST"},
      {"icon": Icons.print, "label": "IN TEM"},
      {"icon": Icons.add_box, "label": "CHUYỂN HÀNG LÊN KỆ"},
    ],
    "XUẤT KHO": [
      {"icon": Icons.local_shipping, "label": "XUẤT HÀNG (BƯỚC 1)"},
      {"icon": Icons.print, "label": "XUẤT HÀNG (BƯỚC 2)"},
    ],
    "KIỂM KÊ": [
      {"icon": Icons.local_shipping, "label": "KIỂM KÊ"},
    ],
  };

  // Biến quản lý mở Drawer khi màn hình nhỏ
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Khởi tạo selectedSubMenu theo tab active ban đầu
    final subList = tabButtons[activeTab];
    selectedSubMenu = (subList != null && subList.isNotEmpty)
        ? subList.first["label"]
        : null;
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    if (isMobile) {
      // AppBar cho mobile có nút mở Drawer
      return AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(activeTab),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        bottom: tabButtons[activeTab]!.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: _buildSubMenu(isMobile),
              )
            : null,
      );
    } else {
      // AppBar cho desktop như hiện tại
      return PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900]!, Colors.blue[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: Row(
                children: tabButtons.keys.map((tab) {
                  final bool isActive = (tab == activeTab);
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            activeTab = tab;
                            final subList = tabButtons[tab];
                            selectedSubMenu =
                                (subList != null && subList.isNotEmpty)
                                ? subList.first["label"]
                                : null;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isActive
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (tabButtons[activeTab]!.isNotEmpty)
              Container(
                height: 36,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildSubMenu(isMobile),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildSubMenu(bool isMobile) {
    if (isMobile) {
      // Trên mobile, menu con là DropdownButton
      return Align(
        alignment: Alignment.centerLeft,
        child: DropdownButton<String>(
          value: selectedSubMenu,
          items: tabButtons[activeTab]!
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item["label"],
                  child: Row(
                    children: [
                      Icon(item["icon"], size: 18, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(item["label"]),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedSubMenu = value;
            });
          },
          underline: Container(height: 0),
        ),
      );
    } else {
      // Trên desktop, menu con như ListView ngang hiện tại
      return ListView(
        scrollDirection: Axis.horizontal,
        children: tabButtons[activeTab]!.map((item) {
          final isSelected = selectedSubMenu == item["label"];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => selectedSubMenu = item["label"]),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue[400]! : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item["icon"],
                      size: 16,
                      color: isSelected ? Colors.blue[700] : Colors.grey[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item["label"],
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected ? Colors.blue[800] : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildBody() {
    if (activeTab == "GIỚI THIỆU HỆ THỐNG") {
      return const IntroPage();
    }
    if (selectedSubMenu == "PHÂN LOẠI BOX LIST") {
      return const BoxManagementScreen();
    }
    if (selectedSubMenu == "IN TEM") {
      return const InTemLenKeMTSScreen();
    }
    if (selectedSubMenu == "CHUYỂN HÀNG LÊN KỆ") {
      return FrmTransShelfScreen();
    }
    if (selectedSubMenu == "XUẤT HÀNG (BƯỚC 1)") {
      return StockExportForm();
    }
    if (selectedSubMenu == "XUẤT KHO HÀNG BỘ") {
      return MTSStockExportHangBoForm();
    }
    if (selectedSubMenu == "XUẤT HÀNG (BƯỚC 2)") {
      return MTSStockExportStep2();
    }
    if (selectedSubMenu == "KIỂM KÊ") {
      return InventoryManagementScreen();
    }
    return Center(
      child: Text(
        "Trang nội dung của: $activeTab",
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Phân biệt kích thước màn hình
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(isMobile),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                children: tabButtons.keys.map((tab) {
                  return ListTile(
                    title: Text(tab),
                    selected: tab == activeTab,
                    onTap: () {
                      setState(() {
                        activeTab = tab;
                        final subList = tabButtons[tab];
                        selectedSubMenu =
                            (subList != null && subList.isNotEmpty)
                            ? subList.first["label"]
                            : null;
                      });
                      Navigator.pop(context); // đóng Drawer
                    },
                  );
                }).toList(),
              ),
            )
          : null,
      body: _buildBody(),
    );
  }
}
