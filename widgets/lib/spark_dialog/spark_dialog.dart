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

  String id = '';
  String text = '';

  bool primary = false;
  bool large = false;
  bool small = false;
  bool noPadding = false;
  bool overlayToggle = false;
  String dataDismiss = '';
  bool focused = false;

  ButtonProps.fromSpec(String spec) {
    final Match m = _SPEC_REGEXP.matchAsPrefix(spec.trim());
    id = m[1];
    text = m[2];
    if (text == null) {
      text = _STANDARD_BUTTONS[id];
    }
    if (id == 'ok' || id == 'cancel') {
      overlayToggle = true;
      if (id == 'ok') {
        primary = true;
      }
    }
    // Note that explicit attributes take precedence over the id-based defaults.
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
          case 'closeDialog': overlayToggle = true; break;
          default: throw new StateError("Unknown button spec attribute '$attr'");
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
   * Specification of the buttons that the dialog should display and their
   * actions and properties.
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
