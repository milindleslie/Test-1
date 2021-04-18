import 'package:flutter/material.dart';
import 'package:test_app/custom_widgets/app_widgets.dart';
import 'package:test_app/helpers/size_config.dart';
import 'package:test_app/models/product.dart';
import 'package:test_app/resources/text_styles.dart';

class ProductWidget extends StatelessWidget {
  Product product;

  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          AppWidgets.cachedNetworkImage(url: product.imageURL, height: 100, width: 100),
          SizedBox(height: SizeConfig.safeBlockVertical),
          Text(product.name, style: AppTextStyles.blackFont10),
          SizedBox(height: SizeConfig.safeBlockVertical * 0.5),
          Text("Min ${product.off}% off", style: AppTextStyles.greenFont10),
          SizedBox(height: SizeConfig.safeBlockVertical),
        ],
      ),
      onTap: () {},
    );
  }
}
