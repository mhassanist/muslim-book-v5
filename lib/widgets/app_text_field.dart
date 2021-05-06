import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

class AppTextField extends StatelessWidget {
  final bool enabled;

  const AppTextField(
      {Key key,
      this.enabled = true,
      this.hint,
      this.icon,
      this.sizeConfig,
      this.onChanged,
      this.initialValue,
      this.validator,
      this.obscureText = false,
      @required this.formKey,
      this.controller,
      this.nextNode,
      this.inputType = TextInputType.text,
      @required this.currentNode,
      this.textInputAction = TextInputAction.next,
      this.onSubmit})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final String hint;
  final IconData icon;
  final SizingInformation sizeConfig;
  final Function onChanged;
  final String initialValue;
  final Function validator;
  final TextInputType inputType;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode nextNode;
  final FocusNode currentNode;
  final TextInputAction textInputAction;
  final Function onSubmit;

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
          formKey.currentState.validate();
          onChanged();
        },
        validator: validator,
        onFieldSubmitted: textInputAction == TextInputAction.done
            ? onSubmit
            : (s) => FocusScope.of(context).requestFocus(nextNode),
      ),
    );
  }
}
