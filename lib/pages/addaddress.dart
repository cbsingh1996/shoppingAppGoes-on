// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/address_model.dart';
import 'package:shopgoes/services/address_service.dart';
import 'package:shopgoes/services/sharedservice.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/custombt.dart';

class AddAddressPage extends StatefulWidget {
  final Address? address; 
  bool isUpdate;

  AddAddressPage({super.key, this.isUpdate = false, this.address});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _houseController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _townController = TextEditingController();
  final _townFocusNode = FocusNode();

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  bool _isDefault = false;

  final Map<String, Map<String, List<String>>> locationData = {
    "India": {
      "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi",'Noida','Ghazipur',"Kanpur","Hardoi","Jhasi","Chandauli","Jaunpur","Mau","Azamgarh",'Bhadoi','Ayodhya','Barabanki','Gonda' ],
      "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
      "Delhi": ["New Delhi", "Dwarka", "Rohini"],
    },
    "Australia": {
      "New South Wales": ["Sydney", "Newcastle"],
      "Victoria": ["Melbourne", "Geelong"],
    },
    "China": {
      "Beijing": ["Haidian", "Chaoyang"],
      "Shanghai": ["Pudong", "Minhang"],
    },
  };

@override
void initState() {
  super.initState();
  _initializeForm();
}

void _initializeForm() async {
  if (widget.address != null) {
    _fullNameController.text = widget.address!.fullName;
    _mobileController.text = widget.address!.mobileNumber;
    _houseController.text = widget.address!.houseNumber;
    _landmarkController.text = widget.address!.landmark;
    _pincodeController.text = widget.address!.pincode.toString();
    _townController.text = widget.address!.town;
    _selectedCountry = widget.address!.country;
    _selectedState = widget.address!.state;
    _selectedDistrict = widget.address!.city;

    final defaultId = SharedService.getInt("default_address");

    setState(() {
      _isDefault = defaultId == widget.address!.id;
    });
  }
}

void _showBottomSheet(List<String> items, String title, Function(String) onSelect) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Important: allows full height modal and better scrolling
    builder: (context) => SafeArea(
      child: SizedBox(
        height: context.pxHeight(500), // Fixed height for bottom sheet
        child: Column(
          children: [
            ListTile(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item,),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  void _selectCountry() {
    _townFocusNode.unfocus();
    // FocusScope.of(context).unfocus();
    // FocusScope.of(context).requestFocus(FocusNode());

    _showBottomSheet(locationData.keys.toList(), "Select Country", (country) {
      setState(() {
        _selectedCountry = country;
        _selectedState = null;
        _selectedDistrict = null;
      });
  
    });
      FocusScope.of(context).unfocus();
  }

  void _selectState() {
    if (_selectedCountry == null) return;
    final states = locationData[_selectedCountry]!.keys.toList();
    _showBottomSheet(states, "Select State", (state) {
      setState(() {
        _selectedState = state;
        _selectedDistrict = null;
      });
    FocusScope.of(context).unfocus();
    });
      FocusScope.of(context).unfocus();
  }

  void _selectDistrict() {
    if (_selectedCountry == null || _selectedState == null) return;
    final districts = locationData[_selectedCountry]![_selectedState]!;
    _showBottomSheet(districts, "Select District", (district) {
      setState(() {
        _selectedDistrict = district;
      });
      FocusScope.of(context).unfocus();
    });
      FocusScope.of(context).unfocus();

  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate() &&
        _selectedCountry != null &&
        _selectedState != null &&
        _selectedDistrict != null) {

      Address newAddress = Address(
        id: widget.isUpdate ? widget.address!.id : AddressService.getAddresses().isEmpty
            ? 1
            : AddressService.getAddresses().map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1,
        fullName: _fullNameController.text,
        mobileNumber: _mobileController.text,
        houseNumber: _houseController.text,
        landmark: _landmarkController.text,
        pincode: int.parse(_pincodeController.text),
        town: _townController.text,
        city: _selectedDistrict!,
        state: _selectedState!,
        country: _selectedCountry!,
      );

      if (widget.isUpdate) {
        await AddressService.updateAddress(newAddress);  // Update existing
      } else {
        await AddressService.addAddress(newAddress);     // Add new
      }

      if (_isDefault) {
        await SharedService.setInt("default_address", newAddress.id);
        await SharedService.setInt("default_tag", newAddress.id );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.isUpdate ? "✅ Address updated successfully" : "✅ Address added successfully")),
        );
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please complete all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.isUpdate ? "Update Address" : "Add Address")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUnfocus,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    // focusNode: FocusNode(),
                    decoration: const InputDecoration(labelText: "Full Name"),
                    validator: (val) => val!.isEmpty ? "Full name is required" : null,
                  ),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(labelText: "Mobile Number"),
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.length != 10 ? "Enter valid 10 digit number" : null,
                  ),
                  TextFormField(
                    controller: _houseController,
                    validator: (value) => value!.isEmpty ? "House number is required" : null,
                    decoration: const InputDecoration(labelText: "House Number"),
                  ),
                  TextFormField(
                    controller: _landmarkController,
                    decoration: const InputDecoration(labelText: "Landmark"),
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    // focusNode: FocusNode(),
                    decoration: const InputDecoration(labelText: "Pincode"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (val) => val!.length != 6 ? "Pincode must be 6 digits" : null,
                  ),
                  TextFormField(
                    focusNode: _townFocusNode,
                    controller: _townController,
                    decoration: const InputDecoration(labelText: "Town"),
                  ),
                  ListTile(
                    title: const Text("Country"),
                    subtitle: Text(_selectedCountry ?? "Select Country",style:style167(context)),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: _selectCountry,
                  ),
                  ListTile(
                    title: const Text("State"),
                    subtitle: Text(_selectedState ?? "Select State",style: style167(context)),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: _selectState,
                  ),
                  ListTile(
                    title: const Text("District"),
                    subtitle: Text(_selectedDistrict ?? "Select District",style: style167(context)),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: _selectDistrict,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDefault = !_isDefault;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          height: context.pxHeight(20),
                          width: context.px(20),
                          decoration: _isDefault
                              ? BoxDecoration(shape: BoxShape.circle, color: btcolor)
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color:btcolor),
                                  color: Colors.white),
                        ),
                        context.sbWidth(10),
                        const Text("Set as Default Address"),
                      ],
                    ),
                  ),
                  SizedBox(height: context.pxHeight(100)),
                  Custombt(ontap:  _saveAddress, text: widget.isUpdate ? 'Update Address' : 'Save Address',)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
