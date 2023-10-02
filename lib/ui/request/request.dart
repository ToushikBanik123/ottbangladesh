import 'package:flutter/material.dart';

import '../generic/webpage/webpage.dart';

class RequestPage extends StatelessWidget {
  final String url;

  RequestPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return WebPage(url: url);
  }
}
