import 'package:flutter/material.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AppTextField extends StatelessWidget {
  final bool enabled;

  const AppTextField({
    super.key,
    this.enabled = true,
    this.hint,
    this.icon,
    required this.sizeConfig,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.obscureText = false,
    this.formKey,
    this.controller,
    this.nextNode,
    this.inputType = TextInputType.text,
    this.currentNode,
    this.textInputAction = TextInputAction.next,
    this.onSubmit,
  });

  final GlobalKey<FormState>? formKey;
  final String? hint;
  final IconData? icon;
  final SizingInformation sizeConfig;
  final Function? onChanged;
  final String? initialValue;
  final FormFieldValidator? validator;
  final TextInputType inputType;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? nextNode;
  final FocusNode? currentNode;
  final TextInputAction textInputAction;
  final Function? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 80,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: sizeConfig.blockSizeHorizontal * 4,
        ),
        enabled: enabled,
        cursorColor: Colors.green,
        obscureText: obscureText,
        autofocus: false,
        keyboardType: inputType,
        focusNode: currentNode,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: sizeConfig.blockSizeHorizontal * 5,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: sizeConfig.blockSizeHorizontal * 4,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (s) {
          if (formKey != null) {
            formKey!.currentState!.validate();
          }
          onChanged?.call();
        },
        validator: validator,
        onFieldSubmitted: textInputAction == TextInputAction.done
            ? onSubmit?.call
            : (s) => FocusScope.of(context).requestFocus(nextNode),
      ),
    );
  }
}
