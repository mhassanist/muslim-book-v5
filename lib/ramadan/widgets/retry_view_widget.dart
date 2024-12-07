import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:flutter/material.dart';

class RetryViewWidget extends StatefulWidget {
  final ViewStateProvider provider;
  final VoidCallback? function;
  final String text;

  const RetryViewWidget({
    super.key,
    required this.provider,
    this.function,
    this.text = '',
  });

  @override
  _RetryViewWidgetState createState() => _RetryViewWidgetState();
}

class _RetryViewWidgetState extends State<RetryViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    if (widget.provider.mounted) {
      Future.delayed(Duration(milliseconds: 300), widget.function?.call);
    }
    super.dispose();
  }
}

