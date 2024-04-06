import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';

class InputDecimal extends StatelessWidget {
  const InputDecimal({
    super.key,
    required this.controller,
    required this.label,
    required this.keyboard,
    this.capital,
    this.icon,
    this.maxLength,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboard;
  final IconData? icon;
  final bool? capital;
  final int? maxLength;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
      ],
      maxLength: maxLength ?? 9999,
      //validator: (value) => value!.isEmpty ? '' : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Input tidak boleh kosong';
        }
        return null;
      },
      controller: controller,
      style: const TextStyle(fontSize: 16.0),
      keyboardType: keyboard,
      textCapitalization: capital != null
          ? TextCapitalization.characters
          : TextCapitalization.none,
      decoration: InputDecoration(
        counterText: "",
        errorStyle: const TextStyle(
            fontSize: 0.01), //sengaja agar saat error tidak menambah margin
        contentPadding: const EdgeInsets.only(top: 15, left: 15),
        hintText: label,
        hintStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: formColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        prefixIcon: icon != null
            ? Icon(
                icon,
                size: 20,
                color: Colors.black26,
              )
            : null,
      ),
    );
  }
}

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.controller,
    required this.label,
    required this.keyboard,
    this.capital,
    this.icon,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboard;
  final IconData? icon;
  final bool? capital;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength ?? 9999,
      validator: (value) => value!.isEmpty ? '' : null,
      style: const TextStyle(fontSize: 16.0),
      controller: controller,
      keyboardType: keyboard,
      textCapitalization: capital != null
          ? TextCapitalization.characters
          : TextCapitalization.none,
      decoration: InputDecoration(
        counterText: "",
        errorStyle: const TextStyle(
            fontSize: 0.01), //sengaja agar saat error tidak menambah margin
        contentPadding: const EdgeInsets.only(top: 15, left: 15),
        hintText: label,
        hintStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: formColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        prefixIcon: icon != null
            ? Icon(
                icon,
                size: 20,
                color: Colors.black26,
              )
            : null,
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  const TextArea({
    super.key,
    required this.controller,
    required this.label,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 16.0),
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: null,
      // maxLength: maxLength ?? 9999,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 35, left: 15),
        filled: true,
        alignLabelWithHint: true,
        fillColor: formColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: formBorder)),
      ),
    );
  }
}
