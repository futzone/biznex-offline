import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/core/model/category_model/category_model.dart';
import 'package:biznex/src/ui/pages/category_pages/category_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/helpers/app_custom_padding.dart';
import 'package:biznex/src/ui/widgets/helpers/app_simple_button.dart';

class CategoryCard extends AppStatelessWidget {
  final Category category;

  const CategoryCard(this.category, {super.key});

  @override
  Widget builder(BuildContext context, AppColors theme, WidgetRef ref, AppModel state) {
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
          Expanded(child: Text(category.name, style: TextStyle(fontSize: 16, fontFamily: boldFamily))),
          if (!state.isMobile) ...[
            SimpleButton(
              onPressed: () => CategoryPage.onShowSubcategories(context, category),
              child: Container(
                padding: 8.all,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.secondaryTextColor),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(Icons.list, size: 20, color: theme.textColor),
              ),
            ),
            // SimpleButton(
            //   onPressed: () => CategoryPage.onAddSubcategory(context, category),
            //   child: Container(
            //     padding: 8.all,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: theme.secondaryTextColor),
            //       borderRadius: BorderRadius.circular(32),
            //     ),
            //     child: Icon(Icons.add, size: 20, color: theme.textColor),
            //   ),
            // ),
            SimpleButton(
              onPressed: () => CategoryPage.onEditCategory(context, category),
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
              onPressed: () => CategoryPage.onDeleteCategory(context, category, state),
              child: Container(
                padding: 8.all,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.secondaryTextColor),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(Icons.delete_outline, size: 20, color: theme.textColor),
              ),
            ),
            // SimpleButton(
            //   onPressed: () => CategoryPage.onShowProducts(context, category),
            //   child: Container(
            //     padding: 8.all,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: theme.secondaryTextColor),
            //       borderRadius: BorderRadius.circular(32),
            //     ),
            //     child: Icon(Icons.shopping_bag_outlined, size: 20, color: theme.textColor),
            //   ),
            // ),
            // SimpleButton(
            //   onPressed: () => CategoryPage.onAddProduct(context, category),
            //   child: Container(
            //     padding: 8.all,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: theme.secondaryTextColor),
            //       borderRadius: BorderRadius.circular(32),
            //     ),
            //     child: Icon(Icons.add_shopping_cart, size: 20, color: theme.textColor),
            //   ),
            // ),
          ],
          if (state.isMobile)
            CustomPopupMenu(
              theme: theme,
              children: [
                CustomPopupItem(
                  title: AppLocales.subcategories.tr(),
                  icon: Icons.list,
                  onPressed: () => CategoryPage.onShowSubcategories(context, category),
                ),

                CustomPopupItem(
                  title: AppLocales.edit.tr(),
                  icon: Icons.edit,
                  onPressed: () => CategoryPage.onEditCategory(context, category),
                ),
                CustomPopupItem(
                  title: AppLocales.delete.tr(),
                  icon: Icons.delete_outline,
                  onPressed: () => CategoryPage.onDeleteCategory(context, category, state),
                ),
                // CustomPopupItem(
                //   title: AppLocales.showProducts.tr(),
                //   icon: Icons.shopping_bag_outlined,
                //   onPressed: () => CategoryPage.onShowProducts(context, category),
                // ),
                // CustomPopupItem(
                //   title: AppLocales.addProduct.tr(),
                //   icon: Icons.add_shopping_cart,
                //   onPressed: () => CategoryPage.onAddProduct(context, category),
                // ),
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
  }
}
