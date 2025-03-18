import 'dart:developer';

import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/core/model/category_model/category_model.dart';
import 'package:biznex/src/providers/category_provider.dart';
import 'package:biznex/src/ui/pages/category_pages/category_page.dart';
import 'package:biznex/src/ui/screens/category_screens/add_category_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_custom_padding.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_simple_button.dart';

import '../../../../biznex.dart';

class CategorySubcategories extends AppStatelessWidget {
  final Category category;

  const CategorySubcategories({super.key, required this.category});

  @override
  Widget builder(context, theme, ref, state) {
    return state.whenProviderData(
      provider: allCategoryProvider,
      builder: (categories) {
        categories as List<Category>;
        log(categories.toString());
        final categorySubcategories = categories.where((ctg) {
          return ctg.parentId == category.id;
        }).toList();
        return Column(
          children: [
            if (categorySubcategories.isEmpty) Expanded(child: AppEmptyWidget()),
            Expanded(
              child: ListView.builder(
                itemCount: (categorySubcategories).length,
                padding: Dis.only(lr: 24),
                itemBuilder: (context, index) {
                  final subcategory = (categorySubcategories)[index];
                  return Container(
                    padding: Dis.only(left: 12, right: 12, tb: 8),
                    margin: Dis.only(tb: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: theme.accentColor,
                    ),
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Text(subcategory.name, style: TextStyle(fontSize: 16, fontFamily: boldFamily))),
                        if (!state.isMobile) ...[
                          SimpleButton(
                            onPressed: () => CategoryPage.onShowSubcategories(context, subcategory),
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.list, size: 20, color: theme.textColor),
                            ),
                          ),
                          SimpleButton(
                            onPressed: () {},
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.add, size: 20, color: theme.textColor),
                            ),
                          ),
                          SimpleButton(
                            onPressed: () {},
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.edit, size: 20, color: theme.textColor),
                            ),
                          ),
                          SimpleButton(
                            onPressed: () {},
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.delete_outline, size: 20, color: theme.textColor),
                            ),
                          ),
                          SimpleButton(
                            onPressed: () {},
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.shopping_bag_outlined, size: 20, color: theme.textColor),
                            ),
                          ),
                          SimpleButton(
                            onPressed: () {},
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.add_shopping_cart, size: 20, color: theme.textColor),
                            ),
                          ),
                        ],
                        if (state.isMobile)
                          CustomPopupMenu(
                            theme: theme,
                            children: [
                              CustomPopupItem(
                                title: AppLocales.subcategories.tr(),
                                icon: Icons.list,
                                onPressed: () => CategoryPage.onShowSubcategories(context, subcategory),
                              ),
                              CustomPopupItem(title: AppLocales.addSubcategory.tr(), icon: Icons.add),
                              CustomPopupItem(title: AppLocales.edit.tr(), icon: Icons.edit),
                              CustomPopupItem(title: AppLocales.delete.tr(), icon: Icons.delete_outline),
                              CustomPopupItem(title: AppLocales.showProducts.tr(), icon: Icons.shopping_bag_outlined),
                              CustomPopupItem(title: AppLocales.addProduct.tr(), icon: Icons.add_shopping_cart),
                            ],
                            child: Container(
                              padding: 8.all,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.secondaryTextColor),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(Icons.more_vert, size: 20, color: theme.textColor),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ConfirmCancelButton(
              onConfirm: () {
                showDesktopModal(
                  context: context,
                  body: AddCategoryScreen(addSubcategoryTo: category),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
