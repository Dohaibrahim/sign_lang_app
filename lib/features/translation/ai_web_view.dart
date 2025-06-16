import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewCamera extends StatefulWidget {
  @override
  _WebViewCameraState createState() => _WebViewCameraState();
}

class _WebViewCameraState extends State<WebViewCamera> {
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]?.isGranted != true ||
        statuses[Permission.microphone]?.isGranted != true) {
      print("Camera or microphone permission not granted");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera and microphone permission required")),
      );
    } else {
      print("All permissions granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebView Camera")),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri("http://44.246.135.176:5173/realtime-translation"),
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
              useShouldOverrideUrlLoading: true,
              userAgent:
                  'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Mobile Safari/537.36',
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
              supportMultipleWindows: true,
              
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
              allowsAirPlayForMediaPlayback: true,
            ),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
            print("WebView created");
          },
          androidOnPermissionRequest:
              (controller, origin, resources) async {
            print("Permission requested by WebView for: $resources");
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          onReceivedServerTrustAuthRequest:
              (controller, challenge) async {
            return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            );
          },
         
        ),
      ),
    );
  }
}
