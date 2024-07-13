
class Config {
  final paginationLimit = 5;
  final resources = Resource();
}

class Resource {
  final backend = API("https://scanme-backend-http-feat-5-dev", 10); 
}

class API {
  final String address;
  final int timeout;

  API(this.address, this.timeout);
}