import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import '../controllers/webview_controller.dart';

// Firebase WebviewController using GetX

class WebviewScreen extends StatefulWidget {
  String url;

  WebviewScreen({required this.url});

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

late InAppWebViewController _webViewController;

class _WebviewScreenState extends State<WebviewScreen> {
  bool bac = false;
  bool far = false;
  final _key = UniqueKey();
  bool isLoading = false;
  Color bacColor = Colors.black;

  final WebviewController webviewController = Get.put(WebviewController());

  @override
  void initState() {
    super.initState();

    // React to Firebase changes and update the WebView in real-time
    everAll([webviewController.web, webviewController.link], (_) {
      final webValue = webviewController.web.value;
      final linkValue = webviewController.link.value;

      if (webValue == 'true' && linkValue.isNotEmpty) {
        _loadUrl(linkValue);
      }
    });
  }

  void _loadUrl(String newUrl) async {
    try {
      await _webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri(newUrl)),
      );
    } catch (e) {
      debugPrint('Error loading URL: $e');
    }
  }

  Future<void> launchGoogleSignIn(String url) async {
    const String googleSignInUrl = 'https://accounts.google.com/o/oauth2/v2/auth?...'; // Customize as needed
    if (await canLaunchUrl(Uri.parse(googleSignInUrl))) {
      await launchUrl(Uri.parse(googleSignInUrl));
    } else {
      throw 'Could not launch Google Sign-in';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openWhatsAppChatWithPerson(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                if (await _webViewController.canGoBack()) {
                  _webViewController.goBack();
                  return false;
                }
                return true;
              },
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.url.toString()),
                ),
                onEnterFullscreen: (controller) async {
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                },
                onPermissionRequest: (controller, origin) async {
                  return PermissionResponse(
                      action: PermissionResponseAction.GRANT);
                },
                onExitFullscreen: (controller) async {
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                },
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  initialScale: 1,
                  userAgent: Platform.isIOS
                      ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
                      : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
                  mediaPlaybackRequiresUserGesture: false,
                  supportZoom: true,
                  mixedContentMode:
                  MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  safeBrowsingEnabled: false,
                  verticalScrollBarEnabled: false,
                  horizontalScrollBarEnabled: false,
                  useShouldOverrideUrlLoading: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onReceivedError: (controller, uri, error) {
                  isLoading = false;
                },
                onLoadStart: (controller, uri) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() async {
                    isLoading = false;
                    if (await _webViewController.canGoBack()) {
                      bac = true;
                    } else {
                      bac = false;
                    }
                    if (await _webViewController.canGoForward()) {
                      far = true;
                    } else {
                      far = false;
                    }
                  });
                  debugPrint('Page finished loading: $url');
                },
                onProgressChanged: (controller, progress) {
                  debugPrint('progress ...........' + progress.toString());
                  setState(() {
                    if (progress == 80) {
                      isLoading = false;
                    }
                  });
                },
                shouldOverrideUrlLoading:
                    (controller, navigationAction) async {
                  final uri = navigationAction.request.url;

                  if (uri != null) {
                    if (uri.scheme == 'mailto') {
                      _launchUrl(uri.toString());
                      return NavigationActionPolicy.CANCEL;
                    } else if (uri.scheme == 'accounts.google') {
                      launchGoogleSignIn(uri.toString());
                      return NavigationActionPolicy.CANCEL;
                    } else if (uri.scheme == 'whatsapp' &&
                        uri.host == 'chat') {
                      _openWhatsAppChatWithPerson(uri.toString());
                      return NavigationActionPolicy.CANCEL;
                    } else if (uri.scheme == 'https' &&
                        uri.host == 'm.me') {
                      _launchUrl(uri.toString());
                      return NavigationActionPolicy.CANCEL;
                    } else if (uri.toString().startsWith('intent://')) {
                      final fallbackUrl =
                      _extractBrowserFallbackUrl(uri.toString());
                      if (fallbackUrl != null) {
                        _launchUrl(fallbackUrl);
                      } else {
                        print('No fallback URL found in intent.');
                      }
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[100],
                child: Shimmer.fromColors(
                  baseColor: Colors.black12,
                  highlightColor: Colors.white10,
                  enabled: isLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    width:
                                    MediaQuery.of(context).size.width - 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    height: 20,
                                    margin:
                                    EdgeInsets.symmetric(vertical: 10),
                                    width:
                                    MediaQuery.of(context).size.width - 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerLine(context, 40),
                              shimmerLine(context, 100),
                              shimmerLine(context, 200),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        shimmerBlock(context),
                        shimmerCard(context),
                        shimmerCard(context),
                        shimmerCard(context),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerLine(BuildContext context, double offset) {
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width - offset,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget shimmerBlock(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
    );
  }

  Widget shimmerCard(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String? _extractBrowserFallbackUrl(String intentUrl) {
    try {
      final fallbackIndex = intentUrl.indexOf('S.browser_fallback_url=');
      if (fallbackIndex != -1) {
        final fallbackPart =
        intentUrl.substring(fallbackIndex + 'S.browser_fallback_url='.length);
        final endIndex = fallbackPart.indexOf(';');
        String fallbackUrl = (endIndex != -1
            ? fallbackPart.substring(0, endIndex)
            : fallbackPart);

        fallbackUrl = Uri.decodeComponent(fallbackUrl);
        if (!fallbackUrl.startsWith('http')) {
          fallbackUrl = 'https://' + fallbackUrl;
        }
        return fallbackUrl;
      }
    } catch (e) {
      print('Error extracting fallback url: $e');
    }
    return null;
  }
}
