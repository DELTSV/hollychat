import 'package:flutter/material.dart';

class SettingsItem {
  const SettingsItem({
    required this.type,
    required this.content,
  });

  final MenuItemType type;
  final Widget content;
}

enum MenuItemType {
  edit,
  delete,
}

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    super.key,
    required this.onItemSelected,
  });

  final void Function(MenuItemType value) onItemSelected;

  List<PopupMenuItem<MenuItemType>> _buildItems() {
    const List<SettingsItem> items = [
      SettingsItem(
        type: MenuItemType.edit,
        content: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            SizedBox(width: 10),
            Text('Éditer'),
          ],
        ),
      ),
      SettingsItem(
        type: MenuItemType.delete,
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
          ],
        ),
      ),
    ];

    return items
        .map(
          (SettingsItem item) => PopupMenuItem<MenuItemType>(
            value: item.type,
            child: item.content,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItemType>(
      iconColor: Colors.white,
      onSelected: onItemSelected,
      itemBuilder: (BuildContext context) {
        return _buildItems();
      },
    );
  }
}
