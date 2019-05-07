import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:myapp/game.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await PermissionHandler().requestPermissions(
      [PermissionGroup.microphone, PermissionGroup.storage]);
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  var game = Game();
  runApp(game.widget);
  flameUtil
      .addGestureRecognizer(TapGestureRecognizer()..onTapDown = game.onTapDown);
}
