import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:share_plus/share_plus.dart';

enum ActionMode { capture, select }

class ResourcesListScreen extends StatefulWidget {
  final ResourceRepo resourceRepo;
  final selectedResources = <int, ValueNotifier<ResourceDomain?>>{};
  final actionMode = ValueNotifier(ActionMode.capture);

  Future<(List<ResourceDomain>, int)> loadResources(
      int pageKey, String searchTerm) async {
    final (resources, nextID) =
        await resourceRepo.loadResources(pageKey, searchTerm);

    // TEMP_FIX for infinite scroll doesn't render separator
    // before the first element
    return (
      pageKey == 0 ? [emptyResource, ...resources] : resources,
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
    final resources = selectedResources.values
        .map((e) => e.value)
        .whereType<ResourceDomain>()
        .toList();

    return resourceRepo.exportResources(resources);
  }

  Future<int> deleteResources() async {
    final ids = selectedResources.values
        .map((e) => e.value?.id)
        .whereType<int>()
        .toList();

    return resourceRepo.deleteResources(ids);
  }

  ResourcesListScreen(this.resourceRepo, {super.key});

  @override
  State<StatefulWidget> createState() => ResourcesListScreenState();
}

class ResourcesListScreenState extends State<ResourcesListScreen> {
  final TextEditingController searchTermCtrl = TextEditingController(text: "");
  final PagingController<int, ResourceDomain> pagingCtrl =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingCtrl.addPageRequestListener((pageKey) async {
      final (resources, nextID) =
          await widget.loadResources(pageKey, searchTermCtrl.text);
      if (nextID == -1) {
        pagingCtrl.appendLastPage(resources);
        return;
      }

      pagingCtrl.appendPage(resources, nextID);
    });
  }

  @override
  void dispose() {
    pagingCtrl.dispose();
    searchTermCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(4),
              child: TextField(
                controller: searchTermCtrl,
                keyboardType: TextInputType.text,
                onSubmitted: (event) => pagingCtrl.refresh(),
                decoration: InputDecoration(
                  label: const Text("Search"),
                  border: const OutlineInputBorder(),
                  hintText: "Enter a resource name",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchTermCtrl.clear();
                      pagingCtrl.refresh();
                    },
                  ),
                ),
              ),
            ),
          ),
          PagedSliverList<int, ResourceDomain>.separated(
            pagingController: pagingCtrl,
            builderDelegate: PagedChildBuilderDelegate<ResourceDomain>(
              itemBuilder: (context, item, index) => item.id == 0
                  ? const SizedBox.shrink()
                  : ValueListenableBuilder(
                      valueListenable:
                          widget.getSelectedResourceNotifier(item.id),
                      builder: (context, res, child) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.actionMode.value != ActionMode.select) {
                              return;
                            }

                            if (res == null) {
                              return widget.selectResource(item);
                            }

                            widget.deselectResource(item.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: res != null
                                  ? Border.all(color: Colors.white38)
                                  : null,
                              color: Colors.white10,
                            ),
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 80,
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: MemoryImage(item.image),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(item.createdAt.toString())
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            separatorBuilder: (context, index) {
              // TEMP_FIX for rendering separator before data is available
              if (index + 1 >= pagingCtrl.itemList!.length) {
                return const SizedBox.shrink();
              }

              final currResource = pagingCtrl.itemList![index + 1];
              final prevResource = pagingCtrl.itemList![index];
              if (DateUtils.isSameDay(
                  currResource.createdAt, prevResource.createdAt)) {
                return const SizedBox.shrink();
              }

              return ResourceListSeparator(currResource.createdAt);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: ValueListenableBuilder(
            valueListenable: widget.getActionModeNotifier(),
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...switch (value) {
                  ActionMode.capture => [
                      FilledButton(
                        onPressed: () => {
                          Navigator.of(context)
                              .pushNamed("/resources/create/capture")
                        },
                        child: const Text("Scan"),
                      ),
                      OutlinedButton(
                          onPressed: () =>
                              widget.changeActionMode(ActionMode.select),
                          child: const Text("Select")),
                    ],
                  ActionMode.select => [
                      FilledButton(
                          onPressed: () async {
                            final status = await widget.exportResources();
                            if (status == ShareResultStatus.dismissed) {
                              return;
                            }

                            if (status == ShareResultStatus.unavailable) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Share unavailable :("),
                                ),
                              );
                              return;
                            }

                            widget.changeActionMode(ActionMode.capture);
                          },
                          child: const Text("Export")),
                      FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          onPressed: () async {
                            final count = await widget.deleteResources();
                            if (count == 0) return;

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$count resources deleted"),
                              ),
                            );

                            widget.changeActionMode(ActionMode.capture);
                            pagingCtrl.refresh();
                          },
                          child: const Text("Delete")),
                      OutlinedButton(
                          onPressed: () =>
                              widget.changeActionMode(ActionMode.capture),
                          child: const Text("Cancel")),
                    ]
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResourceListSeparator extends StatelessWidget {
  final DateTime createdAt;

  const ResourceListSeparator(this.createdAt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
        color: Colors.white24,
        child: Text(DateFormat(DateFormat.YEAR_MONTH_DAY).format(createdAt)));
  }
}
