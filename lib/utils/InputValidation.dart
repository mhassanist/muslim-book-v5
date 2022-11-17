import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';

class InputValidation{
 static String? emailValidation(TextEditingController controller,context) {
    if (controller.text.trim().isEmpty)
      return AppLocalizations.of(context).translate("email_shouldnt_be_empty");
    else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(controller.text.trim()))
      return AppLocalizations.of(context).translate("email_is_wrong");
    return null;
  }

 static String? passwordValidation(TextEditingController controller,context) {
    if (controller.text.trim().isEmpty)
      return AppLocalizations.of(context)
          .translate("password_shouldnt_be_empty");
    if (controller.text.trim().length < 6)
      return AppLocalizations.of(context).translate("password_should_be_long");
    else
      return null;
  }

 static String? confirmPasswordValidation(TextEditingController controller,TextEditingController password,context) {
   if (controller.text.trim().isEmpty)
     return AppLocalizations.of(context)
         .translate("password_shouldnt_be_empty");
   else if (controller.text.trim() != password.text.trim())
     return AppLocalizations.of(context)
         .translate("passwords_should_be_identical");
   else
     return null;
 }


 static String? userNameValidation(TextEditingController controller,context) {
   if (controller.text.trim().isEmpty)
     return AppLocalizations.of(context)
         .translate("user_name_shouldnt_be_empty");
   else
     return null;
 }


 static String? phoneValidation(TextEditingController controller,context) {
   if (controller.text.trim().isEmpty)
     return AppLocalizations.of(context)
         .translate("mobile_shouldnt_be_empty");

   String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
   RegExp regExp = new RegExp(patttern);
   if (!regExp.hasMatch(controller.text.trim()))
     return AppLocalizations.of(context).translate("phone_is_wrong");
   return null;
 }
}