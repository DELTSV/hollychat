import 'package:hollychat/models/post_image.dart';

import 'author.dart';
import 'link_preview.dart';

class PostComment {
  final int id;
  final List<String> content;
  final DateTime createdAt;
  final String originalString;
  final List<PostImage> imagesLinks;
  final List<String> links;
  List<LinkPreview> linksPreviews;
  final Author author;

  String get relativeTime => formatRelativeTime(createdAt);

  PostComment({
    required this.id,
    required this.createdAt,
    required this.content,
    required this.originalString,
    required this.imagesLinks,
    required this.links,
    required this.linksPreviews,
    required this.author,
  });

  String formatRelativeTime(DateTime? time) {
    if (time == null) return "";

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d";
    } else {
      return "${difference.inDays ~/ 7}w";
    }
  }

  factory PostComment.fromJson(Map<String, dynamic> json) {
    String text = json['content'];
    RegExp expImg = RegExp(
      r'(https?://?[\w/\-?=%.&]+\.[\w/\-?=%.&]+\.(?:png|jpg|jpeg|gif|webp))',
      multiLine: true,
    );
    RegExp exp = RegExp(
      r'(https?://?[\w/\-?=%.&]+\.[\w/\-?=%.&]*)',
      multiLine: true,
    );
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
        if (expImg.hasMatch(matches.first.group(i)!)) {
          images.add(
              PostImage(url: matches.first.group(i)!, height: 10, width: 10));
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
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }

  Future<List<LinkPreview>> getPreviews() async {
    var a = links.map((url) => LinkPreview.getFromUrl(url));
    return (await Future.wait(a)).whereType<LinkPreview>().toList();
  }
}
