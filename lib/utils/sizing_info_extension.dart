import 'package:responsive_builder/responsive_builder.dart';

extension BlockSizing on SizingInformation{
  double get blockSizeHorizontal => this.screenSize.width/100;
  double get blockSizeVertical  => this.screenSize.height/100;
}