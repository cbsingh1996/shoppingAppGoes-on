import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/history_model.dart';
import 'package:shopgoes/services/history_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/custom.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<OrderHistory>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Order History",style: heading(context),),
        actions: [
          TextButton(
            onPressed: () async {
              await OrderService.clearOrders();
              setState(() {
                _ordersFuture = OrderService.getAllOrders();
              });
            },
            child: Text('clear', style: style145(context)),
          ),
        ],
      ),
      body: FutureBuilder<List<OrderHistory>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          // Reverse orders (last order at top)
          final orders = snapshot.data!.reversed.toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🆔 Order ID + Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${order.orderId}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 📦 Products
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: order.products.map((p) {
                          return Row(
                            children: [
                              // Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomImageWidget(image: p.images[0]),
                              ),
                              const SizedBox(width: 10),
                              // Name + Price
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (p.offer == 0) ...{
                                      Text(
                                        '₹ ${p.price}',
                                        style: planetxt(
                                          context,
                                        ).copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    } else ...{
                                      Row(
                                        children: [
                                          Text(
                                            '₹ ${p.price.toStringAsFixed(2)}',
                                            style:
                                                planetxt(
                                                  context,
                                                  color: Colors.grey,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                          ),
                                          context.sbWidth(8),
                                          Text(
                                            '₹ ${(p.price * (100 - p.offer) / 100).toStringAsFixed(2)}',
                                            style: planetxt(context).copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    },
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),

                      const Divider(height: 20),

                      // 💰 Total + Payment Mode
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: ₹${order.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Paid via ${order.paymentMode}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 🚚 Status
                      Align(
                        alignment: Alignment.centerRight,
                        child: Chip(
                          label: Text(
                            order.status,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: order.status == "Delivered"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
