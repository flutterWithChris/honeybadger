import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileSliverAppBar extends StatelessWidget {
  bool? noActions;
  MobileSliverAppBar({this.noActions, super.key});

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
      title: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Image.asset(
          //   'assets/honeybee_logo.png',
          //   color: Theme.of(context).brightness == Brightness.light
          //       ? const Color(0xFF1E2223)
          //       : Colors.white,
          //   height: 18,
          // ),

          Text(
            'OutsourcedX',
            style: GoogleFonts.gloock(),
          ),
        ],
      ),
      actions: noActions == true
          ? null
          : [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
              ),
            ],
    );
  }
}
