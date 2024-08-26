import 'package:flutter/material.dart';
import 'package:mentalease_2/core/utils/shared_widgets.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/features/signin/login_area.dart';
import 'package:mentalease_2/features/signup/signup_area.dart';
import 'startupdesign_widgets.dart'; // Import User Agreement page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        logo: Image.asset(
          'assets/images/mentalease_logo.png',
          width: 50,
          height: 50,
        ),
        title: 'MentalEase',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.logo, required this.title});

  final Widget logo;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       const Expanded(
      //         child: Align(
      //           alignment: Alignment.centerRight,
      //           child: Text('Mental'),
      //         ),
      //       ),
      //       widget.logo,
      //       const Expanded(
      //         child: Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text('Ease'),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: null, // Prevent overlapping issues
          ),

          _buildMainPage(context),
        ],
      ),
    );
  }

  Widget _buildMainPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 300, 20, 20), // Adjust the padding value as needed
                child: Image.asset(
                  "assets/images/mentalease_logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                'Welcome to MentalEase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50, // Change the text size here
                  fontFamily:
                      'CustomFont', // Replace 'CustomFont' with your font's name
                  fontWeight: FontWeight.bold,
                  // Optional: add boldness
                ),
              ),
            ),
          ),
          Container(
            width: 320,
            height: 750,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 116, 8, 0),
              borderRadius: BorderRadius.circular(20), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Shadow color
                  spreadRadius: 2, // How much the shadow spreads
                  blurRadius: 10, // How blurry the shadow is
                  offset: const Offset(
                      0, 5), // Position of the shadow (horizontal, vertical)
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Apply the same border radius
              child: const Center(
                child:
                    UserAgreementPage(), // Display the User Agreement widget here
              ),
            ),
          ),
          vSpacer(20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginArea();
              }));
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 148, 2, 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
              child: Text("Sign-In"),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignUpArea();
              }));
            },
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text("Sign-Up"),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Color.fromARGB(255, 116, 8, 0)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeArea();
              }));
            },
            splashColor: const Color.fromARGB(0, 99, 0, 0),
            highlightColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
