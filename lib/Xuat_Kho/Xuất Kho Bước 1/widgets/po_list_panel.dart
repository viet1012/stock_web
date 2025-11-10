import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class POListPanel extends StatelessWidget {
  final List<Map<String, dynamic>> filteredOrderList;
  final String? selectedPOBoxId;
  final Function(Map<String, dynamic>) onSelectPO;
  final Function() onClearAll;

  const POListPanel({
    super.key,
    required this.filteredOrderList,
    required this.selectedPOBoxId,
    required this.onSelectPO,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final columns = [
      'SPO No',
      'PartID',
      'PName',
      'QtyPO',
      'QtyInOut',
      'ShelfIDWait',
      'BoxIDStock',
      'Status',
      'Remark',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomButton(
                label: 'Xóa tất cả',
                color: Colors.red.shade600,
                icon: Icons.delete_forever,
                onPressed: onClearAll,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredOrderList.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu'))
                : ListView.builder(
                    itemCount: filteredOrderList.length,
                    itemBuilder: (ctx, i) {
                      final po = filteredOrderList[i];
                      final isSelected = po['POCode'] == selectedPOBoxId;
                      return GestureDetector(
                        onTap: () => onSelectPO(po),
                        child: Container(
                          color: isSelected
                              ? Colors.yellow.shade100
                              : i.isEven
                              ? Colors.grey.shade50
                              : Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: columns.map((c) {
                              final val = po[c]?.toString() ?? '';
                              return Expanded(
                                child: Text(
                                  val,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.indigo
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
