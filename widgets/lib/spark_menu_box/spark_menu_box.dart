// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark_widgets.spark_menu_box;


import 'package:polymer/polymer.dart';

import '../common/spark_widget.dart';
import '../spark_menu/spark_menu.dart';
import '../spark_overlay/spark_overlay.dart';

@CustomTag('spark-menu-box')
class SparkMenuBox extends SparkWidget {
  @published dynamic selected;
  @published String valueAttr;
  @published bool opened = false;
  @published String arrow;
  static final List<String> _SUPPORTED_ARROWS = [
    'none', 'top-center', 'top-left', 'top-right'
  ];

  SparkOverlay _overlay;
  SparkMenu _menu;

  SparkMenuBox.created() : super.created();

  @override
  void enteredView() {
    super.enteredView();

    assert(_SUPPORTED_ARROWS.contains(arrow));

    _overlay = $['overlay'];
    _menu = $['menu'];
  }

  void resetState() => _menu.resetState();

  bool maybeHandleKeyStroke(int keyCode) {
    return _menu.maybeHandleKeyStroke(keyCode);
  }
}
