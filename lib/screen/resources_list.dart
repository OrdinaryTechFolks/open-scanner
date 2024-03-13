import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/screen/resources_list_vm.dart';

class ResourcesListScreen extends StatefulWidget {
  final ResourceListVM vm;

  const ResourcesListScreen(this.vm, {super.key});

  @override
  State<StatefulWidget> createState() => ResourcesListScreenState();
}

class ResourcesListScreenState extends State<ResourcesListScreen> {
  final PagingController<int, ResourceDomain> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      final resources = await widget.vm.loadResources(pageKey);
      _pagingController.appendLastPage(resources);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: PagedListView<int, ResourceDomain>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<ResourceDomain>(
          itemBuilder: (context, item, index) => item.id == 0
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white10,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
        separatorBuilder: (context, index) {
          final currResource = _pagingController.itemList![index + 1];
          final prevResource = _pagingController.itemList![index];
          if (DateUtils.isSameDay(
              currResource.createdAt, prevResource.createdAt)) {
            return const SizedBox.shrink();
          }
          return ResourceListSeparator(currResource.createdAt);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => {
                          Navigator.of(context)
                              .pushNamed("/resources/create/capture")
                        },
                    icon: const Icon(Icons.add))
              ],
            )),
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
