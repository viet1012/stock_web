import 'package:flutter/material.dart';
import 'package:stock_web/Bao_Cao/forecast_table_screen.dart';
import 'package:stock_web/Bao_Cao/frm_stock_report_screen.dart';
import 'package:stock_web/Bao_Cao/inventory_statistics_screen.dart';
import 'package:stock_web/Bao_Cao/quality_chart_screen.dart';
import 'package:stock_web/Gom_Hang/GomHangScreen.dart';
import 'package:stock_web/Kiem_Ke/box_confirm_screen.dart';
import 'package:stock_web/Kiem_Ke/inventory_management_screen.dart';
import 'package:stock_web/MTSStockExportStep2.dart';
import 'package:stock_web/Nhap_Kho/Chuy%E1%BB%83n%20Kho/confirmation_trans_shelf_screen.dart';
import 'package:stock_web/Nhap_Kho/In tem len kệ/in_tem_len_ke_mts_screen.dart';
import 'package:stock_web/Nhap_Kho/Phan_Loai/box_management_screen.dart';

import 'Gom_Hang/ConfirmBoxScreen.dart';
import 'intro_page.dart';
import 'stock_export_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeTab = "GIỚI THIỆU HỆ THỐNG";
  String? selectedSubMenu;
  int selectedMonth = DateTime.now().month;

  final Map<String, IconData> tabIcons = {
    "GIỚI THIỆU HỆ THỐNG": Icons.info_outline,
    "NHẬP KHO": Icons.inventory_2_outlined,
    "XUẤT KHO": Icons.outbox,
    "KIỂM KÊ": Icons.fact_check_outlined,
    "GOM HÀNG": Icons.all_inbox_outlined,
    "BÁO CÁO": Icons.bar_chart_outlined,
  };

  final Map<String, List<Map<String, dynamic>>> tabButtons = {
    "GIỚI THIỆU HỆ THỐNG": [],
    "NHẬP KHO": [
      {"icon": Icons.category, "label": "PHÂN LOẠI BOX LIST"},
      {"icon": Icons.print, "label": "IN TEM"},
      {"icon": Icons.add_box, "label": "CHUYỂN HÀNG LÊN KỆ"},
    ],
    "XUẤT KHO": [
      {"icon": Icons.outbox, "label": "XUẤT HÀNG (BƯỚC 1)"},
      {"icon": Icons.print, "label": "XUẤT HÀNG (BƯỚC 2)"},
    ],
    "GOM HÀNG": [
      {"icon": Icons.featured_play_list, "label": "DANH SÁCH GOM HÀNG"},
      {"icon": Icons.print, "label": "IN TEM GOM HÀNG"},
    ],
    "KIỂM KÊ": [
      {"icon": Icons.assignment_turned_in, "label": "KIỂM KÊ SP"},
      {"icon": Icons.assignment_turned_in, "label": "IN LẠI TEM"},
    ],
    "BÁO CÁO": [
      {"icon": Icons.bar_chart_outlined, "label": "NHẬP-XUẤT-TỒN KHO"},
      {"icon": Icons.bar_chart_outlined, "label": "KIỂM KÊ"},
      {"icon": Icons.calendar_month, "label": "DỰ BÁO"},
      {"icon": Icons.analytics, "label": "THỐNG KÊ"},
    ],
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final subList = tabButtons[activeTab];
    selectedSubMenu = (subList != null && subList.isNotEmpty)
        ? subList.first["label"]
        : null;
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Column(
        children: [
          // 🔷 Thanh tab chính
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF002F6C),
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            child: Row(
              children: tabButtons.keys.map((tab) {
                final bool isActive = (tab == activeTab);
                final icon = tabIcons[tab];
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            size: 20,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tab,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.9),
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.w500,
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
          // 🔹 Menu con hoặc filter tháng
          if (tabButtons[activeTab]!.isNotEmpty)
            Container(
              height: 40,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(child: _buildSubMenu(false)),
                  if (activeTab == "BÁO CÁO") _buildMonthFilter(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthFilter() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: selectedMonth,
          items: List.generate(
            12,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text("Tháng ${index + 1}"),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedMonth = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSubMenu(bool isMobile) {
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.blue[400]! : Colors.brown,
                  width: 1,
                ),
              ),
              child: Row(
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

  Widget _buildBody() {
    // ✅ Truyền selectedMonth cho các báo cáo
    if (activeTab == "GIỚI THIỆU HỆ THỐNG") return const IntroPage();
    if (selectedSubMenu == "PHÂN LOẠI BOX LIST")
      return const BoxManagementScreen();
    if (selectedSubMenu == "IN TEM") return const InTemLenKeMTSScreen();
    if (selectedSubMenu == "CHUYỂN HÀNG LÊN KỆ") return FrmTransShelfScreen();
    if (selectedSubMenu == "XUẤT HÀNG (BƯỚC 1)") return StockExportForm();
    if (selectedSubMenu == "XUẤT HÀNG (BƯỚC 2)") return MTSStockExportStep2();
    if (selectedSubMenu == "KIỂM KÊ SP") return InventoryManagementScreen();
    if (selectedSubMenu == "IN LẠI TEM") return BoxConfirmScreen();

    if (selectedSubMenu == "NHẬP-XUẤT-TỒN KHO")
      return InventoryChartScreen(month: selectedMonth);
    if (selectedSubMenu == "KIỂM KÊ") {
      return QualityChartScreen(month: selectedMonth);
    }
    if (selectedSubMenu == "DỰ BÁO")
      return ForecastTableScreen(month: selectedMonth);
    if (selectedSubMenu == "THỐNG KÊ")
      return InventoryStatisticsScreen(month: selectedMonth);

    if (selectedSubMenu == "DANH SÁCH GOM HÀNG") return GomHangScreen();
    if (selectedSubMenu == "IN TEM GOM HÀNG") return ConfirmShelfScreen();

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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(false),
      body: _buildBody(),
    );
  }
}
