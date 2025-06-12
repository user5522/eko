import 'dart:io';
import 'package:eko/db/database.dart';
import 'package:eko/helpers/request_permission.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareFile(File file) async {
  Share.shareXFiles([XFile(file.path)]);
}

Future<void> exportNotesToTxt(
    ScaffoldMessengerState messenger, List<Note> notes) async {
  final DateTime now = DateTime.now();
  final String date =
      '${now.hour}-${now.minute}_${now.day}-${now.month}-${now.year}';
  final String fileName = 'EKO_export_$date';
  double totalSum = 0;
  for (var note in notes) {
    totalSum += note.value;
  }

  try {
    final isGranted = await requestStoragePermission();
    if (!isGranted) return;

    Directory? directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName.txt');

    String data = "Notes:\n";
    for (var note in notes) {
      data += "${note.note}: ${note.value}\n";
    }
    data += "\nTotal Sum: \$$totalSum";

    await file.writeAsString(data);

    shareFile(file);

    messenger.showSnackBar(
      SnackBar(content: Text('Success!')),
    );
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Error exporting notes: $e')),
    );
  }
}
