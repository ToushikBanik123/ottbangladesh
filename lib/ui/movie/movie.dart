import 'package:flutter/material.dart';

import '../generic/webpage/webpage.dart';

class MoviePage extends StatelessWidget {
  final String url;

  MoviePage({required this.url});

  @override
  Widget build(BuildContext context) {
    return WebPage(url: url);
  }
}
