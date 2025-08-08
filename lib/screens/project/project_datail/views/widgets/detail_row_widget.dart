import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DetailRowWidget<T> extends StatelessWidget {
  final String title;
  final T? selectedItem;
  final Key dropDownKey;
  final List<T> items;
  final Function(T?)? onSaved;
  const DetailRowWidget({super.key, required this.title, required this.dropDownKey, required this.selectedItem, required this.items, this.onSaved});

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
                selectedItem: selectedItem,
                items: (filter, infiniteScrollProps) => items,
                onChanged: onSaved,
                compareFn: (item, selectedItem) => item == selectedItem, // หรือใช้ id ถ้ามี
                decoratorProps: DropDownDecoratorProps(
                
                  
                  decoration: InputDecoration(
                    
                    contentPadding: const EdgeInsets.only(left: 12, right: 12,top: 0, bottom: 0),
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  cacheItems: true,
                  searchFieldProps: TextFieldProps(decoration: InputDecoration(hintText: 'Search', hintStyle: TextStyle(color: Colors.grey.shade400))),
                  showSelectedItems: false,
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
