import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/pages/category_pages/category_page.dart';
import 'package:biznex/src/ui/pages/product_pages/product_params_page.dart';
import 'package:biznex/src/ui/screens/custom_scaffold/app_sidebar.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../product_pages/product_information_page.dart';
import '../product_pages/products_page.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  Widget buildBody({required AppModel state, required Widget child, required Widget sidebar}) {
    if (!state.isDesktop) return child;
    return Row(children: [sidebar, Expanded(child: child)]);
  }

  @override
  Widget build(BuildContext context, ref) {
    final pageValue = useState(0);
    final appbar = useState(AppBar());
    final fab = useState<FloatingActionButton?>(null);
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          appBar: !state.isDesktop ? appbar.value : null,
          drawer: state.isDesktop ? null : AppSidebar(pageValue),
          floatingActionButton: !state.isDesktop ? fab.value : null,
          body: buildBody(
            state: state,
            sidebar: AppSidebar(pageValue),
            child: HookBuilder(
              builder: (context) {
                if (pageValue.value == 2) return CategoryPage(appbar: appbar, fab);
                if (pageValue.value == 5) return ProductInformationsPage(appbar: appbar, fab);
                if (pageValue.value == 6) return ProductParamsPage(appbar: appbar, fab);
                return ProductsPage(fab, appbar: appbar);
              },
            ),
          ),
        );
      },
    );
  }
}
