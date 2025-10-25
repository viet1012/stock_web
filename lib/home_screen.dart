import 'package:flutter/material.dart';
import 'package:stock_web/confirmation_trans_shelf_screen.dart';
import 'IN_TEM_LEN_KE/in_tem_len_ke_mts_screen.dart';
import 'MTSStockExportStep2.dart';
import 'MTS_stock_export_hangbo_screen.dart';
import 'MTS_stock_export_screen.dart';
import 'box_management_screen.dart';
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
    "QUẢN LÝ MTO": [
      {"icon": Icons.list_alt, "label": "DANH SÁCH MTO"},
      {"icon": Icons.settings, "label": "CẤU HÌNH"},
    ],
    "NHẬP KHO": [
      {"icon": Icons.category, "label": "PHÂN LOẠI BOX LIST"},
      {"icon": Icons.print, "label": "IN TEM VÀ LÊN KỆ"},
      {"icon": Icons.add_box, "label": "CHUYỂN KHO NỘI BỘ"},
    ],
    "XUẤT KHO": [
      {"icon": Icons.local_shipping, "label": "XUẤT HÀNG (BƯỚC 1)"},
      {"icon": Icons.local_shipping, "label": "XUẤT KHO HÀNG BỘ"},
      {"icon": Icons.print, "label": "XUẤT HÀNG (BƯỚC 2)"},
    ],
  };

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Column(
        children: [
          // 🔹 Thanh tab chính
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

          // 🔹 Sub menu gọn (icon + text nằm cùng hàng)
          if (tabButtons[activeTab]!.isNotEmpty)
            Container(
              height: 36,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: tabButtons[activeTab]!.map((item) {
                  final isSelected = selectedSubMenu == item["label"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () =>
                          setState(() => selectedSubMenu = item["label"]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue[50]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue[400]!
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item["icon"],
                              size: 16,
                              color: isSelected
                                  ? Colors.blue[700]
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item["label"],
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.blue[800]
                                    : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (activeTab == "GIỚI THIỆU HỆ THỐNG") {
      return IntroPage();
    }
    if (selectedSubMenu == "PHÂN LOẠI BOX LIST") {
      return const BoxManagementScreen();
    }
    if (selectedSubMenu == "IN TEM VÀ LÊN KỆ") {
      return const InTemLenKeMTSScreen();
    }
    if (selectedSubMenu == "CHUYỂN KHO NỘI BỘ") {
      return ConfirmationScreen();
    }
    if (selectedSubMenu == "XUẤT HÀNG (BƯỚC 1)") {
      return MTSStockExportScreen();
    }
    if (selectedSubMenu == "XUẤT KHO HÀNG BỘ") {
      return MTSStockExportHangBoForm();
    }
    if (selectedSubMenu == "XUẤT HÀNG (BƯỚC 2)") {
      return MTSStockExportStep2();
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
