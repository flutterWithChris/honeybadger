import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/onboarding/bloc/onboarding_bloc.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/client/mobile_client_profile_setup.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/desktop/desktop_profile_setup.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/mobile/mobile_profile_setup.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/tablet/tablet_profile_setup.dart';
import 'package:OutsourcedX/profile/model/user.dart';

class ProfileSetup extends StatefulWidget {
  final PageController pageController;
  const ProfileSetup({required this.pageController, super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == OnboardingStatus.failure) {
              return const Center(
                child: Text('Error Onboarding...'),
              );
            } else if (state.status == OnboardingStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == OnboardingStatus.loaded) {
              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > tabletWidthConstraint) {
                  return TabletProfileSetup(
                      pageController: widget.pageController);
                } else if (constraints.maxWidth > desktopWidthConstraint) {
                  return DesktopProfileSetup(
                      pageController: widget.pageController);
                } else {
                  // TODO: Client Profile Setup
                  if (state.user!.userType == UserType.freelancer) {
                    return MobileProfileSetup(
                        pageController: widget.pageController);
                  } else {
                    return MobileClientProfileSetup(
                        pageController: widget.pageController);
                  }
                }
              });
            } else {
              return const Center(child: Text('Something went wrong...'));
            }
          },
        ),
      ),
    );
  }
}
