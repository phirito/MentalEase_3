import 'package:flutter/material.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16),
          Text(
            "      User Agreement & Disclaimer",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 9),
          Text(
            '''
Introduction
Welcome to Mental Ease, an application designed to promote mental wellness for junior high school students through its features of Mood Tracking, Meditation, and Journaling. By using this application, you agree to the terms and conditions outlined in this User Agreement and Disclaimer. Please read the following carefully before using the app.''',
            textAlign: TextAlign.justify, // Justify text alignment
          ),
          SizedBox(height: 16),
          Text(
            '''1. Purpose of the Application
  Mental Ease is intended to be a supplementary tool for promoting mindfulness, emotional awareness, and stress relief. The application offers features that help users manage their daily stressors but is not designed or intended to replace professional mental health care or therapy. It is important to note that Mental Ease is not a medical or psychological treatment tool and should not be used as a substitute for professional advice, diagnosis, or treatment.

2. No Professional Advice or Diagnosis
  The content and services provided by Mental Ease, including but not limited to the Mood Tracker, Meditation exercises, and Journaling features, are for informational purposes only. The application does not offer any form of clinical or medical advice, nor does it provide a diagnosis or treatment for any mental health condition, including but not limited to anxiety, depression, or any other mental illness. If you are experiencing severe mental health issues, you are encouraged to seek the assistance of a qualified mental health professional.

3. Limitation of Liability
  By using Mental Ease, you acknowledge that the developers of the application, the school, and any affiliated personnel will not be held responsible or liable for any direct, indirect, incidental, or consequential damages that may arise from the use or misuse of the application. This includes, but is not limited to, any accidents, injuries, or emotional distress that may result from reliance on the application or its features. The app is used entirely at your own risk.

4. Use of Application
  Mental Ease is designed for personal use by junior high school students to support general mental well-being. The application is not intended for use in diagnosing, preventing, or treating any form of mental health condition. The school and the developers strongly recommend consulting a licensed mental health professional if you are facing challenges beyond general stress management or if you are experiencing symptoms of depression, anxiety, or other serious mental health concerns.

5. No Guarantee of Results
  Mental Ease provides general wellness features that aim to reduce daily stress, improve mindfulness, and promote emotional self-awareness. However, the developers of the application do not make any guarantees or promises about the effectiveness of the app in reducing stress, anxiety, or other mental health issues. The effectiveness of the app may vary from person to person, and any improvement in mental well-being is not guaranteed.

6. User Responsibility
  It is the user’s responsibility to use Mental Ease in a manner that is appropriate for their personal circumstances. The application should not be used as a substitute for professional medical advice, counseling, or therapy. The user assumes full responsibility for any consequences that may arise from the improper use of the application.

7. Parental Consent
  For users under the age of 18, parental consent is required before using Mental Ease. Parents and guardians are encouraged to monitor their child's use of the application and to provide guidance if necessary.

8. Updates and Modifications
  The developers reserve the right to modify, update, or discontinue any part of Mental Ease at any time without prior notice. By continuing to use the application, users agree to any modifications or updates to this agreement.

9. Acceptance of Terms
  By downloading and using Mental Ease, you acknowledge that you have read, understood, and agreed to the terms outlined in this User Agreement and Disclaimer. If you do not agree with any of the terms, please discontinue use of the application immediately.''',
            textAlign: TextAlign.justify, // Justify text alignment
          ),
          SizedBox(height: 16),
          Text(
            '''For any concerns or questions regarding this User Agreement and Disclaimer, please contact the developer at [Contact Information].

This document is effective as of [Date].''',
            textAlign: TextAlign.justify, // Justify text alignment
          ),
        ],
      ),
    );
  }
}
