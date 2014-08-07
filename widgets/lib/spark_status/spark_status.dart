// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark_widgets.status;

import 'dart:async';

import 'package:polymer/polymer.dart';

import '../common/spark_widget.dart';

/**
 * This status widget can:
 *
 * * show a default message ([defaultMessage])
 * * show a progress... message ([progressMessage]), and optional spinner
 * * show a temporary message ([temporaryMessage)
 *
 * The progress message is generally used with the spinner control. The
 * temporary message automatically clears itself after a brief period. The
 * control shows, preferentially in this order, the:
 *
 * * temporary message, if any
 * * or progress message, if any
 * * or default message, if any
 */
@CustomTag('spark-status')
class SparkStatus extends SparkWidget {
  @attribute bool spinning = false;
  @attribute String defaultMessage;
  @attribute String progressMessage;
  @attribute String temporaryMessage;

  @observable String message;

  Timer _timer;

  SparkStatus.created() : super.created();

  @override
  void attached() {
    super.attached();
    _update();
  }

  void defaultMessageChanged() => _update();

  void progressMessageChanged() => _update();

  void temporaryMessageChanged() {
    if (_timer != null) {
      _timer.cancel();
    }
    if (temporaryMessage != null) {
      _timer = new Timer(new Duration(seconds: 3), () {
        temporaryMessage = null;
      });
    }
    _update();
  }

  void _update() {
    message = _calculateMessage();
    classes.toggle('hidden', message.isEmpty);
    classes.toggle('spinning', spinning && (temporaryMessage == null));
  }

  String _calculateMessage() {
    if (temporaryMessage != null) return temporaryMessage;
    if (progressMessage != null) return progressMessage;
    if (defaultMessage != null) return defaultMessage;
    return '';
  }
}
