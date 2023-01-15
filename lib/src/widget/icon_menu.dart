import 'package:flutter/material.dart';

class IconMenu extends StatelessWidget {
  final EdgeInsets padding;
  final Color color;
  final List<MapEntry<Icon, Function()>> actions;

  const IconMenu(
      {super.key,
      required this.padding,
      required this.color,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    return Ink(
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildActions(),
        ));
  }

  List<Widget> _buildActions() {
    return actions.map((action) {
      return InkWell(
          customBorder: const CircleBorder(),
          onTap: action.value,
          child: Padding(padding: padding, child: action.key));
    }).toList();
  }
}
