//detail_row_widget.dart
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DetailRowWidget<T> extends StatelessWidget {
  final String title;
  final T? selectedItem;
  final Key dropDownKey;
  final List<T> items;
  final Function(T?)? onSaved;
  final bool enabled; // ✅ เพิ่มพารามิเตอร์ใหม่

  const DetailRowWidget({
    super.key,
    required this.title,
    required this.dropDownKey,
    required this.selectedItem,
    required this.items,
    this.onSaved,
    this.enabled = true, // ✅ ค่า default
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 120, child: Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 14))),
          Expanded(
            child: SizedBox(
              height: 40,
              child: DropdownSearch<T>(
                key: dropDownKey,
                enabled: enabled, // ✅ เพิ่มตรงนี้
                selectedItem: selectedItem,
                items: (filter, infiniteScrollProps) => items,
                onChanged: enabled ? onSaved : null, // ✅ ปิด onSaved ถ้า disabled
                compareFn: (item, selectedItem) => item == selectedItem,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                    border: const OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  cacheItems: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(hintText: 'Search', hintStyle: TextStyle(color: Colors.grey.shade400)),
                  ),
                  showSelectedItems: false,
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: const BoxConstraints(maxHeight: 200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
