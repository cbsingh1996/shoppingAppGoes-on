import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/address_model.dart';
import 'package:shopgoes/pages/addaddress.dart';
import 'package:shopgoes/services/sharedservice.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/custombt.dart';
import 'package:hive/hive.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late Box<Address> addressbox;
  int? selectedIndex;
  int? val;
  int? defaulttag;
  int? addressId;

  @override
  void initState() {
    super.initState();
    addressbox = Hive.box<Address>('addresses');
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _setselect();
    await _defaulttag();
    setState(() {});
  }

  Future<void> _defaulttag() async {
    defaulttag = SharedService.getInt("default_tag");
  }

  Future<void> _setselect() async {
    val = SharedService.getInt("default_address");
    if (val != null) {
      final index = addressbox.values.toList().indexWhere(
        (addr) => addr.id == val,
      );
      selectedIndex = index >= 0 ? index : null;
    } else {
      selectedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        automaticallyImplyLeading: false,
        title: Text('Select Address', style: heading(context)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.px(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAddressPage()),
                ).then((value) async {
                  if (value == true) {
                    await _setselect();
                    await _defaulttag();
                    setState(() {});
                  }
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Add new delivery address',
                style: planetxt(context, color: Colors.blue),
              ),
            ),

           
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.pxHeight(10),
              ),
              child: Text('All Addresses', style: subheading(context)),
            ),
            Expanded(
              child: addressbox.isEmpty
                  ? const Center(child: Text('No addresses available.'))
                  : ListView.builder(
                    padding: EdgeInsets.all(0),
                      itemCount: addressbox.length,
                      itemBuilder: (context, index) {
                        final address = addressbox.getAt(index)!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  addressId = address.id;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.pxHeight(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Radio<int>(
                                      value: index,
                                      // ignore: deprecated_member_use
                                      groupValue: selectedIndex,
                                      // ignore: deprecated_member_use
                                      onChanged: (value) {
                                        setState(() {
                                          selectedIndex = value;
                                          addressId = address.id;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${address.fullName}, ${address.houseNumber}, ${address.landmark}, ${address.town}, ${address.city}, ${address.state} - ${address.pincode}, Mobile: ${address.mobileNumber}",
                                        style: planetxt(
                                          context,
                                          color: Colors.blue,
                                        ),

                                        maxLines: 3,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        if (address.id == defaulttag)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: context.px(10),
                                              vertical: context.pxHeight(4),
                                            ),
                                            decoration: BoxDecoration(
                                              color: btcolor,
                                              borderRadius: context.radius(12),
                                            ),
                                            child: Text(
                                              'Default',
                                              style: planetxt(
                                                context,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        context.sbHeight(8),

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddAddressPage(
                                                      address: address,
                                                      isUpdate: true,
                                                    ),
                                              ),
                                            ).then((value) async {
                                              if (value == true) {
                                                await _setselect();
                                                await _defaulttag();
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: btcolor,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                              size: context.px(20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (selectedIndex == index)
                              Custombt(
                                text: 'Deliver to this Address',
                                ontap: () async {
                                  Navigator.pop(context, true);
                                  await SharedService.setInt(
                                    "default_address",
                                    addressId!,
                                  );
                                },
                              ),
                            if (index != addressbox.length - 1) const Divider(),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
