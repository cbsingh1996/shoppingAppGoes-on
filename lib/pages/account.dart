import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/pages/coupon.dart';
import 'package:shopgoes/pages/rewards.dart';
import 'package:shopgoes/pages/setting.dart';
import 'package:shopgoes/pages/address.dart';
import 'package:shopgoes/pages/history.dart';
import 'package:shopgoes/pages/payment.dart';
import 'package:shopgoes/style.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  /// Pick profile image from Camera or Gallery
  Future<void> _showImageSourceActionSheet() async {
    final pickedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );

    if (pickedSource != null) {
      final pickedFile = await _picker.pickImage(source: pickedSource);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    }
  }

  /// Pages list
  final List<Map<String, dynamic>> _menuItems = [
    {"title": "Address", "page": const AddressPage(), "icon": Icons.home},
    {"title":"Coupon","page":const CouponPage(),"icon":Icons.card_giftcard},
    {"title": "Payment", "page": const PaymentPage(), "icon": Icons.payment},
    {"title": "Order History", "page": const HistoryPage(), "icon": Icons.history},
    {"title": "Rewards", "page": const RewardsPage(), "icon": Icons.attach_money},
    {"title": "Settings", "page": const SettingPage(), "icon": Icons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
      backgroundColor: bgcolor,
        title: Text('Account', style:heading(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(context.px(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            context.sbHeight(30),
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return ListTile(
                    leading: Icon(item["icon"], color: Colors.blueAccent),
                    title: Text(item["title"], style: style145(context)),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: context.px(16),
                      color: Colors.black.withAlpha(128),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item["page"]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profile Section widget
  Widget _buildProfileSection(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: context.pxHeight(70),
          width: context.px(80),
          child: Stack(
            children: [
              Container(
                height: context.pxHeight(70),
                width: context.px(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.antiAlias,
                child: _profileImage != null
                    ? Image.file(_profileImage!, fit: BoxFit.cover)
                    : const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourceActionSheet,
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.camera_alt_outlined,
                        size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.sbWidth(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user?.displayName ?? "Guest User",
              style: style145(context),
            ),
            Text(
              user?.email ?? "",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
