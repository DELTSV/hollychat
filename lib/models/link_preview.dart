import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class LinkPreview {
  final String url;
  final String title;
  final String description;
  final String? image;
  final String siteName;

  const LinkPreview({
    required this.url,
    required this.title,
    required this.description,
    this.image,
    required this.siteName
  });

  static Future<LinkPreview?> getFromUrl(String url) async {
    try {
      var response = await get(Uri.parse(url));
      if (response.statusCode != 200) {
        return null;
      }

      var doc = parse(response.body);
      Map linkData = {};
      _getOG(doc, linkData, 'og:title');
      _getOG(doc, linkData, 'og:description');
      _getOG(doc, linkData, 'og:site_name');
      _getOG(doc, linkData, 'og:image');

      if (linkData.isNotEmpty && linkData.containsKey("og:title") &&
          linkData.containsKey("og:site_name") &&
          linkData.containsKey("og:description")) {
        return LinkPreview(url: url,
          title: linkData['og:title'],
          description: linkData['og:description'],
          image: linkData['og:image'],
          siteName: linkData['og:site_name'],);
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  static void _getOG(Document doc, Map data, String param) {
    var metaTag = doc.getElementsByTagName("meta").firstWhereOrNull((
        meta) => meta.attributes['property'] == param);
    if (metaTag != null) {
      data[param] = metaTag.attributes['content'];
    }
  }
}