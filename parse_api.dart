import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File(
    '/Users/abdelrahmanredaebrahim/StudioProjects/z_sports_booking/assets/images/New Collection.postman_collection.json',
  );
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);

  void parseItems(List<dynamic> items, String path) {
    for (var item in items) {
      if (item['name'] != null &&
          item['name'].toString().toLowerCase().contains('admin')) {
        continue; // Skip admin
      }

      if (item['item'] != null) {
        parseItems(item['item'], '$path/${item['name']}');
      } else if (item['request'] != null) {
        final req = item['request'];
        final method = req['method'];
        String url = '';
        if (req['url'] is String) {
          url = req['url'];
        } else if (req['url'] is Map && req['url']['raw'] != null) {
          url = req['url']['raw'];
        }
        stdout.writeln('[$method] $path/${item['name']}');
        stdout.writeln('  URL: $url');
        if (req['body'] != null && req['body']['raw'] != null) {
          stdout.writeln('  Body: ${req['body']['raw'].replaceAll('\n', ' ')}');
        }
        stdout.writeln('-----------------------------');
      }
    }
  }

  if (data['item'] != null) {
    parseItems(data['item'], '');
  }
}
