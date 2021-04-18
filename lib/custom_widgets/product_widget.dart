import 'package:flutter/material.dart';
import 'package:test_app/custom_widgets/app_widgets.dart';
import 'package:test_app/helpers/size_config.dart';
import 'package:test_app/models/product.dart';
import 'package:test_app/resources/text_styles.dart';

class ProductWidget extends StatelessWidget {
  Product product;
  int index;

  ProductWidget({@required this.product, @required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                ),
                left: BorderSide(
                  color: index.isOdd ? Colors.black12 : Colors.transparent,
                ))),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            AppWidgets.cachedNetworkImage(url: product.imageURL, height: 100, width: 100),
            SizedBox(height: SizeConfig.safeBlockVertical),
            Text(product.name, style: AppTextStyles.blackFont10),
            SizedBox(height: SizeConfig.safeBlockVertical * 0.5),
            Text("Min ${product.off}% off", style: AppTextStyles.greenFont10),
            SizedBox(height: SizeConfig.safeBlockVertical),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
