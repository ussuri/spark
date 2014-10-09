// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark.package_mgmt.common;

import '../enum.dart';

class FetchMode extends Enum<String> {
  const FetchMode._(String val) : super(val);

  String get enumName => 'FetchMode';

  static const INSTALL = const FetchMode._('INSTALL');
  static const UPGRADE = const FetchMode._('UPGRADE');
}
