import 'package:base_app/quran/models/reciters_model.dart';
import 'package:base_app/quran/provider/quran_provider.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:base_app/widgets/app_scaffold_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuranSettingsGeneratedListView extends StatefulWidget {
  final List<QuranTypeData> generatedList;
  final String title;
  final Function onChange;
  final Function onDownLoad;
  final Map<dynamic, dynamic> downloadedMap;
  final groupValue;
  final QuranProvider provider;
  const QuranSettingsGeneratedListView(
      {Key key,
      this.generatedList,
      this.title,
      this.onChange,
      this.groupValue,
      this.onDownLoad,
      this.downloadedMap,
      @required this.provider})
      : super(key: key);
  @override
  _QuranSettingsGeneratedListViewState createState() =>
      _QuranSettingsGeneratedListViewState();
}

class _QuranSettingsGeneratedListViewState
    extends State<QuranSettingsGeneratedListView> {
  final Color prymaryColor = const Color(0XFF347D53);
  Map<dynamic, dynamic> downloadedMap;
  var groupValue;
  @override
  void initState() {
    groupValue = widget.groupValue;
    downloadedMap = widget.downloadedMap;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width);
    return AppScaffold(
        title: AppScaffoldTitleWidget(title: widget.title),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (c, index) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
              title: Text(
                widget.generatedList[index].name,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Text(widget.generatedList[index].englishName),
              onTap: () async {
                if (downloadedMap == null) {
                  onChange(index);
                } else {
                  if (downloadedMap
                      .containsKey(widget.generatedList[index].identifier)) {
                    onChange(index);
                  } else {
                    await widget.onDownLoad(index);
                    setState(() {
                      groupValue = "${widget.generatedList[index].identifier}";
                      downloadedMap["widget.generatedList[index].identifier"] =
                          "${widget.generatedList[index].identifier}";
                    });
                  }
                }
              },
              trailing: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(30),
                  color: Colors.white,
                  child: getChild(index)),
            );
          },
          itemCount:
              widget.generatedList == null ? 0 : widget.generatedList.length,
        ));
  }

  void onChange(int index) {
    widget.onChange(widget.generatedList[index].identifier);
    setState(() {
      groupValue = widget.generatedList[index].identifier;
    });
  }

  Widget getChild(index) {
    if (downloadedMap == null) {
      return groupValue == widget.generatedList[index].identifier
          ? SvgPicture.asset("assets/images/quran_view/check_circle.svg")
          : SvgPicture.asset("assets/images/quran_view/empty_circle.svg");
    } else {
      return downloadedMap.containsKey(widget.generatedList[index].identifier)
          ? groupValue == widget.generatedList[index].identifier
              ? SvgPicture.asset("assets/images/quran_view/check_circle.svg")
              : SvgPicture.asset("assets/images/quran_view/empty_circle.svg")
          : Container(
              width: ScreenUtil().setWidth(30),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: prymaryColor),
              child: FittedBox(
                  child: Icon(
                Icons.file_download,
                color: Colors.white,
              )),
            );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
