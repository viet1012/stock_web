import 'package:flutter/material.dart';

class BoxListPanel extends StatelessWidget {
  final List<Map<String, dynamic>> displayedBoxes;
  final String? selectedBoxId;
  final Function(String boxId, int qtyStock) onSelectBox;

  const BoxListPanel({
    super.key,
    required this.displayedBoxes,
    required this.selectedBoxId,
    required this.onSelectBox,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ['Firsttime', 'BoxID', 'QtyStock', 'CheckSt', 'ShelfID'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 🔹 Header
          Container(
            color: Colors.indigo.shade700,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: columns
                  .map(
                    (c) => Expanded(
                      child: Text(
                        c,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // 🔹 Body
          Expanded(
            child: displayedBoxes.isEmpty
                ? const Center(child: Text('Không có box nào trong kệ chờ'))
                : ListView.builder(
                    itemCount: displayedBoxes.length,
                    itemBuilder: (ctx, i) {
                      final box = displayedBoxes[i];
                      final isSelected = box['BoxID'] == selectedBoxId;
                      final qtyStock = box['QtyStock'] ?? 0;

                      return GestureDetector(
                        onTap: () => onSelectBox(box['BoxID'], qtyStock),
                        child: Container(
                          color: isSelected
                              ? Colors.yellow.shade100
                              : i.isEven
                              ? Colors.white
                              : Colors.grey.shade50,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: columns.map((col) {
                              final val = box[col]?.toString() ?? '';
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    val,
                                    textAlign: col == 'QtyStock'
                                        ? TextAlign.right
                                        : TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.blue.shade800
                                          : Colors.black,
                                    ),
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
