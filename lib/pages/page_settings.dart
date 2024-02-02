import 'package:flutter/material.dart';
import 'package:metro/classes/constants.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences prefs;
  late MetroProvider provider;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      prefs = await SharedPreferences.getInstance();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MetroProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(ThemeConstants.borderRadius),
            topRight: Radius.circular(ThemeConstants.borderRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SETTINGS", style: Theme.of(context).textTheme.labelLarge),
                  IconButton(
                    onPressed: _close,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
              child: Column(
                children: [
                  _buildContent(),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: _close,
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// AUTO HIDE CONTENT
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.borderRadius)),
          onTap: () {
            _onAutoHideChanged(!provider.autoHideContent);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Auto hide contents",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Switch(value: provider.autoHideContent, onChanged: _onAutoHideChanged),
            ],
          ),
        ),
        const Divider(
          color: Colors.white12,
          height: 20,
        ),

        /// FIXED TICK PERIOD
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.borderRadius)),
          onTap: () {
            _onFixedPeriodChanged(!provider.fixedTickPeriod);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Fixed tick period",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Switch(value: provider.fixedTickPeriod, onChanged: _onFixedPeriodChanged)
            ],
          ),
        ),
        const Divider(
          color: Colors.white12,
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Background color",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            for (var item in Constants.BACKGROUND_COLORS) ...[
              Opacity(
                opacity: provider.backgroundColor == item['key'] ? 1 : 0.5,
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: provider.backgroundColor == item['key'] ? Colors.white : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      _onColorChanged(item['key']);
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _onAutoHideChanged(bool? value) {
    prefs.setBool(Constants.PREFS_AUTO_HIDE_CONTENT, value ?? false);
    provider.autoHideContent = value != null && value == true;
  }

  void _onFixedPeriodChanged(bool? value) {
    prefs.setBool(Constants.PREFS_FIXED_TICK_PERIOD, value ?? false);
    provider.fixedTickPeriod = value != null && value == true;
  }

  void _onColorChanged(String value) {
    prefs.setString(Constants.PREFS_BACKGROUND_COLOR, value);
    provider.backgroundColor = value;
  }

  void _close() {
    Navigator.of(context).pop();
  }
}
