// import 'package:emaan/utils/locator.dart';
// import 'package:emaan/utils/prefs.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/screenutil.dart';

// class SingleZikrBottomSheet extends StatefulWidget {
//   @override
//   _SingleZikrBottomSheetState createState() => _SingleZikrBottomSheetState();
// }

// class _SingleZikrBottomSheetState extends State<SingleZikrBottomSheet> {
//   bool allowForRepeat = false;
//   TextEditingController controller = TextEditingController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     setState(() {
//       allowForRepeat = locator<Prefs>().allowForAzkarToChange;
//       controller.text = "${locator<Prefs>().azkarCountTimes}";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(ScreenUtil().setWidth(40)),
//                   topRight: Radius.circular(ScreenUtil().setWidth(40)))),
//           child: Column(
//             children: <Widget>[
//               CheckboxListTile(
//                 value: allowForRepeat,
//                 onChanged: (val) {
//                   setState(() {
//                     locator<Prefs>().setAllowForAzkarToChange(val);
//                     allowForRepeat = val;
//                   });
//                 },
//                 title: Text(
//                   "Change automatically to next Zikr in the List",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               ListTile(
//                 title: Text(
//                   "Change to next Zikr after",
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 trailing: Container(
//                   alignment: Alignment.center,
//                   width: ScreenUtil().setWidth(40),
//                   child: TextField(
//                     onSubmitted: (s) {
//                       try {
//                         int count = int.parse("$s");
//                         if (count > 1) {
//                           locator<Prefs>().setAzkarCountTimes(count);
//                         } else {
//                           controller.text = "1";
//                           locator<Prefs>().setAzkarCountTimes(1);
//                         }
//                       } catch (e) {
//                         controller.text = "1";
//                         locator<Prefs>().setAzkarCountTimes(1);
//                       }
//                     },
//                     textInputAction: TextInputAction.done,
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     enabled: allowForRepeat,
//                     controller: controller,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
