import 'package:flutter/material.dart';
import 'package:shopgoes/services/sharedservice.dart';
import 'package:shopgoes/style.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int totalPoints = 0; // ✅ default value

  @override
  void initState() {
    super.initState();
    SharedService.init();
    calculate();
  }

  void calculate() {
    final points = SharedService.getInt('points') ; // null safety
    setState(() {
      totalPoints = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text("My Rewards", style: heading(context)),
        actions: [
          TextButton(
            onPressed: () async {
              await SharedService.setInt('points', 0);
              calculate(); // ✅ refresh
            },
            child: Text(
              'Clear',
              style: style145(context, color: Colors.red),
            ),
          ),
        ],
        backgroundColor: bgcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Current Points
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: btcolor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Your Total Points",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$totalPoints",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
