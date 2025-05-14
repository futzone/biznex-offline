import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/extensions/color_generator.dart';
import 'package:biznex/src/core/extensions/for_string.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/order_models/order_filter_model.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/employee_orders_provider.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/providers/places_provider.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/pages/waiter_pages/waiter_page.dart';
import 'package:biznex/src/ui/screens/order_screens/order_info_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_error_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrdersPage extends StatefulHookConsumerWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final orderFilter = useState(OrderFilterModel());
    final placeFather = useState<Place?>(null);
    return AppStateWrapper(builder: (theme, state) {
      return Scaffold(
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: theme.mainColor,
          onPressed: () {
            AppRouter.go(context, WaiterPage(haveBack: true));
          },
          child: Icon(Icons.add, size: 60, color: Colors.white),
        ),
        body: ref.watch(ordersFilterProvider(orderFilter.value)).when(
              loading: () => AppLoadingScreen(),
              error: (error, stackTrace) => AppErrorScreen(),
              data: (orders) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 16,
                          children: [
                            state.whenProviderData(
                              provider: placesProvider,
                              builder: (places) {
                                places as List<Place>;

                                return CustomPopupMenu(
                                  theme: theme,
                                  children: [
                                    CustomPopupItem(
                                      title: AppLocales.all.tr(),
                                      onPressed: () {
                                        placeFather.value = null;
                                        OrderFilterModel filterModel = orderFilter.value;
                                        filterModel.place = null;
                                        orderFilter.value = filterModel;
                                        setState(() {});
                                        ref.invalidate(ordersFilterProvider);
                                      },
                                    ),
                                    for (final pls in places)
                                      CustomPopupItem(
                                        title: pls.name,
                                        onPressed: () {
                                          if (pls.children != null && pls.children!.isNotEmpty) {
                                            placeFather.value = pls;
                                            OrderFilterModel filterModel = orderFilter.value;
                                            filterModel.place = pls.id;
                                            orderFilter.value = filterModel;
                                            setState(() {});
                                            return;
                                          }

                                          placeFather.value = null;
                                          OrderFilterModel filterModel = orderFilter.value;
                                          filterModel.place = pls.id;
                                          orderFilter.value = filterModel;
                                          setState(() {});
                                          ref.invalidate(ordersFilterProvider);
                                        },
                                      )
                                  ],
                                  child: Container(
                                    padding: Dis.only(lr: 24, tb: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: theme.accentColor,
                                      border: orderFilter.value.place == null ? null : Border.all(color: theme.mainColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        orderFilter.value.place == null
                                            ? AppLocales.places.tr()
                                            : placeFather.value != null
                                                ? placeFather.value!.name
                                                : places.firstWhere((el) => el.id == orderFilter.value.place).name,
                                        style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (placeFather.value != null)
                              CustomPopupMenu(
                                theme: theme,
                                children: [
                                  CustomPopupItem(
                                    title: AppLocales.all.tr(),
                                    onPressed: () {
                                      placeFather.value = null;
                                      OrderFilterModel filterModel = orderFilter.value;
                                      filterModel.place = null;
                                      orderFilter.value = filterModel;
                                      setState(() {});
                                      ref.invalidate(ordersFilterProvider);
                                    },
                                  ),
                                  for (final item in placeFather.value!.children!)
                                    CustomPopupItem(
                                      title: item.name,
                                      onPressed: () {
                                        OrderFilterModel filterModel = orderFilter.value;
                                        filterModel.place = item.id;
                                        orderFilter.value = filterModel;
                                        setState(() {});

                                        ref.invalidate(ordersFilterProvider);
                                      },
                                    ),
                                ],
                                child: Container(
                                  padding: Dis.only(lr: 24, tb: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: theme.accentColor,
                                    border: orderFilter.value.place == null ? null : Border.all(color: theme.mainColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      orderFilter.value.place == null
                                          ? AppLocales.stol.tr()
                                          : placeFather.value!.children!
                                              .firstWhere(
                                                (e) => e.id == orderFilter.value.place,
                                                orElse: () => Place(name: AppLocales.stol.tr()),
                                              )
                                              .name,
                                      style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                    ),
                                  ),
                                ),
                              ),
                            state.whenProviderData(
                              provider: employeeProvider,
                              builder: (places) {
                                places as List<Employee>;

                                return CustomPopupMenu(
                                  theme: theme,
                                  children: [
                                    CustomPopupItem(
                                      title: AppLocales.all.tr(),
                                      onPressed: () {
                                        OrderFilterModel filterModel = orderFilter.value;
                                        filterModel.employee = null;
                                        orderFilter.value = filterModel;
                                        setState(() {});
                                        ref.invalidate(ordersFilterProvider);
                                      },
                                    ),
                                    for (final item in places)
                                      CustomPopupItem(
                                          title: item.fullname,
                                          onPressed: () {
                                            OrderFilterModel filterModel = orderFilter.value;
                                            filterModel.employee = item.id;
                                            orderFilter.value = filterModel;
                                            setState(() {});

                                            ref.invalidate(ordersFilterProvider);
                                          }),
                                  ],
                                  child: Container(
                                    padding: Dis.only(lr: 24, tb: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: theme.accentColor,
                                      border: orderFilter.value.employee == null ? null : Border.all(color: theme.mainColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        orderFilter.value.employee == null
                                            ? AppLocales.employees.tr()
                                            : places
                                                .firstWhere(
                                                  (el) => el.id == orderFilter.value.employee,
                                                  orElse: () => Employee(
                                                      fullname: AppLocales.employees.tr(),
                                                      roleId: '',
                                                      roleName: ''
                                                          ''),
                                                )
                                                .fullname,
                                        style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            state.whenProviderData(
                              provider: productsProvider,
                              builder: (places) {
                                places as List<Product>;

                                return CustomPopupMenu(
                                  theme: theme,
                                  children: [
                                    CustomPopupItem(
                                      title: AppLocales.all.tr(),
                                      onPressed: () {
                                        OrderFilterModel filterModel = orderFilter.value;
                                        filterModel.product = null;
                                        orderFilter.value = filterModel;
                                        setState(() {});
                                        ref.invalidate(ordersFilterProvider);
                                      },
                                    ),
                                    for (int i = 0; i < ((places.length > 100) ? 100 : places.length); i++)
                                      CustomPopupItem(
                                        title: places[i].name,
                                        onPressed: () {
                                          OrderFilterModel filterModel = orderFilter.value;
                                          filterModel.product = places[i].id;
                                          orderFilter.value = filterModel;
                                          setState(() {});

                                          ref.invalidate(ordersFilterProvider);
                                        },
                                      )
                                  ],
                                  child: Container(
                                    padding: Dis.only(lr: 24, tb: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: theme.accentColor,
                                      border: orderFilter.value.product == null ? null : Border.all(color: theme.mainColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        orderFilter.value.product == null
                                            ? AppLocales.products.tr()
                                            : places
                                                .firstWhere(
                                                  (el) => el.id == orderFilter.value.product,
                                                  orElse: () => Product(name: AppLocales.products.tr(), price: 0),
                                                )
                                                .name,
                                        style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            CustomPopupMenu(
                              theme: theme,
                              children: [
                                CustomPopupItem(
                                  title: AppLocales.all.tr(),
                                  onPressed: () {
                                    OrderFilterModel filterModel = orderFilter.value;
                                    filterModel.status = null;
                                    orderFilter.value = filterModel;
                                    setState(() {});
                                    ref.invalidate(ordersFilterProvider);
                                  },
                                ),
                                for (final item in [Order.opened, Order.cancelled, Order.completed])
                                  CustomPopupItem(
                                    title: item.tr(),
                                    onPressed: () {
                                      OrderFilterModel filterModel = orderFilter.value;
                                      filterModel.status = item;
                                      orderFilter.value = filterModel;
                                      setState(() {});

                                      ref.invalidate(ordersFilterProvider);
                                    },
                                  ),
                              ],
                              child: Container(
                                padding: Dis.only(lr: 24, tb: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: theme.accentColor,
                                  border: orderFilter.value.status == null ? null : Border.all(color: theme.mainColor),
                                ),
                                child: Center(
                                  child: Text(
                                    orderFilter.value.status == null ? AppLocales.status.tr() : orderFilter.value.status!.tr(),
                                    style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                  ),
                                ),
                              ),
                            ),
                            SimpleButton(
                              onPressed: () {
                                showDatePicker(context: context, firstDate: DateTime(2025, 1), lastDate: DateTime.now()).then((date) {
                                  if (date != null) {
                                    OrderFilterModel filterModel = orderFilter.value;
                                    filterModel.dateTime = date;
                                    orderFilter.value = filterModel;
                                    setState(() {});

                                    ref.invalidate(ordersFilterProvider);
                                  }
                                });
                              },
                              child: Container(
                                padding: Dis.only(lr: 24, tb: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: theme.accentColor,
                                  border: orderFilter.value.dateTime == null ? null : Border.all(color: theme.mainColor),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        orderFilter.value.dateTime == null
                                            ? AppLocales.date.tr()
                                            : DateFormat('d-MMMM').format(orderFilter.value.dateTime!),
                                        style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                      ),
                                      if (orderFilter.value.dateTime != null) 16.w,
                                      if (orderFilter.value.dateTime != null)
                                        SimpleButton(
                                          onPressed: () {
                                            OrderFilterModel filterModel = orderFilter.value;
                                            filterModel.dateTime = null;
                                            orderFilter.value = filterModel;
                                            setState(() {});
                                            ref.invalidate(ordersFilterProvider);
                                          },
                                          child: Icon(Ionicons.close_circle_outline, color: Colors.red),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: orders.isEmpty
                            ? AppEmptyWidget()
                            : GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: context.w(16),
                                  mainAxisSpacing: context.h(16),
                                  childAspectRatio: 353 / 363,
                                ),
                                itemBuilder: (context, index) {
                                  return OrderCard(order: orders[index], theme: theme);
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
      );
    });
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final AppColors theme;

  const OrderCard({super.key, required this.order, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: Dis.all(context.s(16)),
      child: Column(
        // spacing: context.h(16),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: context.w(16),
            children: [
              Container(
                height: context.s(56),
                width: context.s(56),
                decoration: BoxDecoration(
                  color: generateColorFromString(order.employee.id),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    order.employee.fullname.initials,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontFamily: mediumFamily,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  spacing: context.h(4),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.employee.roleName,
                      style: TextStyle(
                        fontSize: context.s(16),
                        fontWeight: FontWeight.w500,
                        fontFamily: mediumFamily,
                      ),
                    ),
                    Text(
                      "ID: ${order.orderNumber}",
                      style: TextStyle(
                        fontSize: context.s(12),
                        fontWeight: FontWeight.w500,
                        fontFamily: regularFamily,
                        color: theme.secondaryTextColor,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: Dis.all(context.s(12)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorFromStatus(order.status.toString()),
                  ),
                  color: colorFromStatus(order.status.toString()).withValues(alpha: 0.1),
                ),
                child: Text(
                  order.status.toString().tr(),
                  style: TextStyle(
                    fontSize: context.s(12),
                    color: colorFromStatus(order.status.toString()),
                    fontFamily: mediumFamily,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd.MM.yyyy').format(DateTime.parse(order.createdDate)),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: mediumFamily,
                  color: Colors.blueGrey.shade500,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(DateTime.parse(order.createdDate)),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: mediumFamily,
                  color: Colors.blueGrey.shade500,
                ),
              )
            ],
          ),
          Container(height: 1, color: Colors.grey.shade200, width: double.infinity),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocales.productName.tr(),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: mediumFamily,
                  color: Colors.blueGrey.shade400,
                ),
              ),
              Text(
                AppLocales.price.tr(),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: mediumFamily,
                  color: Colors.blueGrey.shade400,
                ),
              )
            ],
          ),
          for (int i = 0; i < (order.products.length > 3 ? 3 : order.products.length); i++)
            Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.products[i].product.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: mediumFamily,
                      color: Colors.blueGrey.shade400,
                    ),
                  ),
                ),
                Text(
                  "${order.products[i].amount.toMeasure} x ${order.products[i].product.price.priceUZS}",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: mediumFamily,
                    color: Colors.blueGrey.shade400,
                  ),
                )
              ],
            ),
          Container(height: 1, color: Colors.grey.shade200, width: double.infinity),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppLocales.total.tr()}: ",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: mediumFamily,
                  // color: Colors.blueGrey.shade400,
                ),
              ),
              Text(
                order.price.priceUZS,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: boldFamily,
                  // color: Colors.blueGrey.shade400,
                ),
              )
            ],
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: Dis.tb(context.h(12)),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      AppLocales.more.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: mediumFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: Dis.tb(context.h(12)),
                  decoration: BoxDecoration(
                    color: theme.mainColor,
                    border: Border.all(color: theme.mainColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocales.more.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: mediumFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(Iconsax.tick_square, color: Colors.white)
                    ],
                  ),
                ),
              ),
              // Container(),
            ],
          )
        ],
      ),
    );
  }
}
