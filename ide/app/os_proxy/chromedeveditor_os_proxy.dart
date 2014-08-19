#!/Applications/dart/dart-sdk/bin/dart

import 'dart:io';
import 'dart:convert';

void main() {
  stdin
      .transform(UTF8.decoder)
      .transform(new LineSplitter())
      .listen(processCmd);
}

void processCmd(String cmd) {
  final RegExp CMD_RE = new RegExp(r'(\S+)(\s+(\S*))?');
  final Match match = CMD_RE.matchAsPrefix(cmd);

  if (match == null) return;

  final String path = match.group(1);
  final List<String> args =
      match.group(3) != null ? match.group(3).split(' ') : [];

  // print("Launching `$path` with args $args...");
  //'/Applications/dart/chromium/Chromium.app/Contents/MacOS/Chromium'
  Process.run(path, args)
      .then((_) => print("success"))
      .catchError((e) => print("error: $e"));
}
