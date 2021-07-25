import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class AddWidgetEdit extends StatefulWidget {
  final String title;
  final String buttomTitle;
  final Function exit;
  final bannerName;
  final Widget mainView ;

  const AddWidgetEdit({
    Key key,
    this.title,
    this.bannerName,
    this.buttomTitle,
    this.exit, this.mainView,
  }) : super(key: key);

  @override
  _AddWidgetEditState createState() => _AddWidgetEditState();


}

class _AddWidgetEditState extends State<AddWidgetEdit> {

   @override
  void initState() {

  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: (MediaQuery.of(context).size.height / 1.8),
        width: (MediaQuery.of(context).size.width),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context).translate("Exit") + this.widget.title,
                  style: GoogleFonts.almarai(
                      color: Constants.PRIMARY_DARK_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Expanded(
                  child:
                      Container(child:AdMobRectangle(widget.bannerName  ))),
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Constants.PRIMARY_DARK_COLOR,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                            child: Center(
                                child: Text(
                                  this.widget.buttomTitle,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              if (widget.title == "المسابقه" ||
                                  widget.title == "المسابقات") {
                                this.widget.exit();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.5,
                                  color: Constants.PRIMARY_DARK_COLOR,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(5, 5),
                                  blurRadius: 7,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate("Exit_from"),
                                style: TextStyle(
                                  color: Constants.PRIMARY_DARK_COLOR,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ),
                          ),)


                      ])),

              SizedBox(
                height: 15,
              ),

            ]));
  }
}
