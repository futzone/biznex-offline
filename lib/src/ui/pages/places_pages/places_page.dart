import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/place_controller.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/places_provider.dart';
import 'package:biznex/src/ui/pages/places_pages/add_place.dart';
import 'package:biznex/src/ui/pages/places_pages/place_children_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';

class PlacesPage extends HookConsumerWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const PlacesPage(this.floatingActionButton, {super.key, required this.appbar});

  // static void onShowSubcategories(BuildContext context, Category category) {
  //   showDesktopModal(
  //     width: MediaQuery.of(context).size.width * 0.8,
  //     context: context,
  //     body: CategorySubcategories(category: category),
  //   );
  // }

  // static void onAddSubcategory(BuildContext context, Category category) {
  //   showDesktopModal(
  //     context: context,
  //     body: AddCategoryScreen(addSubcategoryTo: category),
  //   );
  // }
  //
  // static void onEditCategory(BuildContext context, Category category) {
  //   showDesktopModal(
  //     context: context,
  //     body: AddCategoryScreen(editCategory: category),
  //   );
  // }

  // static void onDeleteCategory(BuildContext context, Category category, AppModel state) {
  //   CategoryController controller = CategoryController(context: context, state: state);
  //   controller.delete(category.id);
  // }
  //
  // static void onAddProduct(BuildContext context, Category category) {
  //   showDesktopModal(
  //     context: context,
  //     body: AppEmptyWidget(),
  //   );
  // }
  //
  // static void onShowProducts(BuildContext context, Category category) {
  //   showDesktopModal(
  //     context: context,
  //     body: AppEmptyWidget(),
  //   );
  // }

  @override
  Widget build(BuildContext context, ref) {
    final filteredCategories = useState([]);
    final searchController = useTextEditingController();
    return AppStateWrapper(
      builder: (theme, state) {
        return state.whenProviderData(
          provider: placesProvider,
          builder: (categories) {
            categories as List<Place>;

            return AppScaffold(
              appbar: appbar,
              state: state,
              title: AppLocales.places.tr(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDesktopModal(context: context, body: AddPlace());
                },
                backgroundColor: theme.mainColor,
                child: Icon(Icons.add, color: Colors.white),
              ),
              floatingActionButtonNotifier: floatingActionButton,
              actions: [
                if (state.isDesktop) 160.w,
                if (state.isDesktop)
                  Expanded(
                    child: AppTextField(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(Ionicons.search_outline),
                      ),
                      suffixIcon: Padding(
                        padding: 8.lr,
                        child: IconButton(
                          icon: Icon(Ionicons.close),
                          onPressed: () {
                            filteredCategories.value.clear();
                          },
                        ),
                      ),
                      title: AppLocales.searchBarHint.tr(),
                      controller: searchController,
                      theme: theme,
                      enabledColor: theme.secondaryTextColor,
                      onChanged: (str) {
                        filteredCategories.value = categories.where((ctg) {
                          return (ctg.name.toLowerCase().contains(str.toLowerCase()));
                        }).toList();
                      },
                    ),
                  ),
                if (!state.isDesktop)
                  AppSimpleButton(
                    text: AppLocales.search.tr(),
                    icon: Icons.search,
                    onPressed: () {},
                  ),
                if (state.isDesktop)
                  WebButton(
                    onPressed: () {
                      showDesktopModal(context: context, body: AddPlace());
                    },
                    builder: (focused) {
                      return AnimatedContainer(
                        duration: theme.animationDuration,
                        decoration: BoxDecoration(
                          color: focused ? theme.mainColor : null,
                          border: Border.all(color: theme.mainColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: Dis.all(10),
                        child: Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.add, color: focused ? Colors.white : theme.mainColor),
                            AppText.$16Bold(
                              AppLocales.add.tr(),
                              style: TextStyle(
                                color: focused ? Colors.white : theme.mainColor,
                                fontFamily: mediumFamily,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
              body: categories.isEmpty
                  ? AppEmptyWidget()
                  : ListView.builder(
                      itemCount: filteredCategories.value.isNotEmpty ? filteredCategories.value.length : categories.length,
                      padding: Dis.only(lr: 24),
                      itemBuilder: (context, index) {
                        Place category = (filteredCategories.value.isNotEmpty ? filteredCategories.value : categories)[index];
                        return AppListTile(
                          title: category.name,
                          theme: theme,
                          onEdit: () {
                            showDesktopModal(context: context, body: AddPlace(editCategory: category));
                          },
                          trailingIcon: Ionicons.add_circle_outline,
                          onDelete: () {
                            PlaceController placeController = PlaceController(context: context, state: state);
                            placeController.delete(category.id);
                          },
                          onPressed: () {
                            showDesktopModal(context: context, body: PlaceChildrenPage(category));
                          },
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
