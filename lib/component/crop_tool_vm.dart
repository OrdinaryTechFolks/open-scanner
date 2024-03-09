
import 'package:bgm_frontend/repo/crop_tool.dart';

class CropToolVM {
  late int index;
  late CropToolRepo cropToolRepo;

  CropToolVM(this.index, this.cropToolRepo);

  int getCornersLength() {
    return cropToolRepo.getCropToolCornersLength(index);
  }
}
