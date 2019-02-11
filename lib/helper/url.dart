import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;

/// Launches a [url] inside the app.
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}
