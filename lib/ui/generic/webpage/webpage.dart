import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ottapp/ui/generic/webpage/webpage_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../base/widget/central_progress_indicator.dart';
import '../../../constants.dart';

class WebPage extends StatelessWidget {
  final String url;

  WebPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebPageController>(
      id: "body",
      init: WebPageController(),
      builder: (viewController) {
        return AnnotatedRegion(
          value: systemUiOverlayStyleGlobal,
          child: Scaffold(
            backgroundColor: colorPrimary,
            body: SafeArea(
              child: IndexedStack(
                index: viewController.stackIndex,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: WebView(
                          debuggingEnabled: kDebugMode,
                          initialUrl: 'about:blank',
                          javascriptMode: JavascriptMode.unrestricted,
                          onPageFinished: viewController.handleLoad,
                          onWebViewCreated: (WebViewController controller) {
                            viewController.webViewController = controller;
                            viewController.webViewController?.loadUrl(this.url);
                          },
                        ),
                      ),
                    ],
                  ),
                  CentralProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
