import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  final EdgeInsets padding;
  final Icon icon;
  final Function() onTap;

  const FooterButton(
      {super.key,
      required this.padding,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(padding: padding, child: icon),
    );
  }
}
