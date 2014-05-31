// Copyright (c) 2013, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark_widgets.toggle_button;

import 'dart:html';

import 'package:polymer/polymer.dart';

import '../common/spark_widget.dart';

// Ported from Polymer Javascript to Dart code.

// TODO(terry): Need to properly support touch.  Today there's an onclick
//               handler in the template to toggle the state - this shouldn't
//               be needed.
@CustomTag("spark-toggle-button")
class SparkToggleButton extends SparkWidget {
  @published String onLabel = 'ON';
  @published String offLabel = 'OFF';
  /// Gets or sets the state, true is ON and false is OFF.
  @published bool checked = false;

  int _x;
  int _w;

  SparkToggleButton.created(): super.created() {
    onClick.listen(toggle);
    // TODO(ussuri): Enable when tap events become supported.
//    onTap.listen(toggle);
//    onTrackStart.listen(trackStart);
//    onTrack.listen(track);
//    onTrackEnd.listen(trackEnd);
//    onFlick.listen(flick);
  }

  void checkedChanged() {
    $['toggle'].classes.toggle('on', checked);
  }

  void toggle(Event e) {
    checked = !checked;
  }

  // TODO(ussuri): Enable when tap events become supported.
//  void trackStart(MouseEvent e) {
//    _w = $['toggle'].offsetWidth - clientWidth;
//    $['toggle'].classes.add('dragging');
//    e.preventTap();
//  }
//
//  void track(MouseEvent e) {
//    _x = max(-_w, min(0, checked ? e.client.x : e.client.y - _w));
//    $['toggle'].style.left = '${_x}px';
//  }
//
//  void trackEnd(MouseEvent e) {
//    $['toggle'].style.left = null;
//    $['toggle'].classes.remove('dragging');
//    checked = _x.abs() < _w / 2;
//  }
//
//  void flick(Event e) {
//    this.checked = e.xVelocity > 0;
//    Platform.flush();
//  }
}
