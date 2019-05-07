import 'package:flame/anchor.dart';
import 'package:myapp/game.dart';
import 'package:flame/sprite.dart';
import './base.dart';

class Img extends BaseComponent {
  double width, height, x, y;
  Sprite sp;
  Img(Game game, String path, this.width, this.height, this.x, this.y,
      [Function action, Anchor anchor = Anchor.center])
      : super(game, false, action, anchor) {
    sp = Sprite(path);
  }
  postRender(c) {
    if (sp == null) {
      return;
    }
    sp.renderRect(c, toPRect());
  }
}
