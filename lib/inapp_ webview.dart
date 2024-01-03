// ignore_for_file: unused_field, deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  @override
  _InAppWebViewPageState createState() => new _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late InAppWebViewController _inAppWebViewController;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(await _inAppWebViewController.canGoBack()) {
          _inAppWebViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
        child: Stack(
          children: [
            const SizedBox(height: 10,),
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse('https://flewac.com/android_login/')),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _inAppWebViewController = controller;
              },
              androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              onProgressChanged: (InAppWebViewController controller,int progress) {
                setState(() {
                  _progress = progress/100;
                });
              },
            ),
            _progress < 1
                ? SizedBox(height: 5,
                child: LinearProgressIndicator(
                  value: _progress,
                  color: const Color.fromRGBO(0, 152, 218, 5),
                  backgroundColor: Colors.white,
                )) : const SizedBox(),
          ],
        ),
      );
  }
}