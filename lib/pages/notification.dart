import 'package:flutter/material.dart';
import 'package:shopgoes/style.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Dummy notifications list
  final List<Map<String, String>> notifications = [
    {
      "title": "Order Shipped",
      "message": "Your order #12345 has been shipped.",
      "time": "2 min ago"
    },
    {
      "title": "New Offer",
      "message": "Get 20% off on electronics today only!",
      "time": "1 hr ago"
    },
    {
      "title": "Payment Successful",
      "message": "Your payment for order #12345 is successful.",
      "time": "Yesterday"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification", style: heading(context)),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No Notifications Yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.notifications, color: Colors.blue),
                  ),
                  title: Text(
                    item["title"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item["message"] ?? ""),
                  trailing: Text(
                    item["time"] ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                  },
                );
              },
            ),
    );
  }
}
