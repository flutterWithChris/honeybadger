import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileJobsSliverAppBar extends StatelessWidget {
  const MobileJobsSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        floating: true,
        pinned: true,
        centerTitle: true,
        leadingWidth: 40,
        // leading: const CircleAvatar(
        //   child: Icon(Icons.person),
        // ),
        title: Text(
          'OutsourcedX',
          style: GoogleFonts.gloock(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ],
        bottom: const TabBar(
          tabs: [
            Tab(
              text: 'Active',
            ),
            Tab(
              text: 'Applied',
            ),
            Tab(text: 'Completed')
          ],
        ));
  }
}
