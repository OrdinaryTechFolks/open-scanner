import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/screen/resources_list_vm.dart';
import 'package:share_plus/share_plus.dart';

class ResourcesListScreen extends StatefulWidget {
  final ResourceListVM vm;

  const ResourcesListScreen(this.vm, {super.key});

  @override
  State<StatefulWidget> createState() => ResourcesListScreenState();
}

class ResourcesListScreenState extends State<ResourcesListScreen> {
  final TextEditingController searchTermCtrl = TextEditingController(text: "");
  final PagingController<int, ResourceDomain> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) async {
      final (resources, nextID) =
          await widget.vm.loadResources(pageKey, searchTermCtrl.text);
      if (nextID == -1) {
        pagingController.appendLastPage(resources);
        return;
      }

      pagingController.appendPage(resources, nextID);
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
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
                onSubmitted: (event) => pagingController.refresh(),
                decoration: InputDecoration(
                  label: const Text("Search"),
                  border: const OutlineInputBorder(),
                  hintText: "Enter a resource name",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchTermCtrl.clear();
                      pagingController.refresh();
                    },
                  ),
                ),
              ),
            ),
          ),
          PagedSliverList<int, ResourceDomain>.separated(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<ResourceDomain>(
              itemBuilder: (context, item, index) => item.id == 0
                  ? const SizedBox.shrink()
                  : ValueListenableBuilder(
                      valueListenable:
                          widget.vm.getSelectedResourceNotifier(item.id),
                      builder: (context, res, child) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.vm.actionMode.value !=
                                ActionMode.select) {
                              return;
                            }

                            if (res == null) {
                              return widget.vm.selectResource(item);
                            }

                            widget.vm.deselectResource(item.id);
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
                                        image: MemoryImage(item.image!),
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
              if (index + 1 >= pagingController.itemList!.length) {
                return const SizedBox.shrink();
              }

              final currResource = pagingController.itemList![index + 1];
              final prevResource = pagingController.itemList![index];
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
            valueListenable: widget.vm.getActionModeNotifier(),
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
                              widget.vm.changeActionMode(ActionMode.select),
                          child: const Text("Select")),
                    ],
                  ActionMode.select => [
                      FilledButton(
                          onPressed: () async {
                            final status = await widget.vm.exportResources();
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

                            widget.vm.changeActionMode(ActionMode.capture);
                          },
                          child: const Text("Export")),
                      OutlinedButton(
                          onPressed: () =>
                              widget.vm.changeActionMode(ActionMode.capture),
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
