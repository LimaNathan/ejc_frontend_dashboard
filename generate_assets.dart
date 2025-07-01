// // ignore_for_file: depend_on_referenced_packages

// import 'dart:io';

// import 'package:path/path.dart' as path;

// void main(List<String> args) {
//   final dir = Directory('assets');
//   final files = dir.listSync(recursive: true);
//   final buffer = StringBuffer();
//   for (final file in files) {
//     if (file is File) {
//       final relativePath = path
//           .relative(file.path, from: 'lib')
//           .replaceAll('../', '')
//           .replaceAll(r'\', '/');



//       final constantName = _generateConstantName(relativePath.toLowerCase());
//       buffer.writeln("static const String $constantName = '$relativePath';");
//     }
//   }

//   final output = '''
//     class AppImages {
//         $buffer
//       }''';
//   File('lib/app/utils/images/app_images.dart').writeAsStringSync(output);
//   Process.run('dart', ['fix', '--apply']);
// }

// String _generateConstantName(String filePath) {
//   final camelCaseWords = filePath
//       .replaceAll(RegExp('[^a-zA-Z0-9]'), '_')
//       .replaceAll('.dart', '')
//       .replaceAll('svg', 'SVG')
//       .replaceAll('png', 'PNG')
//       .replaceAll('assets_', '')
//       .split('_')
//       .where((word) => word.isNotEmpty)
//       .map((word) => word[0].toUpperCase() + word.substring(1))
//       .join();
//   if (camelCaseWords.isEmpty) return 'unnamedAsset';
//   return camelCaseWords[0].toLowerCase() + camelCaseWords.substring(1);
// }
