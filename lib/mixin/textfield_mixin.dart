import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class TextFieldMixin {
  Widget textFieldWidget(
      {TextEditingController? controller,
      Color? cursorColor,
      TextInputAction? textInputAction,
      InputDecoration? decoration,
        TextInputType? keyboardType = TextInputType.text,
      Widget? prefixIcon,
      void Function()? onTap,
      Widget? suffixIcon,
      int? maxLines = 1,
      TextCapitalization textCapitalization = TextCapitalization.none,
      String? Function(String?)? validator,
        String? initialValue,
      bool readOnly = false,
      bool obscureText = false,
      InputBorder? focusedBorder,
      String? labelText,
        List<TextInputFormatter>? inputFormatters,
      FocusNode? focusNode,
      TextStyle? labelStyle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: TextFormField(
        cursorColor: AppColor.appBlackColor,
        controller: controller,
        textInputAction: TextInputAction.next,
        initialValue: initialValue,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        focusNode: focusNode,
        validator: validator,onTap: onTap,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontFamily: AppFonts.regular,fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: prefixIcon,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.appColor,
              )),
          labelStyle: const TextStyle(
            color: AppColor.appBlackColor,fontFamily: AppFonts.regular,
          ),
          suffixIcon: suffixIcon,
          labelText: labelText,
        ),
        obscureText: obscureText,
      ),
    );
  }


  Widget textFieldCardWidget(
      {TextEditingController? controller,
        Color? cursorColor,
        TextInputAction? textInputAction,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        void Function(String)? onChanged,
        InputDecoration? decoration,
        Widget? prefixIcon,
        Widget? suffixIcon,
        InputBorder? focusedBorder,
        String? labelText,
        bool obscureText = false,
        TextStyle? labelStyle}) {
    return Card(
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        // height: 60,
        child: TextFormField(
          cursorColor: AppColor.appBlackColor,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontFamily: AppFonts.regular,fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            prefixIcon:prefixIcon,
            suffixIcon: suffixIcon,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.appColor)),
            labelText: labelText,
            labelStyle: const TextStyle(
              color: AppColor.appBlackColor,fontFamily: AppFonts.regular
            ),
          ),
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }


  Widget textFieldProfileWidget(
      {TextEditingController? controller,
        Color? cursorColor,
        TextInputAction? textInputAction,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        void Function(String)? onChanged,
        void Function()? onTap,
        InputDecoration? decoration,
        Widget? prefixIcon,
        Widget? suffixIcon,
        InputBorder? focusedBorder,
        String? labelText,
        bool readOnly = false,
        bool obscureText = false,
        List<TextInputFormatter>? inputFormatters,
        TextStyle? labelStyle}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      margin: const EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey)
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          labelStyle: const TextStyle(color: AppColor.appColor,fontFamily: AppFonts.regular)
        ),
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        controller: controller,
        onTap: onTap,
        validator: validator,
      ),
    );
  }

}
