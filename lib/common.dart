import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

Padding buildFilledButton({
  VoidCallback? onPressCallback,
  Color backgroundColor = colorAccent,
  required String title,
  EdgeInsets padding = const EdgeInsets.symmetric(
    horizontal: 32.0,
    vertical: 16.0,
  ),
}) {
  return Padding(
    padding: padding,
    child: SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: shapeButtonRectangle,
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressCallback,
        child: Text(
          title,
          //style: textStyleFilledButton,
        ),
      ),
    ),
  );
}

Padding buildTextFormField({
  required TextEditingController controller,
  String? hint,
  required TextInputType inputType,
  int? maxLength,
  EdgeInsets padding = const EdgeInsets.symmetric(
    horizontal: 32.0,
    vertical: 8.0,
  ),
}) {
  return Padding(
    padding: padding,
    child: Container(
      decoration: boxDecorationBorderForm,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        //style: textStyleInputForm,
        keyboardType: inputType,
        decoration: inputDecorationForm.copyWith(
          hintText: hint,
        ),
        controller: controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
      ),
    ),
  );
}

Container buildSocialLoginItem({required String imagePath}) {
  return Container(
    decoration: boxDecorationBorderForm,
    padding: const EdgeInsets.all(16.0),
    child: Image.asset(
      imagePath,
      fit: BoxFit.fitHeight,
      height: 24.0,
    ),
  );
}

InkWell buildBackButton(VoidCallback? onTapCallback) {
  return InkWell(
    child: Container(
      width: 40.0,
      height: 40.0,
      decoration: boxDecorationBackButtonBorder,
      child: Center(
        child: Icon(
          Icons.arrow_back,
          color: colorTextRegular,
          size: 20.0,
        ),
      ),
    ),
    onTap: onTapCallback,
  );
}

InkWell buildCloseButton(VoidCallback? onTapCallback) {
  return InkWell(
    child: Container(
      width: 40.0,
      height: 40.0,
      decoration: boxDecorationBackButtonBorder,
      child: Center(
        child: Icon(
          Icons.close,
          color: colorTextSecondary,
          size: 20.0,
        ),
      ),
    ),
    onTap: onTapCallback,
  );
}

Container buildContainerTopHood() {
  return Container(
    height: 20.0,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24.0),
        bottomRight: Radius.circular(24.0),
      ),
    ),
  );
}
