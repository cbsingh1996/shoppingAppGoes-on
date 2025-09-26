import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/pages/account.dart';
import 'package:shopgoes/pages/deals.dart';
import 'package:shopgoes/pages/homescreen.dart';
import 'package:shopgoes/pages/mybag.dart';
import 'package:shopgoes/services/mybag_service.dart';
import 'package:shopgoes/style.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectIndex = 0;

  List items = [
    Icons.home,
    Icons.local_offer,
    Icons.shopping_bag,
    Icons.account_box_outlined,
  ];
  List pages = [HomescreenPage(), DealsPage(), MybagPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: true,

      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom == 0
          ? Container(
              height: context.pxHeight(70),
              padding: EdgeInsets.symmetric(
                horizontal: context.px(20),
                vertical: context.pxHeight(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  items.length,
                  (index) {
                    if (index == 2) {
                      // 🔹 MyBag icon with reactive badge
                      return ValueListenableBuilder<int>(
                        valueListenable: MybagService.bagCountNotifier,
                        builder: (context, count, _) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectIndex = index;
                                  });
                                },
                                child: Icon(
                                  items[index],
                                  size: context.px(26),
                                  color: selectIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              if (count > 0)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      '$count',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectIndex = index;
                          });
                        },
                        child: Icon(
                          items[index],
                          size: context.px(26),
                          color:
                              selectIndex == index ? Colors.black : Colors.grey,
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),

      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (selectIndex != 0) {
            setState(() {
              selectIndex = 0;
            });
            return;
          }

          final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Exit App'),
                  content: const Text('Do you want to close the app?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (shouldExit) {
            SystemNavigator.pop();
          }
        },
        child: pages[selectIndex],
      ),
    );
  }
}
