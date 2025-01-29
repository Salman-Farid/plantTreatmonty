import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.separator.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 0.5),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search diseases...',
            hintStyle: TextStyle(color: CupertinoColors.placeholderText),
            prefixIcon: Icon(CupertinoIcons.search, color: CupertinoColors.placeholderText),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(color: CupertinoColors.label),
        ),
      ),
    );
  }
}