import 'package:open_scanner/repo/crop_tool.dart';

class CropToolVM {
  late int index;
  late CropToolRepo cropToolRepo;

  CropToolVM(this.index, this.cropToolRepo);

  int getCornersLength() {
    return cropToolRepo.getCropToolCornersLength(index);
  }

  int getEdgesLength() {
    return cropToolRepo.getEdgesLength(index);
  }
}
