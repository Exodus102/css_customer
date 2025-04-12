import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool hasError;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.35,
      height: 45,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: hasError ? Colors.red : Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey),
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : const Color(0xFF064089),
              width: 2,
            ),
          ),
          floatingLabelStyle: TextStyle(
            color: hasError
                ? Colors.red
                : const Color(0xFF064089), // Active label text color
            fontWeight: FontWeight.bold, // Optional styling for active label
          ),
        ),
        value: selectedValue,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down_sharp),
        dropdownColor: Colors.white,
      ),
    );
  }
}
