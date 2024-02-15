import 'package:hollychat/models/author.dart';
import 'package:hollychat/models/link_preview.dart';
import 'package:hollychat/models/post_image.dart';

class Post {
  final int id;
  final List<String> content;
  final String originalText;
  final PostImage? image;
  final Author author;
  final List<PostImage> linkImages;
  final List<String> links;
  List<LinkPreview> linksPreviews;
  final DateTime createdAt;
  String get relativeTime => formatRelativeTime(createdAt);

  Post({
    required this.id,
    required this.content,
    required this.originalText,
    required this.author,
    required this.linkImages,
    required this.links,
    required this.linksPreviews,
    required this.createdAt,
    this.image,
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

  factory Post.fromJson(Map<String, dynamic> json) {
    String text = json['content'];
    RegExp expImg = RegExp(r'(https?://?[\w/\-?=%.&]+\.[\w/\-?=%.&]+\.(?:png|jpg|jpeg|gif|webp))', multiLine: true);
    RegExp exp = RegExp(r'(https?://?[\w/\-?=%.&]+\.[\w/\-?=%.&]*)', multiLine: true);
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

    return Post(
      id: json['id'],
      content: contents,
      originalText: text,
      author: Author.fromJson(json['author']),
      image: json['image'] == null ? null : PostImage.fromJson(json['image']),
      linkImages: images,
      links: links,
      linksPreviews: [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }

  Future<List<LinkPreview>> getPreviews() async {
    var a = links.map((url) =>
        LinkPreview.getFromUrl(url)
    );
    return (await Future.wait(a)).whereType<LinkPreview>().toList();
  }
}
