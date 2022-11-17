import 'package:base_app/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  BaseView({
    super.key,
    required this.builder,
    required T viewModel,
    this.onModelReady,
  });
  final Widget Function(BuildContext context, T value, Widget? child) builder;

  final Function(T)? onModelReady;

  @override
  _BaseWidget<T> createState() => _BaseWidget<T>();
}

class _BaseWidget<T extends ChangeNotifier> extends State<BaseView<T>> {
  T _viewModel = locator<T>();
  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null) widget.onModelReady?.call(_viewModel);
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
