import 'dart:typed_data';

final class ResourceDomain {
  final int id;
  final String name;
  final DateTime createdAt;
  final Uint8List image;
  
  ResourceDomain(this.id, this.name, this.createdAt, this.image);
}

final emptyResource = ResourceDomain(0, "", DateTime(0), Uint8List(0));