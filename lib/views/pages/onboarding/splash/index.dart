import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/login_view_model.dart';
import 'package:umgkh_mobile/views/pages/onboarding/login/index.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:umgkh_mobile/widgets/screen_container.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    // Make status bar icons white
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
      ),
    );

    _getVersion();
    _navigateBasedOnToken();
  }

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void _navigateBasedOnToken() async {
    bool hasToken =
        await Provider.of<LoginViewModel>(context, listen: false).checkToken();
    if (!mounted) return;
    if (hasToken) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ScreenContainer(
            pageIndex: 0,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: theme().primaryColor,
        body: Stack(
      children: [
        /// CENTER LOGO (like native splash)
        // Center(
        //   child: Image.asset(
        //     'assets/images/splash.png',
        //     // width: screenWidth * 0.3, // 60% of screen width
        //     width: 140, // same typical size as native splash
        //   ),
        // ),

        /// FULL-SCREEN BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
        ),

        /// BOTTOM INFO (version + loader)
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 12),
              Text(
                'Version $_version',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
