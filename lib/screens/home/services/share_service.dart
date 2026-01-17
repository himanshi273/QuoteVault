import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ShareService {
  static Future<void> shareWidget(GlobalKey key) async {
    final controller = ScreenshotController();

    // Capture widget using its key
    final context = key.currentContext;
    if (context == null) return;

    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await controller.captureFromWidget(
      RepaintBoundary(
        key: key,
        child: Material(
          child: context.widget,
        ),
      ),
      pixelRatio: 2.5,
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/quote.png');
    await file.writeAsBytes(image);

    await Share.shareXFiles([XFile(file.path)], text: 'Check out this quote!');
  }
}
