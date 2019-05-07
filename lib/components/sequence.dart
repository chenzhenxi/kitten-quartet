import 'package:flame/animation.dart';
import 'package:myapp/game.dart';
import './base.dart';

var sequenced = (String path, double width, double height) =>
    Animation.sequenced(path, 4,
        textureWidth: width, textureHeight: height, stepTime: 0.17);

class Sequence extends BaseComponent {
  final List<Animation> _animations;
  double width, height, x, y;
  var stoped = false;
  Sequence(Game game, this.width, this.height, this.x, this.y, this._animations)
      : super(game, false, null);
  renderSequences(c) {
    _animations.forEach((a) {
      a.getSprite().renderRect(c, toPRect());
    });
  }

  postRender(c) {
    renderSequences(c);
  }

  update(t) {
    if (stoped) {
      return;
    }
    _animations.forEach((a) {
      a.update(t);
    });
  }

  onTapDown() {
    stoped = !stoped;
  }
}
