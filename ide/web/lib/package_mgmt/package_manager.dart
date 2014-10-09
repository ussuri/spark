// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library spark.package_mgmt;

import 'dart:async';

import 'package_common.dart';
import '../builder.dart';
import '../decorators.dart';
import '../jobs.dart';
import '../workspace.dart';

// TODO(ussuri): Add comments.

abstract class PackageServiceProperties {
  final StreamController<Project> _controller = new StreamController.broadcast();

  bool isPackageResource(Resource resource) {
    return isPackageSpecFile(resource) ||
           isFolderWithPackages(resource) ||
           isPackagesFolder(resource) ||
           isInPackagesFolder(resource);
  }

  bool isPackageSpecFile(Resource resource) =>
      resource is File && resource.name == packageSpecFileName;

  bool isFolderWithPackages(Resource resource) =>
      resource is Folder && resource.getChild(packageSpecFileName) != null;

  bool isPackagesFolder(Resource resource) {
    return resource is Folder &&
           resource.name == packagesDirName &&
           resource.getSibling(packageSpecFileName) != null;
  }

  bool isInPackagesFolder(Resource resource) {
    while (resource.parent != null) {
      if (isPackagesFolder(resource.parent)) {
        return true;
      }
      resource = resource.parent;
    }
    return false;
  }

  bool isPackageRef(String url) =>
      packageRefPrefixRegexp.matchAsPrefix(url) != null;

  bool isSecondaryPackage(Resource resource) {
    return resource.path.contains('/$packagesDirName/') &&
           !isInPackagesFolder(resource);
  }

  File findSpecFile(Folder container) {
    while (container.parent != null && container is! Workspace) {
      Resource child = container.getChild(packageSpecFileName);
      if (child != null) {
        return child;
      }
      container = container.parent;
    }
    return null;
  }

  void setSelfReference(Project project, String selfReference) {
    project.setMetadata('${packageServiceName}SelfReference', selfReference);
    _controller.add(project);
  }

  String getSelfReference(Project project) =>
    project.getMetadata('${packageServiceName}SelfReference');

  Stream<Project> get onSelfReferenceChange => _controller.stream;

  //
  // Pure virtual interface.
  //

  String get packageServiceName;
  String get packageSpecFileName;
  String get packagesDirName;
  String get libDirName;
  String get packageRefPrefix;
  RegExp get packageRefPrefixRegexp;
}

abstract class PackageManager {
  PackageManager(Workspace workspace) {
    workspace.builderManager.builders.add(getBuilder());
  }

  Future installPackages(Folder folder, ProgressMonitor monitor) =>
      _installOrUpgradePackages(folder, FetchMode.INSTALL, monitor);

  Future upgradePackages(Folder folder, ProgressMonitor monitor) =>
      _installOrUpgradePackages(folder, FetchMode.UPGRADE, monitor);

  void setSelfReference(Project project, String selfReference) =>
      properties.setSelfReference(project, selfReference);

  //
  // Pure virtual interface.
  //

  PackageServiceProperties get properties;

  PackageBuilder getBuilder();

  PackageResolver getResolverFor(Project project);

  /**
   * Return `true` or `null` if all packages are installed. Otherwise, return a
   * `String` with the name of an uninstalled package.
   */
  Future<dynamic> arePackagesInstalled(Folder container);

  Future _installOrUpgradePackages(
      Folder container, FetchMode mode, ProgressMonitor monitor);
}

abstract class PackageResolver {
  //
  // Pure virtual interface.
  //

  PackageServiceProperties get properties;

  File resolveRefToFile(String url);
  String getReferenceFor(File file);
}

abstract class PackageBuilder extends Builder {
  //
  // Pure virtual interface.
  //

  PackageServiceProperties get properties;

  Future build(ResourceChangeEvent event, ProgressMonitor monitor);
}

/**
 * A decorator to add text decorations to the `pubspec.yaml` file.
 */
class PackageDecorator extends Decorator {
  final PackageManager _manager;
  final StreamController _controller = new StreamController.broadcast();

  PackageDecorator(this._manager) {
    _manager.properties.onSelfReferenceChange.listen((_) =>
        _controller.add(null));
  }

  bool canDecorate(Object object) {
    if (object is! Resource) return false;

    Resource r = object;
    return r.isFile && r.name == _manager.properties.packageSpecFileName;
  }

  String getTextDecoration(Resource resource) {
    Project project = resource.project;
    if (project == null) return null;
    String name = _manager.properties.getSelfReference(project);
    return name == null ? null : ' - ${name}';
  }

  Stream get onChanged => _controller.stream;
}
