import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditableTextFormField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final TextEditingController controller;

  const EditableTextFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            readOnly: true,
            onTap: onTap,
            decoration: const InputDecoration(
              hintText: 'Tap to edit',
              suffixIcon: Icon(
                CupertinoIcons.chevron_forward,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
