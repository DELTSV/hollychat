import 'package:hollychat/models/author.dart';
import 'package:hollychat/models/post_image.dart';

class Post {
  final int id;
  final List<String> content;
  final String originalText;
  final PostImage? image;
  final Author author;
  final List<PostImage> linkImages;

  const Post({
    required this.id,
    required this.content,
    required this.originalText,
    required this.author,
    this.image,
    required this.linkImages,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String text = json['content'];
    RegExp expImg = RegExp(r'(https?://?[\w/\-?=%.]+\.[\w/\-?=%.]+\.(?:png|jpg|jpeg|gif|webp))', multiLine: true);
    RegExp exp = RegExp(r'(https?://?[\w/\-?=%.]+\.[\w/\-?=%.]+)', multiLine: true);
    var matches = exp.allMatches(text);

    var index = 0;
    List<String> contents = [];
    List<PostImage> images = [];

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
      linkImages: images
    );
  }
}
