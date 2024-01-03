// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:geolocator/geolocator.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isHide = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _whereToGo();
  }

   _whereToGo() {
    Timer(const Duration(seconds: 1),() {
       return _launchUrl(context);
     // Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewPage()));
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 152, 218, 15),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: logoWidget("assets/men.png",),
          ),
          const SizedBox(height: 15),
          const Text('Flew Air Conditioning Solution',style: TextStyle(color: Colors.white,fontSize: 25),),
        ],
      ),
    );
  }

  logoWidget(String s) {
    return Image.asset(s,scale: 0.50,
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.9,
    );
  }

  void _launchUrl(BuildContext context) async {
    try {
      await launch(
        'https://flewac.com/android_login/',
        customTabsOption: const CustomTabsOption(
          toolbarColor: Colors.white,
          enableDefaultShare: false,
          enableUrlBarHiding: false,
          showPageTitle: false,
          // animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: const SafariViewControllerOption(
          preferredBarTintColor: Colors.white,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}