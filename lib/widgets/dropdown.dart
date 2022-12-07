import 'package:flutter/material.dart';

class CategoryDropDownMenuField extends StatefulWidget {
  CategoryDropDownMenuField({super.key, this.selectedValue});
  String? selectedValue;
  @override
  State<CategoryDropDownMenuField> createState() =>
      _CategoryDropDownMenuFieldState();
}

class _CategoryDropDownMenuFieldState extends State<CategoryDropDownMenuField> {
  // String? selectedValue = null;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(),
      items: const [
        DropdownMenuItem(
          child: Text('Adult'),
          value: 'Adult',
        ),
        DropdownMenuItem(
          child: Text('Child'),
          value: 'Child',
        )
      ],
      onChanged: (String? newValue) {
        setState(() {
          widget.selectedValue = newValue;
        });
      },
      validator: (value) => value == null ? "Select passenger Type" : null,
      hint: const Text('Passenger Type'),
    );
  }
}
