import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hollychat/models/link_preview.dart';
import 'package:hollychat/posts/widgets/post_link_preview_image.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class PostLinkPreview extends StatefulWidget {
  const PostLinkPreview({super.key, required this.linkPreview});

  final LinkPreview linkPreview;

  @override
  State<PostLinkPreview> createState() => _PostLinkPreviewState();
}

class _PostLinkPreviewState extends State<PostLinkPreview> {

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if(!_isVisible) {
      return const SizedBox();
    }

    return SizedBox(
      height: 138,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(widget.linkPreview.url)),
            child: _buildPreview(context),
          ),
          _buildCloseButton()
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _isVisible = false;
          });
        },
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PostLinkPreviewImage(imageUrl: widget.linkPreview.image),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 32.0, 0),
                  child: Text(widget.linkPreview.title, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(color: Colors.grey),),
                ),
              ),
            ],
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 2, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.linkPreview.siteName, style: const TextStyle(fontSize: 20, color: Colors.white70), overflow: TextOverflow.ellipsis,),
                Text(widget.linkPreview.description, style: const TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis,),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
