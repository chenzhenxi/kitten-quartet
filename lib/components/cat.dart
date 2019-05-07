import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:myapp/game.dart';
import './sequence.dart';

final double _size = 128.0;

class Cat extends Sequence {
  final List<List<int>> _dirs = [
    [0, 1],
    [0, -1],
    [1, 1],
    [1, -1],
    [1, 0],
    [-1, 0]
  ];
  final int _speed = 50;
  List<int> _dir;
  var moving = false;
  var _audio = new AudioPlayer();
  String _audioUrl;
  Cat(
    Game game,
    double x,
    double y,
    int body,
    int head,
    int face,
    int hat,
    this._audioUrl,
  ) : super(
            game,
            _size,
            _size,
            x,
            y,
            ['body_$body', 'head_$head', 'face_$face', 'hat_$hat']
                .map((p) => sequenced('cats/$p.png', _size, _size))
                .toList()) {
    width = height = _size;
    _rndDir();
  }
  _rndDir() {
    _dir = _dirs[game.rnd.nextInt(_dirs.length)];
  }

  stop() {
    _audio.stop();
  }

  play() {
    _audio.play(_audioUrl);
    _audio.setReleaseMode(ReleaseMode.LOOP);
  }

  update(t) {
    super.update(t);
    if (!moving || stoped) {
      return;
    }
    double dx, dy;
    var rect = toRect();
    if (t > 2) {
      t = t % 2;
    }
    while (true) {
      dx = _dir[0] * _speed * t;
      dy = _dir[1] * _speed * t;
      if (game.size.contains(Offset(rect.left + dx, rect.top + dy)) &&
          game.size.contains(Offset(rect.right + dx, rect.bottom + dy)) &&
          game.rnd.nextInt(2000) < 1999) {
        break;
      }
      _rndDir();
    }
    x += dx;
    y += dy;
  }

  onTapDown() {
    stoped = !stoped;
    if (stoped) {
      stop();
    } else {
      play();
    }
  }
}
