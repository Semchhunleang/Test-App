import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/product_view_model.dart';
// import 'package:umgkh_mobile/views/pages/e-catalog/product/index.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/sub_category/index.dart';

class ItemWebsiteCategoryWidget extends StatelessWidget {
  final WebsiteCategory data;
  const ItemWebsiteCategoryWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          await Provider.of<ProductPageViewModel>(context, listen: false)
              .setCategId(data.id);
          if (context.mounted) {
            await Provider.of<ProductPageViewModel>(context, listen: false)
                .setSelectedCategory(data);
          }
          if (context.mounted) {
            await navPush(
              context,
              SubCategoryPage(
                children: data.children!,
              ),
            );
            // if (data.name.toLowerCase() == "used") {
            //   await navPush(
            //     context,
            //     ProductPage(
            //       categoryType: data.name,
            //       children: const [],
            //     ),
            //   );
            // } else {
            //   await navPush(
            //     context,
            //     SubCategoryPage(
            //       children: data.children!,
            //     ),
            //   );
            // }
          }
          // }
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius / 2),
          ),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: Padding(
            padding: EdgeInsets.all(mainPadding * 1.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: data.id != 0
                      ? Image.network(
                          Constants.getWebCatPicture(data.id),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/icons/e-catalog/all.png',
                          fit: BoxFit.cover,
                        ),
                ),
                Center(
                  child: Text(
                    data.name,
                    style: primary15Bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
