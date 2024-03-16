import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/repo/resource.dart';

class ResourceListVM {
  final ResourceRepo resourceRepo;

  ResourceListVM(this.resourceRepo);

  Future<(List<ResourceDomain>, int)> loadResources(int pageKey, String searchTerm) async {
    final (resources, nextID) = await resourceRepo.loadResources(pageKey, searchTerm);

    // TEMP_FIX for infinite scroll doesn't render separator 
    // before the first element
    return (pageKey == 0 ? [ResourceDomain(), ...resources] : resources, nextID);
  }
}
