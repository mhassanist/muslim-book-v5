import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                image: DecorationImage(
                    image: AssetImage('assets/images/hossam.png'),
                    fit: BoxFit.fill)),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/untitled_1.png'),
                    fit: BoxFit.fill)),
          ),
          Container(
            height: 40,
            width: 40,
            child: SvgPicture.asset(
              "assets/icons/iconappbar.svg",
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
