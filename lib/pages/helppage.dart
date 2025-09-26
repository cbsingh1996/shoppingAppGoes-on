import 'package:flutter/material.dart';
import 'package:shopgoes/style.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  final List<Map<String, String>> faqList = const [
    {
      "question": "How can I track my order?",
      "answer":
          "Go to 'My Orders' in your profile and select the order to see tracking details."
    },
    {
      "question": "What payment methods are available?",
      "answer":
          "We support UPI, Debit/Credit Card, Net Banking, and Cash on Delivery."
    },
    {
      "question": "How do I return a product?",
      "answer":
          "Go to 'My Orders', select the product, and choose 'Return/Replace' option within 7 days."
    },
    {
      "question": "How to contact support?",
      "answer":
          "Go to Account → Contact Support or email us at support@goesapp.com."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: Text("Help & FAQ", style: heading(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.help_outline, color: Colors.blue),
              title: Text(
                item["question"] ?? "",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    item["answer"] ?? "",
                    style: const TextStyle(color: Colors.black87),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
