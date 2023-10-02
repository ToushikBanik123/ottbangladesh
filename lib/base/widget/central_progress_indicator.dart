import 'package:flutter/material.dart';

class CentralProgressIndicator extends StatelessWidget {
  const CentralProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
