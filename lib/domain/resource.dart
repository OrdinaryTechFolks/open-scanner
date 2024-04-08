import 'dart:typed_data';

final class ResourceDomain {
  int id = 0;
  String name = "";
  DateTime createdAt = DateTime(0);
  Uint8List? image;
  
  ResourceDomain();
}