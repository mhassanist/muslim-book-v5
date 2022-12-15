import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/loading_utils.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginPopUpView extends StatefulWidget {
  final bool close;

  const LoginPopUpView({Key key, this.close}) : super(key: key);

  @override
  _LoginPopUpViewState createState() => _LoginPopUpViewState();
}

class _LoginPopUpViewState extends State<LoginPopUpView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (context != null) {
      //   Provider.of<UserProvider>(context, listen: false).errorMessage = "";
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (c, SizingInformation sizeConfig) => Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0XFF347D53),
        child:
            ListView(padding: EdgeInsets.only(bottom: 20), children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: sizeConfig.blockSizeVertical * 5),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: sizeConfig.blockSizeVertical * 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.white.withOpacity(.4), BlendMode.srcIn),
                        image: AssetImage(
                          "assets/images/splash_view/decoration.png",
                        ),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/splash_view/logo.png",
                        width: sizeConfig.blockSizeHorizontal * 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: sizeConfig.blockSizeVertical,
          ),
          buildLoginButton(
              sizeConfig,
              AppLocalizations.of(context)!.translate("facebook_login"),
              FontAwesomeIcons.facebookSquare,
              const Color(0XFF3b5998), onPressed: () async {
            LoadingUtils util = LoadingUtils();
            util.setIsLoading(context, true);
            try {
              await Provider.of<UserProvider>(context, listen: false)
                  .openFaceBookDialogPicker()
                  .then((value) {
                setState(() {});
                if (this.widget.close) {
                  Navigator.of(context).pop();
                }
              });
            } catch (e) {
              print(e);
            }
            util.setIsLoading(context, false);
          }),
          SizedBox(
            height: sizeConfig.blockSizeVertical,
          ),
          buildLoginButton(
              sizeConfig,
              AppLocalizations.of(context)!.translate("google_login"),
              FontAwesomeIcons.googlePlusSquare,
              const Color(0XFFDB4437), onPressed: () async {
            LoadingUtils util = LoadingUtils();
            util.setIsLoading(context, true);
            await Provider.of<UserProvider>(context, listen: false)
                .openGooglePickerDialog()
                .then((value) {
              setState(() {});
              if(this.widget.close != null){
                if (this.widget.close) {
                  Navigator.of(context).pop();
                }
              }
            });
            util.setIsLoading(context, false);
          }),
          SizedBox(
            height: sizeConfig.blockSizeVertical,
          ),
          buildLoginButton(
              sizeConfig,
              AppLocalizations.of(context)!.translate("login"),
              Icons.arrow_forward_ios,
              Constants.PRIMARY_DARK_COLOR, onPressed: () async {
            await Navigator.pushNamed(context, "/login");
            Provider.of<UserProvider>(context, listen: false).errorMessage = "";
          }),
          SizedBox(
            height: sizeConfig.blockSizeVertical,
          ),
          buildLoginButton(
              sizeConfig,
              AppLocalizations.of(context)!.translate("create_account"),
              Icons.arrow_forward_ios,
              Constants.PRIMARY_DARK_COLOR, onPressed: () async {
            await Navigator.pushNamed(context, "/signup_view");
            Provider.of<UserProvider>(context, listen: false).errorMessage = "";
          }),
          SizedBox(
            height: 10,
          ),
          errorText(sizeConfig, context)
        ]),
      ),
    );
  }

  AnimatedCrossFade errorText(SizingInformation sizeConfig, context) {
    return AnimatedCrossFade(
      crossFadeState: Provider.of<UserProvider>(context).errorMessage == ""
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: SizedBox(),
      duration: Duration(milliseconds: 100),
      secondChild: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 3),
        child: Text(
          Provider.of<UserProvider>(context).errorMessage,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildLoginButton(
      SizingInformation sizeConfig, String text, IconData icon, Color iconColor,
      {Function onPressed}) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 10),
      child: RawMaterialButton(
        padding: EdgeInsets.symmetric(
          vertical: sizeConfig.blockSizeVertical * 2,
        ),
        onPressed: onPressed,
        fillColor: Colors.white,
        shape: StadiumBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: sizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              icon,
              color: iconColor,
            )
          ],
        ),
      ),
    );
  }
}
