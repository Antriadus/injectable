import 'package:code_builder/code_builder.dart';

class CustomAllocator implements Allocator {
  static const _doNotPrefix = ['dart:core'];

  final _imports = <String, String>{};

  @override
  String allocate(Reference reference) {
    final symbol = reference.symbol;
    final url = reference.url;
    if (url == null || _doNotPrefix.contains(url)) {
      return symbol!;
    }
    return '_i${_imports.putIfAbsent(url, () => url.hashCode.toString())}.$symbol';
  }

  @override
  Iterable<Directive> get imports => _imports.keys.map(
        (u) {
          final h = u.hashCode;
          return Directive.import(u, as: '_i$h');
        },
      );
}
