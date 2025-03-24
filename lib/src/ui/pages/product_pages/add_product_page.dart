import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/helpers/app_simple_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';

class AddProductPage extends StatefulWidget {
  final AppModel state;
  final AppColors theme;
  final void Function() onBackPressed;

  const AddProductPage({super.key, required this.state, required this.theme, required this.onBackPressed});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  AppModel get state => widget.state;

  AppColors get theme => widget.theme;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController percentController = TextEditingController();
  final TextEditingController resultPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSimpleButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: widget.onBackPressed,
              ),
              Text(
                AppLocales.addProductAppbarTitle.tr(),
                style: TextStyle(fontSize: 32, fontFamily: boldFamily),
              ),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText.$18Bold(AppLocales.productName.tr()),
                        8.h,
                        AppTextField(
                          title: AppLocales.addProductNameHint.tr(),
                          controller: nameController,
                          theme: theme,
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        24.h,
                        AppText.$18Bold(AppLocales.addProductPrice.tr()),
                        8.h,
                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: AppTextField(
                                title: AppLocales.oldPriceHint.tr(),
                                controller: priceController,
                                theme: theme,
                                prefixIcon: Icon(Icons.attach_money),
                                onChanged: (char) {
                                  if (num.tryParse(percentController.text.trim()) != null && num.tryParse(char) != null) {
                                    final percent = num.parse(percentController.text.trim());
                                    final price = num.parse(char.trim());
                                    resultPriceController.text = (price * (1 + (percent / 100))).price;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: AppTextField(
                                title: AppLocales.pricePercentHint.tr(),
                                controller: percentController,
                                theme: theme,
                                prefixIcon: Icon(Icons.percent),
                                onChanged: (char) {
                                  if (num.tryParse(priceController.text.trim()) != null && num.tryParse(char) != null) {
                                    final price = num.parse(priceController.text.trim());
                                    final percent = num.parse(char.trim());
                                    resultPriceController.text = (price * (1 + (percent / 100))).price;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: AppTextField(
                                title: AppLocales.addProductPrice.tr(),
                                controller: resultPriceController,
                                theme: theme,
                                prefixIcon: Icon(Icons.calculate_outlined),
                                onChanged: (char) {
                                  if (num.tryParse(priceController.text.trim()) != null && num.tryParse(char) != null) {
                                    final price = num.parse(priceController.text.trim());
                                    final resultPrice = num.parse(char.trim());
                                    percentController.text = (((resultPrice - price) * 100) / price).price;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: 24.lr,
                  height: double.infinity,
                  width: 1,
                  color: theme.secondaryTextColor,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
