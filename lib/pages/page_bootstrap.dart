import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:metro/classes/constants.dart';
import 'package:metro/classes/database_manager.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BootstrapPage extends StatefulWidget {
  const BootstrapPage({super.key});

  @override
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _initApp();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Center(
                child: AvatarGlow(
                  glowRadiusFactor: 2,
                  glowColor: Theme.of(context).colorScheme.primary,
                  child: Material(
                    elevation: 8.0,
                    shape: const CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(1),
                      radius: 60.0,
                      child: SvgPicture.asset('assets/images/ic_note.svg', height: 400),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initApp() async {
    await DatabaseManager().init();
    MetroProvider provider = Provider.of<MetroProvider>(context, listen: false);
    final items = await DatabaseManager().playlistItems();
    provider.playlistItems = items;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    provider.fixedTickPeriod = prefs.getBool(Constants.PREFS_FIXED_TICK_PERIOD) ?? false;
    provider.autoHideContent = prefs.getBool(Constants.PREFS_AUTO_HIDE_CONTENT) ?? false;
    provider.backgroundColor = prefs.getString(Constants.PREFS_BACKGROUND_COLOR) ?? Constants.BACKGROUND_COLORS.first['key'];

    debugPrint("------- READ FROM PREFS --------");
    debugPrint(">> FIXED TICK PERIOD ${provider.fixedTickPeriod}");
    debugPrint(">> BACKGROUND COLOR ${provider.backgroundColor}");
    debugPrint(">> AUTO HIDE CONTENT ${provider.autoHideContent}");

    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushReplacementNamed(Routes.ROUTE_HOME);
    });
  }
}
