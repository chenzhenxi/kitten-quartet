import 'package:flame/anchor.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/component.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/components/cat.dart';
import 'package:myapp/components/base.dart';
import 'package:myapp/components/img.dart';
import 'package:myapp/components/sequence.dart';

enum State {
  menu,
  record,
  recorded,
  sing,
}

class Game extends BaseGame {
  final Random rnd = Random();
  final Uuid uuid = new Uuid();
  final List<Cat> _cats = List<Cat>();
  FlutterSound _flutterSound;
  String _recordPath;
  BaseComponent _title, _addKitten, _start, _record, _recorded, _back;
  State state;
  Game() {
    initialize();
  }
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    var s = size.height * 1.5;
    var sf = '.png';
    add(SpriteComponent.fromSprite(s, s, Sprite('bg$sf')));
    _title = Sequence(this, 300, 300, hw(), size.height * 0.3,
        [sequenced('title$sf', 600, 600)]);
    _title.anchor = Anchor.center;
    var t = 'texts';
    _addKitten =
        Img(this, '$t/add_kitten$sf', 178, 40, hw(), size.height * 0.6, () {
      setState(State.record);
    });
    _start =
        Img(this, '$t/start$sf', 242, 40, hw(), size.height * 0.6 + 85, () {
      setState(State.sing);
    });
    _back = Img(this, '$t/back$sf', 77, 40, 20, 55, () {
      _cats.forEach((c) {
        c.stop();
      });
      setState(State.menu);
    });
    _back.anchor = Anchor.topLeft;
    _record = Img(this, 'dialogs/record$sf', 242, 400, hw(), hh(), () {
      setState(State.menu);
    });
    _recorded = Img(this, 'dialogs/recorded$sf', 242, 400, hw(), hh(), () {
      setState(State.menu);
    });
    add(_title);
    add(_addKitten);
    add(_start);
    add(_back);
    add(_record);
    add(_recorded);
    setState(State.menu);
  }

  void onTapDown(TapDownDetails d) async {
    switch (state) {
      case State.menu:
      case State.sing:
        for (var c in components) {
          if (c is BaseComponent && c.contains(d.globalPosition) && !c.hidden) {
            c.onTapDown();
            return;
          }
        }
        break;
      case State.record:
        setState(State.recorded);
        break;
      case State.recorded:
        setState(State.menu);
        break;
    }
  }

  void setState(State s) async {
    state = s;
    components.forEach((c) {
      if (c is BaseComponent) {
        c.hidden = true;
      }
    });
    switch (s) {
      case State.menu:
        _title.hidden = _addKitten.hidden = _start.hidden = false;
        break;
      case State.record:
        _record.hidden = false;
        _flutterSound = new FlutterSound();
        String localPath = await _localPath;
        _recordPath = await _flutterSound
            .startRecorder('$localPath/audio_${uuid.v1().substring(1, 8)}.m4a');
        break;
      case State.recorded:
        _recorded.hidden = false;
        await _flutterSound.stopRecorder();
        _spawnCat();
        break;
      case State.sing:
        _back.hidden = false;
        _cats.forEach((c) {
          c.play();
          c.moving = true;
          c.hidden = false;
        });
    }
  }

  void _spawnCat() {
    var cat = Cat(this, hw(), hh(), rnd.nextInt(5) + 1, rnd.nextInt(5) + 1,
        rnd.nextInt(5) + 1, rnd.nextInt(7) + 1, _recordPath);
    _cats.add(cat);
    add(cat);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  hw() => size.width / 2;
  hh() => size.height / 2;
}
