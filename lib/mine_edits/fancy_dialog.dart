import 'package:flutter/material.dart';

class FancyGif {
  static const String checkMail = 'CHECK_MAIL';
  static const String funnyMan = 'FUNNY_MAN';
  static const String moveForward = 'MOVE_FORWARD';
  static const String playMedia = 'PLAY_MEDIA';
  static const String submit = 'SUBMIT';
  static const String share = 'SHARE';
}

class FancyDialog extends StatefulWidget {
  const FancyDialog({
    required this.title,
    required this.description,
    this.okFun,
    this.titleTextStyle = const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    this.descriptionTextStyle = const TextStyle(color: Colors.grey, fontSize: 15),
    this.cancelFun,
    this.animationType = 1,
    this.gifPath = FancyGif.moveForward,
    this.cancelColor = Colors.grey,
    this.okColor = Colors.pink,
    this.ok = " OK !",
    this.cancel = "Cancel",
    this.defaultButtons = true,
    this.actionButtons,
    this.theme = 0, //default theme is fancy
    super.key,
  });

  final String? title;
  final String? description;
  final Function? okFun;
  final Function? cancelFun;
  final int? animationType;
  final String? gifPath;
  final Color? okColor;
  final Color? cancelColor;
  final String? ok;
  final String? cancel;
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final int? theme; // 0: fancy , 1:flat
  final bool defaultButtons;
  final Widget? actionButtons;

  @override
  GifDialogState createState() {
    return GifDialogState();
  }
}

class GifDialogState extends State<FancyDialog> with TickerProviderStateMixin {
  AnimationController? ac;
  Animation? animation;
  double? width;
  double? height;
  int animationAxis = 0; // 0 for x 1 for y

  String? title;
  String? description;
  Function? okFun;
  Function? cancelFun;
  String? gifPath;
  Color? okColor;
  Color? cancelColor;
  TextStyle? titleTextStyle;
  TextStyle? descriptionTextStyle;
  String? ok;
  String? cancel;
  int? theme;
  bool? defaultButtons;
  Widget? actionButtons;

  @override
  void initState() {
    title = widget.title;
    description = widget.description;
    okFun = widget.okFun ?? (){};
    cancelFun = widget.cancelFun ?? (){};
    okColor = widget.okColor;
    cancelColor = widget.cancelColor;
    gifPath = widget.gifPath;
    ok = widget.ok;
    cancel = widget.cancel;
    theme = widget.theme;
    titleTextStyle = widget.titleTextStyle;
    descriptionTextStyle = widget.descriptionTextStyle;
    defaultButtons = widget.defaultButtons;
    actionButtons = widget.actionButtons;

    if (gifPath == 'CHECK_MAIL') {
      gifPath = 'gif3.gif';
    } else if (gifPath == 'FUNNY_MAN') {
      gifPath = 'gif1.gif';
    } else if (gifPath == 'MOVE_FORWARD') {
      gifPath = 'gif4.gif';
    } else if (gifPath == 'PLAY_MEDIA') {
      gifPath = 'gif2.gif';
    } else if (gifPath == 'SUBMIT') {
      gifPath = 'gif5.gif';
    } else if (gifPath == 'SHARE') {
      gifPath = 'gif6.gif';
    }
    double? start;
    int animationType = widget.animationType!;
    switch (animationType) {
      case 1:
        {
          start = -1.0;
          break;
        }
      case -1:
        {
          start = 1.0;
          break;
        }
      case 2:
        {
          start = -1.0;
          break;
        }
      case -2:
        {
          start = 1.0;
          break;
        }
    }
    if (animationType.abs() == 2) animationAxis = 1;
    ac =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = Tween(begin: start, end: 0.0)
        .animate(CurvedAnimation(parent: ac!, curve: Curves.easeIn));
    animation!.addListener(() {
      setState(() {});
    });

    ac!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!defaultButtons!) assert(actionButtons != null, '\n***actionButtons cannot be null when defaultButtons is false***\n');
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var dialogWidth = 0.36 * height!;

    assert(title != null, '\n****title is required***\n');
    assert(description != null, '\n****description is required***\n');

    var image = ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme == 0 ? 15 : 0),
          topRight: Radius.circular(theme == 0 ? 15 : 0)),
      child: Image.asset(
        'assets/fancy_dialog/$gifPath',
        fit: BoxFit.fill,
        width: dialogWidth * 1.1, // dialogWidth will get left/right margin?
        height: dialogWidth * 0.6,
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme == 0 ? 15 : 0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: dialogWidth,
          transform: Matrix4.translationValues(
              animationAxis == 0 ? animation!.value * width : 0,
              animationAxis == 1 ? animation!.value * width : 0,
              0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme == 0 ? 15 : 0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              image,
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  title!,
                  style: titleTextStyle,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    description!,
                    style: descriptionTextStyle,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  )),
              widget.defaultButtons
                  ? Row(
                    mainAxisAlignment: theme == 1
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      theme == 0
                          ? customButton(cancel!, cancelColor!, cancelFun!)
                          : flatButton(cancel!, cancelColor!, cancelFun!),
                      SizedBox(
                        width: 10,
                      ),
                      theme == 0
                          ? customButton(ok!, okColor!, okFun!)
                          : flatButton(ok!, okColor!, okFun!)
                    ],
                  )
                  : actionButtons!
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(String t, Color c, Function f) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        backgroundColor: c,
      ),
      child: Text(
        t,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      onPressed: () {
        f();
        Navigator.of(context).pop();
      },
    );
  }

  Widget flatButton(String t, Color c, Function f) {
    return ElevatedButton(
      child: Text(
        t,
        style: TextStyle(color: c, fontSize: 15),
      ),
      onPressed: () {
        f();
        Navigator.of(context).pop();
      },
    );
  }
}
