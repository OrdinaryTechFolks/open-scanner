
class Config {
  final paginationLimit = 5;
  final resources = Resource();
}

class Resource {
  final backend = API("http://localhost:8080", 10); 
}

class API {
  final String address;
  final int timeout;

  API(this.address, this.timeout);
}