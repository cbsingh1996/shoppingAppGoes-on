import 'package:shopgoes/model/address_model.dart';
import 'package:hive/hive.dart';

class AddressService {
  static const String addressBoxName = 'addresses';

  static Future<void> init() async {
    await Hive.openBox<Address>(addressBoxName);
  }
  static Box<Address> get _addressBox => Hive.box<Address>(addressBoxName);

 static Future<void> seedAddresses({bool reset = false}) async {
    if (reset) await _addressBox.clear();
    if (_addressBox.isEmpty) {
      for (var addr in sampleAddresses) {
        await _addressBox.add(addr);
      }
    }
  }

  static List<Address> getAddresses() => _addressBox.values.toList();

  static Future<void> addAddress(Address address) async {
    await _addressBox.add(address);
  }

static Address? getAddressById(int id) {
  try {
    final box = _addressBox;
    for (var addr in box.values) {
      if (addr.id == id) {
        return addr;
      }
    }
    return null;  
  } catch (e) {
    return null;
  }
}


static Future<void> updateAddress(Address address) async {
  final box = Hive.box<Address>('addresses');
  final key = box.keys.firstWhere(
    (k) => box.get(k)!.id == address.id,
    orElse: () => null,
  );

  if (key != null) {
    await box.put(key, address);
  }
}
  static Future<void> deleteAddress(int id) async {
    final box = Hive.box<Address>('addresses');
    final key = box.keys.firstWhere(
      (k) => box.get(k)!.id == id,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    }
  }


}


final List<Address> sampleAddresses = [
  
];

