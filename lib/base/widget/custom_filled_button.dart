import 'package:flutter/material.dart';

class CustomFilledButton extends StatefulWidget {
  final String title;

  final Widget? child;
  final Color backgroundColor, textColor;
  final GestureTapCallback onTap;
  final EdgeInsets margin;

  const CustomFilledButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.child,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xFFFBB217),
    this.margin = const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      top: 12.0,
    ),
  }) : super(key: key);

  @override
  _CustomFilledButtonState createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: double.maxFinite,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(12.0),
            ),
          ),
          backgroundColor: widget.backgroundColor,
        ),
        onPressed: widget.onTap,
        child: widget.child ??
            Text(
              widget.title,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 16.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
      ),
    );
  }
}
