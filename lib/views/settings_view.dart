import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/squared_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

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
  String _confirmationMessage = "";

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNumberController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patronNumber = _patronNumberController.text.trim();

    final UserSettings settings = UserSettings(
      address: address,
      email: email,
      patronNumber: patronNumber,
      receiveEmailNews: _recieveEmailNews,
    );

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
                value: _recieveEmailNews,
                onChanged: (bool value) {
                  setState(() {
                    _recieveEmailNews = value;
                  });
                },
              ),
            ]),
            const SizedBox(height: 16.0),
            Row(
              children: [
                SquaredButton(label: "Cancel", onPressed: () {}),
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
