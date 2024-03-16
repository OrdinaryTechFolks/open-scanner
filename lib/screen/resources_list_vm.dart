import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/repo/resource.dart';

class ResourceListVM {
  final ResourceRepo resourceRepo;

  ResourceListVM(this.resourceRepo);

  Future<List<ResourceDomain>> loadResources(int pageKey, String searchTerm) async {
    final resources = await resourceRepo.loadResources(searchTerm);

    // workaround for infinite scroll doesn't render separator 
    // before the first element
    return pageKey == 0 ? [ResourceDomain(), ...resources] : resources;
  }
}
