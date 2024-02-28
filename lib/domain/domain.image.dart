

import 'dart:typed_data';
import 'dart:ui' as ui;

// Store uncompress images
class ImageDomain {
  ui.Size size;
  int channels;
  Uint8List data;

  ImageDomain(this.size, this.channels,  this.data);
}