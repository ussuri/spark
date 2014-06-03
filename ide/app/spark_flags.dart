// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark.flags;

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:logging/logging.dart' as logging;

/**
 * Stores global developer flags.
 */
class SparkFlags {
  static final _flags = new Map<String, dynamic>();

  /**
   * Accessors to the currently supported flags.
   */
  // NOTE: '...== true' below are on purpose: missing flags default to false.
  static bool get developerMode => _getFlag('test-mode');
  static bool get useLightAceThemes => _getFlag('light-ace-themes');
  static bool get useDarkAceThemes => _getFlag('dark-ace-themes');
  static bool get useAceThemes => useLightAceThemes || useDarkAceThemes;
  static bool get showWipProjectTemplates => _getFlag('wip-project-templates');
  static bool get showGitPull => _getFlag('show-git-pull');
  static bool get showGitBranch => _getFlag('show-git-branch');
  static bool get performJavaScriptAnalysis => _getFlag('analyze-javascript');
  // Bower:
  static bool get bowerMapComplexVerToLatestStable =>
      _getFlag('bower-map-complex-ver-to-latest-stable');
  static Map<String, String> get bowerOverriddenDeps =>
      _getFlag('bower-override-dependencies');
  static List<String> get bowerIgnoredDeps =>
      _getFlag('bower-ignore-dependencies');
  // Logging level is special.
  static logging.Level get loggingLevel {
    final name = _getFlag('logging-level', 'INFO');
    if (name is! String) {
      throw '"level-name" developer flag should have a string value';
    }
    return logging.Level.LEVELS.firstWhere((v) => v.name == name);
  }

  /**
   * Add new flags to the set, possibly overwriting the existing values.
   * Maps are treated specially, updating the top-level map entries rather
   * than overwriting the whole map.
   */
  static void setFlags(Map<String, dynamic> newFlags) {
    // TODO(ussuri): Also recursively update maps on 2nd level and below.
    if (newFlags == null) return;
    newFlags.forEach((key, newValue) {
      var value;
      var oldValue = _flags[key];
      if (oldValue != null && oldValue is Map && newValue is Map) {
        value = oldValue;
        value.addAll(newValue);
      } else {
        value = newValue;
      }
      _flags[key] = value;
    });
  }

  /**
   * Initialize the flags from a JSON file. If the file does not exit, use the
   * defaults. If some flags have already been set, they will be overwritten.
   */
  static Future initFromFile(Future<String> fileReader) {
    return _readFromFile(fileReader).then((Map<String, dynamic> flags) {
      setFlags(flags);
    });
  }

  /**
   * Initialize the flags from several JSON files. Files should be sorted in the
   * order of precedence, from left to right. Each new file overwrites the
   * prior ones, and the flags
   */
  static Future initFromFiles(List<Future<String>> fileReaders) {
    Iterable<Future<Map<String, dynamic>>> futures =
        fileReaders.map((fr) => _readFromFile(fr));
    return Future.wait(futures).then((List<Map<String, dynamic>> multiFlags) {
      for (final flags in multiFlags) {
        setFlags(flags);
      }
    });
  }

  /**
   * Read flags from a JSON file. If the file does not exit or can't be parsed,
   * return null.
   */
  static Future<Map<String, dynamic>> _readFromFile(Future<String> fileReader) {
    return fileReader.then((String contents) {
      return JSON.decode(contents);
    }).catchError((e) {
      if (e is FormatException) {
        throw 'Config file has invalid format: $e';
      } else {
        return null;
      }
    });
  }

  static dynamic _getFlag(String name, [dynamic defaultValue = false]) {
    final value = _flags[name];
    return value != null ? value : defaultValue;
  }
}
