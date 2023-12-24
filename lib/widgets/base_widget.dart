import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/locator.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  const BaseView({
    super.key,
    required this.builder,
    T? viewModel,
    this.onModelReady,
  });

  final Widget Function(BuildContext context, T value, Widget? child) builder;

  final Function(T)? onModelReady;

  @override
  State<BaseView<T>> createState() => _BaseWidget<T>();
}

class _BaseWidget<T extends ChangeNotifier> extends State<BaseView<T>> {
  final T _viewModel = locator<T>();

  @override
  void initState() {
    super.initState();
    widget.onModelReady?.call(_viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => _viewModel,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
