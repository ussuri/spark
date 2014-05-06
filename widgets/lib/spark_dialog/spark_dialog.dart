// Copyright (c) 2013, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark_widgets.dialog;

import 'package:polymer/polymer.dart';

import '../spark_modal/spark_modal.dart';
import '../common/spark_widget.dart';

@CustomTag('spark-dialog')
class SparkDialog extends SparkWidget {
  SparkModal _modal;

  /**
   * The title of the dialog.
   */
  @published String title = '';

  /**
   * Specially formatted specification of buttons and their roles that the
   * dialog should display.
   */
  @published String buttons = '';

  /**
   * The kind of animation that the overlay should perform on open/close.
   */
  @published String animation = '';

  SparkDialog.created() : super.created();

  @override
  void enteredView() {
    super.enteredView();

    _modal = $['modal'];
  }

  void show() {
    if (!_modal.opened) {
      _modal.toggle();
    }
  }

  void hide() {
    if (_modal.opened) {
      _modal.toggle();
    }
  }
}
