import 'package:delivery_app/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final InputBorder? isBorder;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final void Function()? onTapSuffix;
  final InputBorder? focusedBorder;
  final InputBorder? enableBoder;
  final EdgeInsetsGeometry? textFieldPadding;
  final void Function(String)? onChanged;
  bool? backFilled = false;
  bool? fieldReadOnly;
  final void Function()? ontap;
  int? isMaxLine = 1;
  int? isMinLine = 1;
  CustomTextFormField(
      {super.key, required this.hintText,
      this.suffixIcon,
      this.obscureText = false,
      required this.controller,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.onTapSuffix,
      this.prefixIcon,
      this.focusedBorder,
      this.enableBoder,
      this.textFieldPadding,
      this.onChanged,
      this.isBorder,
      this.backFilled,
      this.isMaxLine,
      this.isMinLine,
      this.ontap,
      this.fieldReadOnly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: isMaxLine,
      minLines: isMinLine,
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.aBeeZee(
        fontSize: 15
      ),
      validator: validator,
      keyboardType: keyboardType,
      readOnly: fieldReadOnly ?? false,
      onChanged: onChanged,
      onTap: ontap,
      decoration: InputDecoration(
        contentPadding: textFieldPadding ?? EdgeInsets.all(6),
        hintText: hintText,
        filled: backFilled,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.aBeeZee(
        fontSize: 10
      ),
        enabledBorder: enableBoder,
        focusedBorder: focusedBorder,
        prefixIcon: prefixIcon != null
            ? Icon(
                suffixIcon,
                color: darkColor,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: onTapSuffix, icon: Icon(suffixIcon))
            : null,
        border: isBorder ??
            OutlineInputBorder(
                borderSide: const BorderSide(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}