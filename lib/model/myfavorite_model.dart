import 'package:hive/hive.dart';
part 'myfavorite_model.g.dart';
@HiveType(typeId: 2)
class Myfavorite extends HiveObject{


  @HiveField(0)
  int productId;

  Myfavorite({
    required this.productId
  });
}