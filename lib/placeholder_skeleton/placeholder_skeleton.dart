import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class PlaceholderSkeleton extends StatelessWidget {
  const PlaceholderSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
