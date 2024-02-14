import 'package:collection/collection.dart';
import 'package:hollychat/models/post_image.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

import 'author.dart';
import 'link_preview.dart';

class PostComment {
  final int id;
  final List<String> content;
  final String originalString;
  final List<PostImage> imagesLinks;
  final List<String> links;
  List<LinkPreview> linksPreviews;
  final Author author;

  PostComment({
    required this.id,
    required this.content,
    required this.originalString,
    required this.imagesLinks,
    required this.links,
    required this.linksPreviews,
    required this.author,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    String text = json['content'];
    RegExp expImg = RegExp(r'(https?://?[\w/\-?=%.]+\.[\w/\-?=%.]+\.(?:png|jpg|jpeg|gif|webp))', multiLine: true);
    RegExp exp = RegExp(r'(https?://?[\w/\-?=%.]+\.[\w/\-?=%.]*)', multiLine: true);
    var matches = exp.allMatches(text);

    var index = 0;
    List<String> contents = [];
    List<PostImage> images = [];
    List<String> links = [];

    if (matches.isEmpty) {
      contents.add(text);
    } else {
      for (var i = 0; i < matches.first.groupCount; i++) {
        var start = text.indexOf(matches.first.group(i)!, index);
        if (start != index) {
          contents.add(text.substring(index, start));
        }
        index = start + matches.first.group(i)!.length;
        if(expImg.hasMatch(matches.first.group(i)!)) {
          images.add(PostImage(url: matches.first.group(i)!, height: 10, width: 10));
        } else {
          links.add(matches.first.group(i)!);
        }
        contents.add(matches.first.group(i)!);
      }

      if (matches.isNotEmpty && matches.last.end != text.length) {
        contents.add(text.substring(matches.last.end));
      }
    }

    if (images.length == 1 && contents.length == 1) {
      contents.clear();
    }

    return PostComment(
      id: json['id'],
      originalString: json['content'],
      content: contents,
      imagesLinks: images,
      links: links,
      linksPreviews: [],
      author: Author.fromJson(json['author']),
    );
  }

  Future<List<LinkPreview>> getPreviews() async {
    var a = links.map((url) =>
        getPreview(url)
    );
    return (await Future.wait(a)).whereType<LinkPreview>().toList();
  }

  Future<LinkPreview?> getPreview(String url) async {
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
  }

  void _getOG(Document doc, Map data, String param) {
    var metaTag = doc.getElementsByTagName("meta").firstWhereOrNull((
        meta) => meta.attributes['property'] == param);
    if (metaTag != null) {
      data[param] = metaTag.attributes['content'];
    }
  }
}