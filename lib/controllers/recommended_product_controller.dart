import 'package:get/get.dart';
import '../data/repository/recommended_product_repo.dart';
import '../models/product_model.dart';

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo recommendedProductRepo;
  RecommendedProductController({required this.recommendedProductRepo});
  List<ProductModel> _recommendedProductList = [];
  List<ProductModel> get recommendedProductList => _recommendedProductList;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  Future<void> getRecommendedProductList() async {
    Response response =
        await recommendedProductRepo.getRecommendedProductList();

    try {
      if (response.statusCode == 200) {
        print('got product recommended');
        _recommendedProductList = [];

        _recommendedProductList
            .addAll(Product.fromJson(response.body).products);

        _isLoaded = true;
        update();
      } else {
        print(response.body);
        print('no network recommended');
      }
    } catch (e) {
      print('Error ocurred and the error is' + e.toString());
    }
  }
}
