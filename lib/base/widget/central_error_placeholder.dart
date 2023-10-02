import 'package:flutter/material.dart';

class CentralErrorPlaceholder extends StatelessWidget {
  final String message;

  const CentralErrorPlaceholder({
    Key? key,
    this.message = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ),
    );
  }
}
