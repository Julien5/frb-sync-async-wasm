import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:my_app/src/rust/api/simple.dart' as bridge;
import 'package:my_app/src/rust/frb_generated.dart';

Future<void> main() async {
  developer.log("START");
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  developer.log("frontend loaded");
  runApp(Application(backend: bridge.Bridge.make()));
}

void realSyncMut(bridge.Bridge backend) {
  debugPrint("START realSyncMut");
  String r = backend.realSyncMut();
  debugPrint("STOP realSyncMut: $r");
}

void realSyncConst(bridge.Bridge backend) {
  debugPrint("START realSyncConst");
  String r = backend.realSyncConst();
  debugPrint("STOP realSyncConst: $r");
}

void pseudoSyncMut(bridge.Bridge backend) async {
  debugPrint("START pseudoSyncMut");
  String r = await backend.pseudoSyncMut();
  debugPrint("STOP pseudoSyncMut: $r");
}

void realAsyncConst(bridge.Bridge backend) async {
  debugPrint("START realAsyncConst");
  await backend.realAsyncConst();
  debugPrint("STOP realAsyncConst");
}

class Application extends StatelessWidget {
  final bridge.Bridge backend;
  const Application({super.key, required this.backend});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Text("V3"),
            ElevatedButton(
              onPressed: () => realAsyncConst(backend),
              child: Text("realAsyncConst"),
            ),
            ElevatedButton(
              onPressed: () => realSyncMut(backend),
              child: Text("realSyncMut"),
            ),
            ElevatedButton(
              onPressed: () => realSyncConst(backend),
              child: Text("realSyncConst"),
            ),
            ElevatedButton(
              onPressed: () => pseudoSyncMut(backend),
              child: Text("pseudoSyncMut"),
            ),
          ],
        ),
      ),
    );
  }
}
