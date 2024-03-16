enum PlaceholderType { question, dollar }

class QueryBuilder {
  final List<String> _sb = [];
  int _counter = 0;
  final List<Object> _args = [];
  final PlaceholderType placeholderType;

  QueryBuilder(String baseQuery, List<Object>? data,
      {this.placeholderType = PlaceholderType.question}) {
    if (data == null) {
      addString(baseQuery);
      return;
    }

    addQuery(baseQuery, data);
  }

  addQuery(String format, List<Object> data) {
    _add(format, data);
  }

  addString(String str) {
    _sb.add(str);
  }

  _add(String format, List<Object> data) {
    _args.addAll(data);

    if (placeholderType == PlaceholderType.dollar) {
      for (var i = 0; i < data.length; i++) {
        _counter = _counter + 1;
        format = format.replaceFirst("?", "\$$_counter");
      }
    }

    _sb.add(format);
  }

  String getQuery() {
    return _sb.join(" ");
  }

  List<Object> getArgs() {
    return _args;
  }
}
