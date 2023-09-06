import 'package:flutter/material.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          MobileSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your privacy is important to us. It is OutsourcedX\'s policy to respect your privacy regarding any information we may collect from you across our website, https://outsourcedx.com, and other sites we own and operate.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We don’t share any personally identifying information publicly or with third-parties, except when required to by law.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Our website may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites, and cannot accept responsibility or liability for their respective privacy policies.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your continued use of our website will be regarded as acceptance of our practices around privacy and personal information. If you have any questions about how we handle user data and personal information, feel free to contact us.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This policy is effective as of 1 January 2021.',
                  ),
                ],
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
