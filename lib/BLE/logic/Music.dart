// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:record/record.dart';

// class LedSimulator extends StatefulWidget {
//   const LedSimulator({super.key});

//   @override
//   _LedSimulatorState createState() => _LedSimulatorState();
// }

// class _LedSimulatorState extends State<LedSimulator> {
//   final Record _record = Record();
//   double _loudness = 0;

//   @override
//   void initState() {
//     super.initState();
//     startRecording();
//   }

//   Future<void> startRecording() async {
//     if (await _record.hasPermission()) {
//       await _record.start();
//       _record
//           .onAmplitudeChanged(const Duration(milliseconds: 100))
//           .listen((amp) {
//         setState(() {
//           _loudness = (((amp.current + 60) / 60) * 100) - 30;
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _record.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mic Loudness Project'),
//       ),
//       body: Center(
//         child: Text(
//           'Loudness: ${_loudness.toStringAsFixed(2)}',
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
