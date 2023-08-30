import 'package:cached_network_image/cached_network_image.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/model/portfolio_project.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outsourcedx/profile/portfolio/dialogs/edit_portfolio_project_dialog.dart';
import 'package:outsourcedx/profile/portfolio/dialogs/view_portfolio_project_dialog.dart';

class PortfolioCard extends StatelessWidget {
  final PortfolioProject project;
  const PortfolioCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                if (context.watch<ProfileBloc>().state.user!.userType ==
                    UserType.client) {
                  return ViewPortfolioProjectDialog(
                    project: project,
                  );
                } else {
                  return EditPortfolioProjectDialog(
                    project: project,
                  );
                }
              },
            );
          },
          child: Stack(
            children: [
              if (project.images != null)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedNetworkImage(
                      imageUrl: project.images![0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: LinearGradient(
                      stops: const [0.0, 0.9],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
