import 'package:flutter/material.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Agreement'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Vestibulum tincidunt, nisi vel tincidunt aliquet, libero velit '
              'vehicula lectus, sed aliquam elit erat ac nulla. Phasellus eu '
              'semper lorem. Integer malesuada nisl sed nisi aliquet, vel '
              'dictum nulla tempus. Curabitur varius, sapien nec volutpat '
              'convallis, dolor ipsum convallis justo, id condimentum lectus '
              'nunc at lorem. Praesent vel aliquet dui. Nam bibendum sapien id '
              'leo scelerisque, vitae auctor orci mollis.',
              textAlign: TextAlign.justify, // Justify text alignment
            ),
            SizedBox(height: 16),
            Text(
              'Proin vehicula, turpis id dapibus cursus, metus ante facilisis '
              'libero, vitae fermentum elit lectus in odio. Nulla sed tortor '
              'vel tortor convallis euismod. In hac habitasse platea dictumst. '
              'Nullam condimentum malesuada justo, non varius nisl feugiat non. '
              'Etiam egestas varius ante id vulputate. Ut tristique elementum '
              'erat. Donec posuere arcu id ligula ultricies, vel ornare eros '
              'vehicula.',
              textAlign: TextAlign.justify, // Justify text alignment
            ),
            SizedBox(height: 16),
            Text(
              'Fusce nec felis ut justo aliquet gravida. Sed lacinia enim eu '
              'mi cursus facilisis. Integer vehicula lectus non tellus '
              'fermentum, et elementum tortor volutpat. Nam ut orci a risus '
              'blandit efficitur. Sed vel justo in libero fringilla tempor '
              'eget eget ligula.',
              textAlign: TextAlign.justify, // Justify text alignment
            ),
          ],
        ),
      ),
    );
  }
}
