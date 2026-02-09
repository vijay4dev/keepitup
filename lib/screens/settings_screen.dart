import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepitup/utils/Appcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool ocrEnabled = true;
  bool autoScan = true;
  bool notifications = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _loadStorage();
  }
  String storageText = "Calculating...";

  Future<void> _loadStorage() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    storageText = prefs.getString('storage_usage') ?? "0 MB";
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.app_bg_color,

      /// 🔙 Header
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: widget.onBack,
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xff1D1D1F),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          _section(
            "DOCUMENT MANAGEMENT",
            [
              _toggleTile(
                icon: Icons.description,
                color: Colors.blue,
                title: "Auto-scan new files",
                value: autoScan,
                onChanged: (v) => setState(() => autoScan = v),
              ),
              _toggleTile(
                icon: Icons.notifications,
                color: Colors.purple,
                title: "Notifications",
                value: notifications,
                onChanged: (v) => setState(() => notifications = v),
              ),
            ],
          ),
          _section(
            "STORAGE & PRIVACY",
            [
              _infoTile(
                icon: Icons.storage,
                color: Colors.cyan,
                title: "Storage used",
                value: storageText,
              ),
              _navTile(
                icon: Icons.shield,
                color: Colors.red,
                title: "Privacy & Security",
              ),
            ],
          ),

          _section(
            "ABOUT",
            [
              _infoTile(
                icon: Icons.info,
                color: Colors.grey,
                title: "Version",
                value: "1.0.0",
              ),
              _navTile(
                icon: Icons.help_outline,
                color: Colors.grey,
                title: "Help & Support",
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// 🔹 Footer
          Column(
            children: const [
              Text(
                "Keep It – Smart Document Manager",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                "All processing happens on your device",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                "Your privacy is our priority",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== UI HELPERS =====================

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required Color color,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: _icon(icon, color),
      title: Text(title),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required Color color,
    required String title,
  }) {
    return ListTile(
      leading: _icon(icon, color),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _infoNavTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: _icon(icon, color),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: _icon(icon, color),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _icon(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color),
    );
  }
}
