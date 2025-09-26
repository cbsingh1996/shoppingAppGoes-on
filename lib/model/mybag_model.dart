import 'package:hive/hive.dart';
part 'mybag_model.g.dart';
@HiveType(typeId: 3)
class Mybag extends HiveObject{



  @HiveField(0)
  int productId;

  Mybag({
  
    required this.productId
  });
}