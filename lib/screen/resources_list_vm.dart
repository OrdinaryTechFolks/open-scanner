import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/repo/resource.dart';

class ResourceListVM {
  final ResourceRepo resourceRepo;

  ResourceListVM(this.resourceRepo);

  Future<List<ResourceDomain>> loadResources() async {
    return await resourceRepo.loadResources();
  }
}
