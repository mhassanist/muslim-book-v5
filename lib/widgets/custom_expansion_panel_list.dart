import 'package:flutter/material.dart';

const double _kPanelHeaderCollapsedHeight = 48.0;
// const double _kPanelHeaderExpandedHeight = 64.0;

class CustomExpansionPanelList extends StatelessWidget {
  const CustomExpansionPanelList({
    super.key,
    this.children: const <ExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration: kThemeAnimationDuration,
  });

  final List<ExpansionPanel> children;
  final ExpansionPanelCallback? expansionCallback;
  final Duration animationDuration;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    // const EdgeInsets kExpandedEdgeInsets = const EdgeInsets.symmetric(
    //     vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 - 1),
          height: 15.0,
          color: Colors.transparent,
        ));

      final Row header = new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new AnimatedContainer(
              duration: animationDuration,
              curve: Curves.fastOutSlowIn,
              // margin: _isChildExpanded(index)
              //     ? kExpandedEdgeInsets
              //     : EdgeInsets.zero,
              child: new SizedBox(
                height: _kPanelHeaderCollapsedHeight,
                child: children[index].headerBuilder(
                  context,
                  children[index].isExpanded,
                ),
              ),
            ),
          ),
          new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  // topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  // bottomLeft: Radius.circular(12),
                ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                    ])),
            child: new ExpandIcon(
              isExpanded: _isChildExpanded(index),
              onPressed: (bool isExpanded) {
                expansionCallback?.call(index, isExpanded);
              },
            ),
          ),
        ],
      );

      // double _radiusValue = _isChildExpanded(index) ? 8.0 : 0.0;
      items.add(
        new Container(
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 6), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            color: const Color(0XFF347D53),
            // gradient: LinearGradient(
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     colors: [
            //       const Color(0XFF347D53),
            //       const Color(0XFF6BCF96),
            //     ])
          ),
          key: new _SaltedKey<BuildContext, int>(context, index * 2),
          child: Column(
            children: <Widget>[
              Container(
                child: header,
              ),
              new AnimatedCrossFade(
                firstChild: new Container(height: 0.0),
                secondChild: children[index].body,
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: animationDuration,
              ),
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && index != children.length - 1)
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 + 1),
          height: 15.0,
        ));
    }

    return new Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}
