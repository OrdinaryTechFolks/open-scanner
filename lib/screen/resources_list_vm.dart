import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:share_plus/share_plus.dart';

enum ActionMode { capture, select }

class ResourceListVM {
  final ResourceRepo resourceRepo;
  final selectedResources = <int, ValueNotifier<ResourceDomain?>>{};
  final actionMode = ValueNotifier(ActionMode.capture);

  ResourceListVM(this.resourceRepo);

  Future<(List<ResourceDomain>, int)> loadResources(
      int pageKey, String searchTerm) async {
    final (resources, nextID) =
        await resourceRepo.loadResources(pageKey, searchTerm);

    // TEMP_FIX for infinite scroll doesn't render separator
    // before the first element
    return (
      pageKey == 0 ? [ResourceDomain(), ...resources] : resources,
      nextID
    );
  }

  ValueNotifier<ResourceDomain?> getSelectedResourceNotifier(int id) {
    if (!selectedResources.containsKey(id)) {
      selectedResources[id] = ValueNotifier(null);
    }

    return selectedResources[id]!;
  }

  void selectResource(ResourceDomain res) {
    selectedResources[res.id]!.value = res;
  }

  void deselectResource(int id) {
    selectedResources[id]!.value = null;
  }

  void clearSelectedResources() {
    for (var selectedResource in selectedResources.values) {
      selectedResource.value = null;
    }
  }

  ValueNotifier<ActionMode> getActionModeNotifier() {
    return actionMode;
  }

  void changeActionMode(ActionMode mode) {
    if (mode == ActionMode.capture) {
      clearSelectedResources();
    }

    actionMode.value = mode;
  }

  Future<ShareResultStatus> exportResources() async {
    final List<XFile> files = [];
    for (var (selectedResource) in selectedResources.values) {
      final res = selectedResource.value;
      if (res?.image == null) continue;

      final file = XFile.fromData(res!.image!,
          name: res.name, mimeType: 'image/png', lastModified: res.createdAt);
      files.add(file);
    }

    if (files.isEmpty) return ShareResultStatus.dismissed;

    final shareRes = await Share.shareXFiles(files);
    return shareRes.status;
  }
  
  Future<int> deleteResources() async {
    var rowsDeleted = 0;
    for (var selectedResource in selectedResources.values) {
      final res = selectedResource.value;
      if (res == null) continue;

      await resourceRepo.deleteResource(res.id);
      final file = File(res.imagePath);
      // TODO: [P3] add trycatch wrapper
      file.deleteSync();

      rowsDeleted++;
    }

    return rowsDeleted;
  }
}
