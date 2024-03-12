import 'dart:typed_data';

class ResourceDomain {
  int id = 0;
  String name = "";
  String imagePath = "";
  DateTime createdAt = DateTime(0);
  Uint8List? image;
  
  ResourceDomain();
}