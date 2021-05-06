// import 'package:base_app/tasbeeh/database/sebha_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class BuildSingleDhikr extends StatefulWidget {
//   final int index;
//   final Key key;
//   final List<Tasbeeh> listItems;
//   final Function refresh;

//   BuildSingleDhikr(this.listItems, this.index, this.key, this.refresh);

//   @override
//   BuildSingleDhikrState createState() => BuildSingleDhikrState();
// }

// class BuildSingleDhikrState extends State<BuildSingleDhikr> {
//   List<Zikr> list;

//   @override
//   void initState() {
//     list = widget.listItems;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return list.length <= 1
//         ? buildCard(context)
//         : Dismissible(
//             key: UniqueKey(),
//             background: Container(
//               color: Colors.purple,
//             ),
//             direction: DismissDirection.horizontal,
//             onDismissed: (_) async {
//               await Provider.of<AzkarDatabase>(context, listen: false)
//                   .removeZikr(list[widget.index].id);
//               await widget.refresh();
//             },
//             child: buildCard(context),
//           );
//   }

//   Widget buildCard(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(4),
//       color: Colors.white,
//       child: InkWell(
//         onTap: () {
//           Navigator.pop(context, widget.index);
//         },
//         splashColor: Theme.of(context).primaryColor,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Flexible(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                         vertical: ScreenUtil().setHeight(10),
//                         horizontal: ScreenUtil().setWidth(20)),
//                     child: Text(
//                       "${list[widget.index].name}",
//                       style: GoogleFonts.almarai(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: ScreenUtil().setSp(20)),
//                       textAlign: TextAlign.start,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               onPressed: () async {
//                 await Get.dialog(NewZikrView(
//                   list: list,
//                   editedZikr: list[widget.index],
//                 ));
//                 await widget.refresh();
//               },
//               icon: Icon(
//                 Icons.edit,
//                 color: Colors.grey,
//                 size: 24.0,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//               child: Icon(
//                 Icons.reorder,
//                 color: Colors.grey,
//                 size: 24.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
