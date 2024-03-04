
import 'package:bgm_frontend/repo/resources.dart';

class CropToolVM {
  late int index;
  late ResourcesRepo repo;

  CropToolVM(this.index, this.repo);

  int getCornersLength() {
    return repo.cropTools[index].cornerPositions.length;
  }
}
