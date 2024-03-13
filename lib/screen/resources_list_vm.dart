import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/repo/resource.dart';

class ResourceListVM {
  final ResourceRepo resourceRepo;

  ResourceListVM(this.resourceRepo);

  Future<List<ResourceDomain>> loadResources(int pageKey) async {
    // workaround for infinite scroll doesn't render separator 
    // before the first element
    if (pageKey == 0) {
      return [ResourceDomain(), ...await resourceRepo.loadResources()];
    }
    return await resourceRepo.loadResources();
  }
}
