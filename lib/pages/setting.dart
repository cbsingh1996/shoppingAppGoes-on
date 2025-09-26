// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shopgoes/auth/auth_service.dart';
import 'package:shopgoes/auth/wapper.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/pages/contact.dart';
import 'package:shopgoes/pages/helppage.dart';
import 'package:shopgoes/style.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text('Settings', style:heading(context)),
        backgroundColor:bgcolor,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(context.px(16)),
        children: [
          Text('Profile Settings', style: subheading(context)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:  Icon(Icons.person,color: Colors.blueAccent,size: context.px(26),),
            title: Text('Edit Profile', style: style145(context)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:  Icon(Icons.lock,color: Colors.blueAccent,size: context.px(26),),
            title: Text('Change Password', style: style145(context)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),

          Text('App Preferences', style: subheading(context)),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0),
            value: _notifications,
            onChanged: (val) {
              setState(() => _notifications = val);
            },
            title: Text('Notifications', style:style145(context)),
            secondary:  Icon(Icons.notifications,color: Colors.blueAccent,size: context.px(26),),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0),
            value: _darkMode,
            onChanged: (val) {
              setState(() => _darkMode = val);
            },
            title: Text('Dark Mode', style:style145(context)),
            secondary:  Icon(Icons.dark_mode,color: Colors.blueAccent,size: context.px(26),),
          ),
          const Divider(),

          Text('Support', style: subheading(context)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:  Icon(Icons.help_outline,color: Colors.blueAccent,size: context.px(26),),
            title: Text('Help & FAQ', style:style145(context)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:  Icon(Icons.contact_support,color: Colors.blueAccent,size: context.px(26),),
            title: Text('Contact Support', style: style145(context)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactPage()),
              );
            },
          ),
          const Divider(),

          Text('Account Actions', style: subheading(context)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:  Icon(Icons.logout, color: Colors.red,size: context.px(26),),
            title: Text('Logout', style: style145(context, color: Colors.red)),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title:  Text("Logout",style: subheading(context,color: Colors.red),),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
              
              AuthService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WrapperClass()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
