// Copyright (c) 2013, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark_widgets.dialog;

import 'package:polymer/polymer.dart';

import '../spark_modal/spark_modal.dart';
import '../common/spark_widget.dart';

@reflectable
class ButtonProps {
  // Matches:
  // "ok:Submit[primary small]"
  // "ok:Submit"
  // "ok"
  static final _SPEC_REGEXP =
      new RegExp(r'([\w-]+)(?::([^\[\]]+)(?:\[(.+)\])?)?');

  static const _STANDARD_BUTTONS = const {
      'ok': 'OK',
      'cancel': 'Cancel',
      'help': 'Help',
      'reset': 'Reset'
  };

  String text = '';
  String firedEvent;

  bool primary = false;
  bool large = false;
  bool small = false;
  bool noPadding = false;
  bool overlayToggle = false;
  String dataDismiss = '';
  bool focused;

  ButtonProps.fromSpec(String spec) {
    final Match m = _SPEC_REGEXP.matchAsPrefix(spec.trim());
    firedEvent = m[1];
    text = m[2];
    if (text == null) {
      text = _STANDARD_BUTTONS[firedEvent];
    }
    if (firedEvent == 'ok' || firedEvent == 'cancel') {
      overlayToggle = true;
      if (firedEvent == 'ok') {
        primary = true;
      }
    }
    // Note that explicit attributes take precedence over the defaults above.
    if (m[3] != null) {
      final List<String> attrs = m[3].split(' ');
      for (final attr in attrs) {
        switch (attr) {
          case 'primary': primary = true; break;
          case 'secondary': primary = false; break;
          case 'large': large = true; break;
          case 'small': small = true; break;
          case 'noPadding': noPadding = true; break;
          case 'focused': focused = true; break;
          case 'overlay-toggle': overlayToggle = true; break;
          default: assert(false);
        }
      }
    }
    if (overlayToggle) {
      dataDismiss = 'modal';
    }
  }
}

@CustomTag('spark-dialog')
class SparkDialog extends SparkWidget {
  /**
   * The title of the dialog.
   */
  @published String title = '';

  /**
   * Specially formatted specification of buttons and their roles that the
   * dialog should display.
   */
  @published String buttons = 'cancel;ok';

  /**
   * The kind of animation that the overlay should perform on open/close.
   */
  @published String animation = '';

  @observable final buttonProps = new ObservableList<ButtonProps>();

  SparkModal _modal;

  SparkDialog.created() : super.created();

  @override
  void enteredView() {
    super.enteredView();

    _modal = $['modal'];

    List<String> buttonSpecs = buttons.split(';');
    buttonProps.addAll(
        buttonSpecs.map((spec) => new ButtonProps.fromSpec(spec)));
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
