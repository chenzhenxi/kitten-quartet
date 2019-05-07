import 'dart:ui';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:myapp/game.dart';

abstract class BaseComponent extends PositionComponent {
  final Game game;
  bool hidden;
  Function action;
  BaseComponent(this.game, this.hidden, this.action, [Anchor anchor]) {
    if (anchor == null) {
      anchor = Anchor.center;
    }
    this.anchor = anchor;
  }
  render(c) {
    if (hidden) {
      return;
    }
    prepareCanvas(c);
    postRender(c);
  }

  postRender(Canvas c);
  contains(Offset s) {
    return toRect().contains(s);
  }

  update(t) {}
  Rect toRect() {
    var dx = -anchor.relativePosition.dx * width;
    var dy = -anchor.relativePosition.dy * height;
    return new Rect.fromLTWH(x + dx, y + dy, width, height);
  }

  Rect toPRect() => new Rect.fromLTWH(0, 0, width, height);
  onTapDown() {
    if (!hidden && action != null) {
      action();
    }
  }
}