import 'package:flutter/material.dart';
import 'package:stock_web/confirmation_trans_shelf_screen.dart';
import 'IN_TEM_LEN_KE/in_tem_len_ke_mts_screen.dart';
import 'MTS_stock_export_formV2.dart';
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
      {"icon": Icons.print, "label": "IN PHIẾU XUẤT"},
    ],
  };

  // 🔹 Hàm dựng phần AppBar riêng
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Column(
        children: [
          // 🔹 Thanh Tabs chính
          Container(
            color: Colors.blue[800],
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            child: Row(
              children: tabButtons.keys.map((tab) {
                final bool isActive = (tab == activeTab);
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
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

                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isActive ? Colors.yellowAccent : Colors.white,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 🔹 Ribbon nhóm nút (nếu có submenu)
          if (tabButtons[activeTab]!.isNotEmpty)
            Container(
              color: Colors.grey[200],
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    ...tabButtons[activeTab]!.map((item) {
                      final isSelected = selectedSubMenu == item["label"];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            setState(() => selectedSubMenu = item["label"]);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item["icon"],
                                size: 28,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.blue[800],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["label"],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.orange[800]
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (activeTab == "GIỚI THIỆU HỆ THỐNG") {
      return IntroPage();
      ();
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
      return MTSStockExportFormV2();
    }
    return Center(
      child: Text(
        "Trang nội dung của: $activeTab",
        style: const TextStyle(fontSize: 20, color: Colors.black54),
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
