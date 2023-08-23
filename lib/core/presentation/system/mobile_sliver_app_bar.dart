import 'package:outsourcedx/globals.dart';
import 'package:flutter/material.dart';

class MobileSliverAppBar extends StatelessWidget {
  bool? noActions;
  bool? iconOnly;
  MobileSliverAppBar({this.noActions, this.iconOnly, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      //floating: true,
      //pinned: true,
      centerTitle: true,
      leadingWidth: 40,
      // leading: const CircleAvatar(
      //   child: Icon(Icons.person),
      // ),
      title: iconOnly == true
          ? Theme.of(context).brightness == Brightness.light
              ? Image.asset(
                  'assets/logos/OutsourcedX_black_logo.png',
                  height: 40,
                )
              : Image.asset(
                  'assets/logos/OutsourcedX_White.png',
                  height: 40,
                )
          : const OutsourcedFullText(),
    );
  }
}
