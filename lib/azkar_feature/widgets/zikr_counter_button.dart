import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/azkar_feature/models/azkar_model.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ZikrCounterButton extends StatefulWidget {
  final SizingInformation sizeConfig;
  final List<Zikr> azkar;
  final CarouselSliderController controller;
  const ZikrCounterButton(
      {super.key,
      required this.sizeConfig,
      required this.azkar,
      required this.controller});

  @override
  State<ZikrCounterButton> createState() => _ZikrCounterButtonState();
}

class _ZikrCounterButtonState extends State<ZikrCounterButton> {
  AudioPlayer audioPlayer = AudioPlayer();

  var currentZikrIndex = 0;
  bool finishedNavigationAnimation = true;

  @override
  void initState() {
    initializeAudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.sizeConfig.blockSizeHorizontal * 34,
      height: widget.sizeConfig.blockSizeHorizontal * 34,
      child: FittedBox(
          child: FloatingActionButton(
        heroTag: "1 ${widget.azkar[currentZikrIndex].content}",
        onPressed: () {
          incrementCounterOrNavigate();
        },
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(widget.sizeConfig.blockSizeHorizontal * 3),
          decoration: BoxDecoration(
              color: const Color(0XFF347D53), shape: BoxShape.circle),
          child: Text(
            "${widget.azkar[currentZikrIndex].counted}",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: widget.sizeConfig.blockSizeHorizontal * 3),
          ),
        ),
      )),
    );
  }

  void initializeAudioPlayer() async {
    await audioPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<void> incrementCounterOrNavigate() async {
    if (finishedNavigationAnimation) {
      if (widget.azkar[currentZikrIndex].counted >=
          widget.azkar[currentZikrIndex].counter - 1) {
        setState(() {
          finishedNavigationAnimation = false;
        });
        await widget.controller.nextPage();
        if (widget.azkar.length != currentZikrIndex + 1) {
          setState(() {
            currentZikrIndex++;
            finishedNavigationAnimation = true;
          });
        } else {
          await audioPlayer
              .setSource(AssetSource('audio/allah_make_you_from_heaven.wav'));
          await audioPlayer.resume();
          Navigator.pop(context);
        }
      } else {
        setState(() {
          widget.azkar[currentZikrIndex].counted =
              widget.azkar[currentZikrIndex].counted + 1;
        });
      }
    }
  }
}
