import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

import '../data/repository/popular_product_repo.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'cart_controller.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});
  List<ProductModel> _popularProductList = [];
  List<ProductModel> get popularProductList => _popularProductList;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  int _quantity = 0;
  int get quantity => _quantity;
  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;
  late CartController _cart;
  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();

    try {
      if (response.statusCode == 200) {
        print('got product');
        _popularProductList = [];

        _popularProductList.addAll(Product.fromJson(response.body).products);

        _isLoaded = true;
        update();
      } else {
        print(response.body);
        print('no network');
      }
    } catch (e) {}
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  int checkQuantity(int quantity) {
    if (_inCartItems + quantity < 0) {
      Get.snackbar(
        'Item Count',
        'You cant reduce more',
        colorText: Colors.white,
        backgroundColor: AppColors.mainColor,
      );
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    } else if (_inCartItems + quantity > 20) {
      Get.snackbar(
        'Item Count',
        'You cant increase more',
        colorText: Colors.white,
        backgroundColor: AppColors.mainColor,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductModel product, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    var exist = false;
    exist = _cart.existInCart(product);
    //if exist
    ///get from storage
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }
  }

  void addItem(ProductModel product) {
    //  if (quantity > 0) {
    _cart.addItem(product, _quantity);
    _quantity = 0;
    _inCartItems = _cart.getQuantity(product);
    // } else {
    // Get.snackbar(
    //   'Item Count',
    //   'You should add at least one item',
    //   colorText: Colors.white,
    //   backgroundColor: AppColors.mainColor,
    // );
    // }
    update();
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }
}
