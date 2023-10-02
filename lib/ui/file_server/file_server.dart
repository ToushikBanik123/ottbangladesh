import 'package:flutter/material.dart';

import '../generic/webpage/webpage.dart';

class FileServerPage extends StatelessWidget {
  final String url;

  FileServerPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return WebPage(url: url);
  }
}
