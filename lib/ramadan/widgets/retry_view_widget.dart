// import 'package:base_app/providers/view_state_provider.dart';
// import 'package:flutter/material.dart';
//
// class RetryViewWidget extends StatefulWidget {
//   final ViewStateProvider provider;
//   final Function function;
//   final String text;
//
//   const RetryViewWidget({Key key, this.provider, this.function, this.text})
//       : super(key: key);
//
//   @override
//   _RetryViewWidgetState createState() => _RetryViewWidgetState();
// }
//
// class _RetryViewWidgetState extends State<RetryViewWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//
//   @override
//   void dispose() {
//     if (widget.provider.mounted) {
//       Future.delayed(Duration(milliseconds: 300), widget.function);
//     }
//     super.dispose();
//   }
// }
//
