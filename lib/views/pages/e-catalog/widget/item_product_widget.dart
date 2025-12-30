import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/product/detail.dart';

class ItemProductWidget extends StatelessWidget {
  final Product data;
  final String categoryType;
  const ItemProductWidget(
      {super.key, required this.data, this.categoryType = ""});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          FocusScope.of(context).requestFocus(
            FocusNode(),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProductPage(
                url: Constants.getPDF(data.id, "product-catalog"),
                maintenanceUrl:
                    Constants.getPDF(data.id, "maintenance-schedule"),
                data: data,
                categoryType: categoryType,
              ),
            ),
          );
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
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Stack(
                    children: [
                      // Image container with a fallback to a white background
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors
                                .white, // White background when the image fails
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      // Image with error handling
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Image.network(
                            Constants.getProductPicture(data.id),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors
                                    .white, // Display a white blank container if the image fails to load
                              );
                            },
                          ),
                        ),
                      ),
                      // Border in front of the image
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              color: theme().primaryColor,
                              width: 3.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    data.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: primary13Bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
