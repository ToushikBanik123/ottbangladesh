import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ottapp/ui/auth/splash/splash_controller.dart';

import '../../../base/widget/central_error_placeholder.dart';
import '../../../base/widget/custom_filled_button.dart';
import '../../../constants.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal,
      child: Scaffold(
        backgroundColor: colorPrimary,
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(32.0),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetBuilder<SplashController>(
          id: "body",
          init: SplashController(),
          builder: (viewController) {
            return FutureBuilder<bool>(
              future: viewController.isInternetAvailable,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return ClipOval(
                    child: Image.asset(
                      "images/logo.png",
                      height: 150.0,
                      fit: BoxFit.fitHeight,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      CentralErrorPlaceholder(
                        message: "${snapshot.error}",
                      ),
                      CustomFilledButton(
                        title: "Retry",
                        onTap: () {
                          viewController.retryToConnect();
                        },
                      ),
                    ],
                  );
                } else {
                  return ClipOval(
                    child: Image.asset(
                      "images/logo.png",
                      height: 150.0,
                      fit: BoxFit.fitHeight,
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
