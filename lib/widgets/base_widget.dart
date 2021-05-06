import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/locator.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  BaseView({Key key, this.builder, T viewModel, this.onModelReady})
      : super(key: key);
  final Widget Function(BuildContext context, T value, Widget child) builder;

  final Function(T) onModelReady;
  @override
  _BaseWidget<T> createState() => _BaseWidget<T>();
}

class _BaseWidget<T extends ChangeNotifier> extends State<BaseView<T>> {
  T _viewModel = locator<T>();
  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null) widget.onModelReady(_viewModel);
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
