import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
// import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/squared_button.dart';

const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefPatronNumber = 'user_patron_number';
const String prefReceiveEmailNews = 'user_receive_email_news';
const String prefThemeMode = 'user_theme_mode';

class SettingsView extends StatefulWidget {
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  const SettingsView({
    super.key,
    this.onThemeModeChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _SettingsViewState();
  }
}

class _SettingsViewState extends State<SettingsView> {
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _patronNumberController;
  bool _recieveEmailNews = false;
  bool _darkMode = true;
  String _confirmationMessage = "";

  Future<void> _loadSettings() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? savedAddress = await prefs.getString(prefAddress);
    final String? savedEmail = await prefs.getString(prefEmail);
    final String? savedPatronNumber = await prefs.getString(prefPatronNumber);
    final bool? savedReceiveEmailNews =
        await prefs.getBool(prefReceiveEmailNews);
    final String? savedThemeMode = await prefs.getString(prefThemeMode);

    String address = "";
    if (savedAddress != null) {
      address = savedAddress;
    }
    String email = "";
    if (savedEmail != null) {
      email = savedEmail;
    }
    String patronNumber = "";
    if (savedPatronNumber != null) {
      patronNumber = savedPatronNumber;
    }
    bool receiveEmailNews = false;
    if (savedReceiveEmailNews != null) {
      receiveEmailNews = savedReceiveEmailNews;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _addressController.text = address;
      _emailController.text = email;
      _patronNumberController.text = patronNumber;
      _recieveEmailNews = receiveEmailNews;
      _darkMode = savedThemeMode != 'light';
    });
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNumberController = TextEditingController();

    _loadSettings();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patronNumber = _patronNumberController.text.trim();

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(prefAddress, address);
    await prefs.setString(prefEmail, email);
    await prefs.setString(prefPatronNumber, patronNumber);
    await prefs.setBool(prefReceiveEmailNews, _recieveEmailNews);
    await prefs.setString(
      prefThemeMode,
      _darkMode ? 'dark' : 'light',
    );
    widget.onThemeModeChanged?.call(
      _darkMode ? ThemeMode.dark : ThemeMode.light,
    );

    // final UserSettings settings = UserSettings(
    //   address: address,
    //   email: email,
    //   patronNumber: patronNumber,
    //   receiveEmailNews: _recieveEmailNews,
    // );

    if (!mounted) {
      return;
    }

    setState(() {
      _confirmationMessage = "Settings saved successfully";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Settings",
              style: cinemaHeaderStyle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Address",
              style: cinemaSubHeaderStyle,
            ),
            TextField(
              controller: _addressController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your address",
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Email",
              style: cinemaSubHeaderStyle,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Patron Number",
              style: cinemaSubHeaderStyle,
            ),
            TextField(
              controller: _patronNumberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your patron number",
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Preferences",
              style: cinemaSubHeaderStyle,
            ),
            Row(children: [
              const Expanded(
                  child: Text(
                "Receive news by email",
              )),
              Switch(
                key: const Key('receive_news_switch'),
                value: _recieveEmailNews,
                onChanged: (bool value) {
                  setState(() {
                    _recieveEmailNews = value;
                  });
                },
              ),
            ]),
            Row(children: [
              const Expanded(
                child: Text("Dark mode"),
              ),
              Switch(
                key: const Key('theme_mode_switch'),
                value: _darkMode,
                onChanged: (bool value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
            ]),
            const SizedBox(height: 16.0),
            Row(
              children: [
                SquaredButton(
                    label: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                const SizedBox(width: 16.0),
                SquaredButton(
                  label: "Save settings",
                  onPressed: _saveSettings,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_confirmationMessage.isNotEmpty)
              Text(
                _confirmationMessage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
