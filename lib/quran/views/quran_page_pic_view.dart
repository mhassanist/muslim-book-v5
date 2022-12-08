import 'dart:typed_data';

import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/quran/provider/quran_pages_pic_bloc.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranPagePicView extends StatefulWidget {
  final int quranPage;
  const QuranPagePicView(this.quranPage, {Key key}) : super(key: key);

  @override
  State<QuranPagePicView> createState() => _QuranPagePicViewState();
}

class _QuranPagePicViewState extends State<QuranPagePicView> with TickerProviderStateMixin{

  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;
  Uint8List quranPagePic;
  bool _visible = true;
  int _currentPageNumber;
  AnimationController _controller;
  AnimationController _linearProgressController;
  String directory;


  @override
  void initState() {
    _currentPageNumber = widget.quranPage;
    //save current page to local storage
    saveCurrentPage();
    QuranPagesPicBloc().downloadQuranSinglePage(widget.quranPage).then((value) {
        setState(() {
          quranPagePic = value;
        });
    });
    QuranPagesPicBloc().checkIfFullQuranDownloaded();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _linearProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });
    _linearProgressController.repeat(reverse: false);

    super.initState();
  }

  void saveCurrentPage() {
    SharedPreferences.getInstance().then((pref){
      pref.setInt("LAST_READ_PAGE", _currentPageNumber);
    });
  }
  @override
  void dispose() {
     _linearProgressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    QuranPagesPicBloc _quranPagesBloc = Provider.of<QuranPagesPicBloc>(context);
    
    if(_quranPagesBloc.currentPageState == APIStatus.initial || _quranPagesBloc.currentPageState == APIStatus.loading){
      return AppScaffold(
        title: Text(
          AppLocalizations.of(context).translate("Loading_moshaf"),
          style: GoogleFonts.almarai(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        padding: EdgeInsets.all(0),
        child: Container(
          color: Color(0XFF347D53),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loading(
                  indicator: BallBeatIndicator(),
                  size: 70.0,
                  color: Colors.white,
                ),
                Text(
                  AppLocalizations.of(context).translate("Loading_quran"),
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      );
    }else{
      return SafeArea(
        child: Scaffold(
          body: GestureDetector(
              onTap: () => setState(() => _visible = !_visible),
              onVerticalDragStart: (dragDetails) {
                startVerticalDragDetails = dragDetails;
              },
              onVerticalDragUpdate: (dragDetails) {
                updateVerticalDragDetails = dragDetails;
              },
              onVerticalDragEnd: (endDetails) {
                double dx = updateVerticalDragDetails.globalPosition.dx -
                    startVerticalDragDetails.globalPosition.dx;

                if (dx < 0 && _currentPageNumber > 1) {
                  QuranPagesPicBloc().downloadQuranSinglePage(_currentPageNumber-1).then((value) {
                    setState(() {
                      quranPagePic = value;
                      _currentPageNumber = _currentPageNumber-1;
                    });
                    saveCurrentPage();

                  });
                }
                else if (dx > 0 && _currentPageNumber < 604) {
                  QuranPagesPicBloc().downloadQuranSinglePage(_currentPageNumber+1).then((value) {
                    setState(() {
                      quranPagePic = value;
                      _currentPageNumber = _currentPageNumber+1;
                    });
                    saveCurrentPage();

                  });
                }
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  quranPagePic == null
                      ? Container()
                      : Image.memory(
                          quranPagePic,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fill,
                        ),
                  Container(
                    height: 50,
                    child: SlidingAppBar(
                      controller: _controller,
                      visible: _visible,
                      child: AppBar(backgroundColor: Colors.black26,title: Text('$_currentPageNumber'),centerTitle: true,),
                    ),
                  ),
                  //_buildLoadingBar(_quranPagesBloc),
                ],
              )),
        ),
      );
    }
  }

  _buildLoadingBar(QuranPagesPicBloc quranPagesBloc) {
    if(quranPagesBloc.fullPagesState == APIStatus.initial){
      return Container();
    }
    if(quranPagesBloc.fullPagesState == APIStatus.loading){
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 100,
          child: SlidingLoadingBar(
            controller: _controller,
            visible: _visible,
            child: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width,100),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Text('جاري تحميل المصحف',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                    LinearProgressIndicator(
                      value: _linearProgressController.value,
                      color: Color(0XFF347D53),minHeight: 10,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    if(quranPagesBloc.fullPagesState == APIStatus.loaded){

      return Container();
    }
    else{
      return Container();
    }


  }
}

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar({
    this.child,
    this.controller,
    this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}

class SlidingLoadingBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingLoadingBar({
    this.child,
    this.controller,
    this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, 1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}

