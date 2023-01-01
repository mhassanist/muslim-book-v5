import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/sebha_feature/offline_sebha/database/sebha_database.dart';
import 'package:muslim_book/sebha_feature/online_sebha/controllers/online_sebha_controller.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Value;
// import 'package:moor_flutter/moor_flutter.dart';
// import 'package:get/get.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';

class NewTasbeehView extends StatefulWidget {
  final SizingInformation sizeConfig;
  final bool isLocal;
  const NewTasbeehView({super.key, required this.sizeConfig, this.isLocal = true,});

  @override
  _NewTasbeehViewState createState() => _NewTasbeehViewState();
}

class _NewTasbeehViewState extends State<NewTasbeehView> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController(text: "100");
  @override
  void initState() {
    super.initState();
    _numberController.addListener(() {
      final text = _numberController.text.toLowerCase();
      _numberController.value = _numberController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: widget.sizeConfig.blockSizeHorizontal * 4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: widget.sizeConfig.blockSizeVertical * 3,
                          horizontal:
                              widget.sizeConfig.blockSizeHorizontal * 5),
                      child: Text(
                        "أكتب الذكر",
                        style: TextStyle(
                            color: Constants.PRIMARY_DARK_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                widget.sizeConfig.blockSizeHorizontal * 6),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              widget.sizeConfig.blockSizeHorizontal * 4.5),
                      width: double.infinity,
                      child: TextField(
                        controller: _nameController,
                        minLines: 4,
                        maxLines: 4,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                    widget.sizeConfig.blockSizeHorizontal * 5,
                                vertical:
                                    widget.sizeConfig.blockSizeHorizontal * 5),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.PRIMARY_COLOR),
                                borderRadius: BorderRadius.circular(
                                    widget.sizeConfig.blockSizeHorizontal * 5)),
                            fillColor: Colors.white,
                            filled: true),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: widget.sizeConfig.blockSizeHorizontal * 5,
                          vertical: widget.sizeConfig.blockSizeVertical),
                      child: Text(
                        "عدد مرات التكرار",
                        style: TextStyle(
                            fontSize: widget.sizeConfig.blockSizeHorizontal * 6,
                            color: Constants.PRIMARY_DARK_COLOR,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: widget.sizeConfig.blockSizeHorizontal * 5,
                          horizontal:
                              widget.sizeConfig.blockSizeHorizontal * 5),
                      child: Row(
                        children: <Widget>[
                          buildIconButton(Icons.add, () {
                            _numberController.text =
                                "${int.parse(_numberController.text) + 1}";
                          }),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      widget.sizeConfig.blockSizeHorizontal *
                                          4.5),
                              width: double.infinity,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                controller: _numberController,
                                minLines: 1,
                                maxLines: 1,
                                onChanged: (s) {
                                  if (isNumeric(s))
                                    _numberController.text = s;
                                  else
                                    _numberController.text = "10";
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: widget
                                              .sizeConfig.blockSizeHorizontal *
                                          5,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.PRIMARY_COLOR),
                                        borderRadius: BorderRadius.circular(
                                            widget.sizeConfig
                                                    .blockSizeHorizontal *
                                                2)),
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                            ),
                          ),
                          buildIconButton(Icons.remove, () {
                            if (int.parse(_numberController.text) > 3)
                              _numberController.text =
                                  "${int.parse(_numberController.text) - 1}";
                          }),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              widget.sizeConfig.blockSizeHorizontal * 10,
                          vertical: widget.sizeConfig.blockSizeVertical * 3),
                      child: RawMaterialButton(
                        padding: EdgeInsets.symmetric(
                            vertical: widget.sizeConfig.blockSizeVertical * 2),
                        onPressed: () async {
                          await saveZikr();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate("addZekr"),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  widget.sizeConfig.blockSizeHorizontal * 4),
                        ),
                        shape: StadiumBorder(),
                        fillColor: const Color(0XFF347D53),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIconButton(IconData icon, Function function) {
    return Container(
      margin: EdgeInsets.only(
          left: widget.sizeConfig.blockSizeHorizontal * 3,
          right: widget.sizeConfig.blockSizeHorizontal * 3),
      width: widget.sizeConfig.blockSizeHorizontal * 12,
      height: widget.sizeConfig.blockSizeHorizontal * 12,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Constants.ICON_COLOR,
          onPressed: () => function.call(),
          child: FittedBox(
            child: Icon(
              icon,
              size: widget.sizeConfig.blockSizeHorizontal * 13,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future saveZikr() async {
    if (_numberController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty) {
      showSnackBar();
    } else {
      if (widget.isLocal)
        await locator<SebhaDataBase>().addTasbeeh(
          TsabeehCompanion(
            totalCounter: Value(int.parse(_numberController.text.trim())),
            counted: Value(0),
            name: Value(_nameController.text.trim()),
            note: Value(""),
          ),
        );
      else {
        await Provider.of<OnlineSebhaProvider>(context, listen: false)
            .addNewTasbeeh(
                _nameController.text.trim(), _numberController.text.trim());
      }

      Navigator.pop(context);
    }
  }

  void showSnackBar() {
    Get.snackbar(AppLocalizations.of(context)!.translate("fillAllField"), AppLocalizations.of(context)!.translate("fillAllField"),
        backgroundColor: Constants.PRIMARY_COLOR,
        colorText: Colors.white,
        borderRadius: 0,
        margin: EdgeInsets.zero,
        snackPosition: SnackPosition.BOTTOM);
  }
}
