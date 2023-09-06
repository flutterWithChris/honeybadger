import 'package:flutter/material.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
          slivers: [
            MobileSliverAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '1. Terms',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                        'By using the OutsourcedX App, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree with these Terms, please do not use the OutsourcedX App.'),
                    const SizedBox(height: 16),
                    const Text(
                      '2. Use License',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Permission is granted to temporarily download one copy of the materials (information or software) on OutsourcedX\'s website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '- Modify or copy the materials;',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '- Use the materials for any commercial purpose, or for any public display (commercial or non-commercial);',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '- Attempt to decompile or reverse engineer any software contained on OutsourcedX\'s website;',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '- Remove any copyright',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This license shall automatically terminate if you violate any of these restrictions and may be terminated by OutsourcedX at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '3. Disclaimer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'The materials on OutsourcedX\'s website are provided on an \'as is\' basis. OutsourcedX makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Further, OutsourcedX does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its website or otherwise relating to such materials or on any sites linked to this site.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '4. Limitations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'In no event shall OutsourcedX or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on OutsourcedX\'s website, even if OutsourcedX or a OutsourcedX authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '5. Accuracy of materials',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'The materials appearing on OutsourcedX\'s website could include technical, typographical, or photographic errors. OutsourcedX does not warrant that any of the materials on its website are accurate, complete or current. OutsourcedX may make changes to the materials contained on its website at any time without notice. However OutsourcedX does not make any commitment to update the materials.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '6. Links',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'OutsourcedX has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by OutsourcedX of the site. Use of any such linked website is at the user\'s own risk.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '7. Modifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'OutsourcedX may revise these terms of service for its website at any time without notice. By using this website you are agreeing to be bound by the then current version of these terms of service.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '8. Governing Law',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'These terms and conditions are governed by and construed in accordance with the laws of United States and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '9. Contact Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'If you have any questions about these Terms, please contact us.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '10. Platform Fees',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('10.1 Fees for Using the Platform',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    const Text(
                      '''By using the OutsourcedX App, you acknowledge and agree to the following fee structure:
\n- Platform fees are non-refundable, except as otherwise determined by the Company in its sole discretion.''',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('10.2 Transaction-Based Fees',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    const Text(
                        '''- For each transaction processed through the OutsourcedX platform, including milestone payments, hourly payments, and other forms of payment, both freelancers and clients are subject to a platform fee equal to 5% of the total transaction amount.
\n- These fees will be automatically deducted or added to the respective transaction amounts, depending on whether you are a freelancer or a client.
'''),
                    const Text('10.3 Fee Changes',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    const Text(
                        '''The Company reserves the right to modify the fee structure at its discretion. Any changes to the fee structure will be communicated to users through the App or via email.'''),
                    const SizedBox(height: 8.0),
                    const Text('10.4 Taxes',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    const Text(
                        '''You are responsible for paying any taxes, including any goods and services or value added taxes, which may be applicable depending on the jurisdiction of the services provided. These taxes will be added to fees billed to you, if applicable.'''),
                    const SizedBox(height: 8.0),
                    const Text('10.5 Refunds',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    const Text(
                        '''All fees are non-refundable, except as otherwise determined by the Company in its sole discretion. If you believe that you have been charged in error, you must contact us within 30 days of such charge. No refunds will be given for any charges more than 30 days old. We reserve the right to issue refunds or credits at our sole discretion. If we issue a refund or credit, we are under no obligation to issue the same or similar refund in the future. This refund policy does not affect any statutory rights that may apply.'''),
                    const SizedBox(height: 8.0),
                    const Text(
                      'This Terms of Service policy is effective as of 1 January 2023.',
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
