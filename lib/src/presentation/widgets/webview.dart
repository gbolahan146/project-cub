import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String? title;
  final String? url;

  const WebviewPage({Key? key, this.title, this.url}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  // ignore: unused_field
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return CbScaffold(
      appBar: CbAppBar(
        title: '${widget.title}',
        automaticallyImplyLeading: true,
      ),
      resizeToAvoidBottomInset: false,
      body: WebView(
        gestureRecognizers: [
          Factory(() => EagerGestureRecognizer()),
          Factory(() => VerticalDragGestureRecognizer()),
          Factory(() => TapGestureRecognizer()),
        ].toSet(),
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _webViewController = webViewController,
        onPageFinished: (String url) {

        },
      ),
    );
  }
}
