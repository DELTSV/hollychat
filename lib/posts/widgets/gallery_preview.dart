import 'dart:io';

import 'package:flutter/material.dart';

import 'gallery_preview_icon_button.dart';
import 'image_button.dart';

enum GalleryItemType { camera, gallery, image }

class GalleryItem {
  const GalleryItem({this.image, this.type = GalleryItemType.image});

  final File? image;
  final GalleryItemType type;
}

// An horizontal list of images
class GalleryPreview extends StatelessWidget {
  const GalleryPreview({
    super.key,
    required this.imageList,
    required this.onImageSelected,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.imageSelected,
  });

  final List<File> imageList;
  final void Function(File) onImageSelected;
  final void Function() onCameraTap;
  final void Function() onGalleryTap;
  final File? imageSelected;

  @override
  Widget build(BuildContext context) {
    List<GalleryItem> items = [
      const GalleryItem(type: GalleryItemType.camera),
      ...imageList.map((e) => GalleryItem(image: e)),
      const GalleryItem(type: GalleryItemType.gallery),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          final galleryItem = items[index];

          switch (galleryItem.type) {
            case GalleryItemType.camera:
              return GalleryPreviewIconButton(
                onTap: onCameraTap,
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              );
            case GalleryItemType.gallery:
              return GalleryPreviewIconButton(
                onTap: onGalleryTap,
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              );
            case GalleryItemType.image:
              return ImageButton(
                image: galleryItem.image!,
                onTap: () => onImageSelected(galleryItem.image!),
                selected: galleryItem.image == imageSelected,
              );
          }
        },
      ),
    );
  }
}
