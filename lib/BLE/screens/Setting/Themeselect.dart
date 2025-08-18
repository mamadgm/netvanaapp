// import 'package:flutter/material.dart';
// import 'package:netvana/const/figma.dart';
// import 'package:netvana/const/themes.dart';
// import 'package:netvana/customwidgets/newtab.dart';
// import 'package:netvana/data/ble/providerble.dart';
// import 'package:provider/provider.dart';

// class ThemeSelect extends StatelessWidget {
//   final Function(int) update;
//   const ThemeSelect({super.key, required this.update});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProvData>(
//       builder: (context, value, child) => NewTab(
//         appbartext: "افکت را انتخاب کنید",
//         childrens: List.generate(
//           12,
//           (index) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: EffectTab(
//                 index: index,
//                 update: (p0) {
//                   update(p0);
//                   FocusScope.of(context).unfocus();
//                   Navigator.of(context).pop();
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class EffectTab extends StatelessWidget {
//   final int index;
//   final Function(int) update;
//   const EffectTab({super.key, required this.index, required this.update});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             height: GetGoodW(context, 320, 160).height,
//             width: GetGoodW(context, 320, 160).width,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               image: DecorationImage(
//                 image: AssetImage(Allthemes[index].path),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//               height: GetGoodW(context, 320, 160).height,
//               width: GetGoodW(context, 320, 160).width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.black.withOpacity(0.6),
//               )),
//           Center(
//             child: Column(
//               children: [
//                 Text(
//                   Allthemes[index].name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 28, // Adjust the font size
//                     fontWeight: FontWeight.bold,
//                     fontFamily: FIGMA.estbo,
//                   ),
//                 ),
//                 Text(
//                   Allthemes[index].property,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14, // Adjust the font size
//                     fontWeight: FontWeight.bold,
//                     fontFamily: FIGMA.estbo,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       onTap: () {
//         update(index);
//       },
//     );
//   }
// }
