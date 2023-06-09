import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/pages/cart/cart_page.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/bigg_text.dart';
import '../../controllers/cart_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimentions.dart';
import '../../widgets/expandable_text_widget.dart';
import 'package:get/get.dart';

class RecommendedFoodDetails extends StatelessWidget {
  final int pageId;
  const RecommendedFoodDetails({Key? key, required this.pageId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<RecommendedProductController>().recommendedProductList[pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 70,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: const AppIcon(
                        icon: Icons.clear,
                      ),
                    ),
                    // const AppIcon(
                    //   icon: Icons.shopping_cart_outlined,
                    // ),
                    GetBuilder<PopularProductController>(
                        builder: (popularController) {
                      return Stack(
                        children: [
                          const Positioned(
                            right: 3,
                            top: 3,
                            child: AppIcon(
                              icon: Icons.shopping_bag_outlined,
                            ),
                          ),
                          Get.find<PopularProductController>().totalItems >= 1
                              ? BigText(
                                  text: Get.find<PopularProductController>()
                                      .totalItems
                                      .toString(),
                                  size: 12,
                                  color: Colors.white)
                              : Container(),
                          Get.find<PopularProductController>().totalItems >= 1
                              ? GestureDetector(
                                  onTap: () {
                                    Get.to(const CartPage());
                                  },
                                  child: AppIcon(
                                    size: 20,
                                    icon: Icons.circle,
                                    iconColor: Colors.transparent,
                                    backgroundColor: AppColors.mainColor,
                                  ),
                                )
                              : Container()
                        ],
                      );
                    })
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            Dimensions.radius20,
                          ),
                          topLeft: Radius.circular(
                            Dimensions.radius20,
                          ),
                        )),
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    child: Center(
                      child: BigText(
                        text: product.name!,
                        size: Dimensions.fontSize26,
                      ),
                    ),
                    width: double.maxFinite,
                  ),
                ),
                pinned: true,
                backgroundColor: AppColors.yellowColor,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Image.network(
                    AppConstants.BASE_URL +
                        AppConstants.UPLOAD_URL +
                        product.img!,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    child: ExpandableTextWidget(
                      text: product.description!,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          GetBuilder<PopularProductController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20 * 2.5,
                right: Dimensions.width20 * 2.5,
                top: Dimensions.height10,
                bottom: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(true);
                    },
                    child: AppIcon(
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.icon24,
                      iconColor: Colors.white,
                      icon: Icons.add,
                    ),
                  ),
                  BigText(
                    text: '\$${product.price!} X  ${controller.inCartItems} ',
                    color: AppColors.mainBlackColor,
                    size: Dimensions.fontSize26,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(false);
                    },
                    child: AppIcon(
                      iconSize: Dimensions.icon24,
                      backgroundColor: AppColors.mainColor,
                      iconColor: Colors.white,
                      icon: Icons.remove,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Dimensions.bottomBarHeight,
              padding: EdgeInsets.only(
                top: Dimensions.height30,
                bottom: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    Dimensions.radius20 * 2,
                  ),
                  topLeft: Radius.circular(
                    Dimensions.radius20 * 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.height20,
                        bottom: Dimensions.height20,
                        left: Dimensions.height20,
                        right: Dimensions.height20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.mainColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.addItem(product);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: Dimensions.height20,
                        bottom: Dimensions.height20,
                        left: Dimensions.height20,
                        right: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: AppColors.mainColor,
                      ),
                      child: BigText(
                        text: '\$ ${product.price!} | Add to cart',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
