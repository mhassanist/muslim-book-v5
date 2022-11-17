import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  showMyDialog(context, String text) {
    // flutter defined function

    showDialog(
        context: context, builder: (BuildContext context) {
          return  new CupertinoAlertDialog(
            title: new Text("Massage"),
            content: new Text(text),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("OK"))
            ],
          );
    },
        // return object of type AlertDialog
        );
  }
}

class TopPrograssBar extends StatelessWidget {
  final String progressBarImagePath;
  const TopPrograssBar({super.key, this.progressBarImagePath = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35.0),
      alignment: Alignment.topCenter,
      height: 25,
      child: Image.asset(progressBarImagePath, fit: BoxFit.fill),
    );
  }
}

class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: FlatButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          label: Text("Back")),
    );
  }
}

class TopTitle extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final String title;

  const TopTitle({
    super.key,
    this.topMargin = 8.0,
    this.leftMargin = 8.0,
    this.title = '',
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
        top: topMargin,
        left: leftMargin,
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final Function? sendAction;
  final Icon? buttonIcon;

  const SendButton({
    super.key,
    this.sendAction,
    this.buttonIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        backgroundColor: Colors.black87,
        child: Icon(Icons.arrow_forward),
        onPressed: sendAction?.call,
      ),
    );
  }
}
