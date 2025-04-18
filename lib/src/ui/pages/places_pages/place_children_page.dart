import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/place_controller.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/ui/pages/places_pages/add_place.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';

class PlaceChildrenPage extends ConsumerWidget {
  final Place place;

  const PlaceChildrenPage(this.place, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppStateWrapper(builder: (theme, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.$18Bold(place.name),
              AppPrimaryButton(
                padding: Dis.only(tb: 6, lr: 16),
                theme: theme,
                onPressed: () {
                  showDesktopModal(context: context, body: AddPlace(addSubcategoryTo: place));
                },
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.add, size: 18, color: Colors.white),
                    Text(AppLocales.addPlace.tr(), style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: place.children == null || place.children!.isEmpty
                ? AppEmptyWidget()
                : ListView.builder(
                    itemCount: place.children == null ? 0 : place.children?.length,
                    itemBuilder: (context, index) {
                      final category = place.children![index];
                      return AppListTile(
                        title: category.name,
                        theme: theme,
                        onEdit: () {
                          showDesktopModal(context: context, body: AddPlace(editCategory: place));
                        },
                        trailingIcon: Ionicons.add_circle_outline,
                        onDelete: () {
                          PlaceController pc = PlaceController(context: context, state: state);
                          pc.delete(category.id);
                        },
                        onPressed: () {
                          showDesktopModal(context: context, body: PlaceChildrenPage(category));
                        },
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
