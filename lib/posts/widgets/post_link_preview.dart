import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hollychat/posts/widgets/post_link_preview_image.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class PostLinkPreview extends StatefulWidget {
  const PostLinkPreview({super.key, required this.url});

  final String url;

  @override
  State<PostLinkPreview> createState() => _PostLinkPreviewState();
}

class _PostLinkPreviewState extends State<PostLinkPreview> {

  bool _isVisible = true;
  Map? _linkPreviewData;

  @override
  void initState() {
    super.initState();
    _getLinkData();
  }

  @override
  void didUpdateWidget(covariant PostLinkPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getLinkData();
  }

  void _getLinkData() async {
    if(!mounted) {
      return;
    }

    var response = await get(Uri.parse(widget.url));
    if(response.statusCode != 200) {
      setState(() {
        _linkPreviewData = null;
      });
    }

    var doc = parse(response.body);
    Map linkData = {};
    _getOG(doc, linkData, 'og:title');
    _getOG(doc, linkData, 'og:description');
    _getOG(doc, linkData, 'og:site_name');
    _getOG(doc, linkData, 'og:image');

    if(linkData.isNotEmpty) {
      setState(() {
        _linkPreviewData = linkData;
        _isVisible = true;
      });
    }
  }

  void _getOG(html.Document doc, Map data, String param) {
    var metaTag = doc.getElementsByTagName("meta").firstWhereOrNull((meta) => meta.attributes['property'] == param);
    if(metaTag != null) {
      data[param] = metaTag.attributes['content'];
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_linkPreviewData == null || !_isVisible) {
      return const SizedBox();
    }

    return SizedBox(
      height: 130,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(widget.url)),
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
              PostLinkPreviewImage(imageUrl: _linkPreviewData!["og:image"]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 32.0, 0),
                  child: Text(_linkPreviewData!['og:title'], overflow: TextOverflow.ellipsis, maxLines: 3, style: const TextStyle(color: Colors.grey),),
                ),
              ),
            ],
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_linkPreviewData!["og:site_name"], style: const TextStyle(fontSize: 20, color: Colors.white70),),
                Text(_linkPreviewData!["og:description"], style: const TextStyle(color: Colors.grey),),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
