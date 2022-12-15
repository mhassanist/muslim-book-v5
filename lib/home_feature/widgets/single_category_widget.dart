import 'package:flutter/material.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SingleCategoryWidget extends StatefulWidget {
  SingleCategoryWidget({Key key, this.sizeConfig, this.categoryDetails})
      : super(key: key);
  final SizingInformation sizeConfig;
  final Map<String, dynamic> categoryDetails;
  @override
  _SingleCategoryWidgetState createState() => _SingleCategoryWidgetState();
}

class _SingleCategoryWidgetState extends State<SingleCategoryWidget> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: widget.categoryDetails["onTap"],
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0XFFF1F6F3),
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0XFF347D53),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                widget.categoryDetails["icon"],
                width: widget.sizeConfig.blockSizeHorizontal * 18,
                fit: BoxFit.cover,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            Container(
              margin: EdgeInsets.all(widget.sizeConfig.blockSizeHorizontal * 4),
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        widget.categoryDetails["name"],
                        style: TextStyle(
                            color: const Color(0XFF347D53),
                            fontWeight: FontWeight.bold,
                            fontSize:
                                widget.sizeConfig.blockSizeHorizontal * 5),
                      ),
                    ),
                    SizedBox(
                      height: widget.sizeConfig.blockSizeVertical / 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
