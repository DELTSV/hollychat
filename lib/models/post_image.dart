class PostImage {
  final String url;
  final int height;
  final int width;

  const PostImage({
    required this.url,
    required this.height,
    required this.width,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      url: json['url'],
      height: json['meta']['height'],
      width: json['meta']['width'],
    );
  }
}