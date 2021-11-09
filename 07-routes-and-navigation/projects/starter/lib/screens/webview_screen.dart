import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  static MaterialPage page() => MaterialPage(
        name: FooderlichPages.raywenderlich,
        key: ValueKey(FooderlichPages.raywenderlich),
        child: const WebViewScreen(),
      );

  const WebViewScreen({Key? key}) : super(key: key);

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('raywenderlich.com'),
      ),
      body: Platform.isWindows
          ? buildUrlLauncher()
          : const WebView(initialUrl: 'https://raywenderlich.com/'),
    );
  }

  Widget buildUrlLauncher() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '''WebView is not supported on Windows!''',
            style: GoogleFonts.alef(color: Colors.yellow, fontSize: 18),
          ),
          TextButton(
            onPressed: () {
              _launchInBrowser('https://raywenderlich.com/');
            },
            child: const Text(
              'Open in browser',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
