import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
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
            AppRouter.go(context, WaiterPage());
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
                    spacing: 12,
                    children: [
                      Row(
                        spacing: 16,
                        children: [
                          Expanded(child: Text(AppLocales.orders.tr(), style: TextStyle(fontSize: 32, fontFamily: boldFamily))),
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
                      Expanded(
                        child: orders.isEmpty
                            ? AppEmptyWidget()
                            : ListView.builder(
                                padding: 120.bottom,
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final order = orders[index];
                                  return WebButton(
                                    onPressed: () {
                                      showDesktopModal(
                                        context: context,
                                        body: OrderInfoScreen(order),
                                        width: MediaQuery.of(context).size.width * 0.4,
                                      );
                                    },
                                    builder: (focused) {
                                      return AnimatedContainer(
                                        margin: 16.bottom,
                                        padding: 16.all,
                                        duration: theme.animationDuration,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: focused ? theme.mainColor.withOpacity(0.2) : theme.accentColor,
                                          border: Border.all(color: focused ? theme.mainColor : theme.accentColor),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                spacing: 8,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    spacing: 8,
                                                    children: [
                                                      Icon(Ionicons.time_outline),
                                                      Text(
                                                        "${AppLocales.createdDate.tr()}: ",
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        DateFormat('yyyy.MM.dd, HH:mm').format(DateTime.parse(order.createdDate)),
                                                        style: TextStyle(fontFamily: boldFamily),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing: 8,
                                                    children: [
                                                      Icon(Ionicons.time_outline),
                                                      Text(
                                                        "${order.status == Order.completed ? AppLocales.closedDate : AppLocales.updatedDate.tr()}: ",
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        DateFormat('yyyy.MM.dd, HH:mm').format(DateTime.parse(order.createdDate)),
                                                        style: TextStyle(fontFamily: boldFamily),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                spacing: 8,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    spacing: 8,
                                                    children: [
                                                      SvgPicture.asset('assets/icons/dining-table.svg', height: 24, width: 24),
                                                      Text(
                                                        "${AppLocales.place.tr()}: ",
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        "${order.place.father != null ? '${order.place.father!.name}, ' : ''}${order.place.name}",
                                                        style: TextStyle(fontFamily: boldFamily),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing: 8,
                                                    children: [
                                                      Icon(Ionicons.wallet_outline),
                                                      Text(
                                                        "${AppLocales.total.tr()}: ",
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        order.price.priceUZS,
                                                        style: TextStyle(fontFamily: boldFamily),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (order.status == Order.completed) Center(child: Icon(Icons.done, size: 32, color: theme.mainColor)),
                                            if (order.status == Order.cancelled) Center(child: Icon(Icons.close, size: 32, color: Colors.red)),
                                            if (order.status == Order.opened) Center(child: Icon(Icons.close, size: 32, color: Colors.amber)),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                      if (orderFilter.value.isActive())
                        state.whenProviderData(
                            provider: ordersFilterProvider(orderFilter.value),
                            builder: (orders) {
                              orders as List<Order>;

                              final double totalSumm = orders.fold(0.0, (value, element) => value += element.price);

                              return Padding(
                                padding: Dis.only(tb: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocales.selectedFilterResultSummLabel.tr()}: ",
                                      style: TextStyle(fontSize: 20, fontFamily: mediumFamily),
                                    ),
                                    Text(
                                      totalSumm.priceUZS,
                                      style: TextStyle(fontSize: 24, fontFamily: boldFamily),
                                    )
                                  ],
                                ),
                              );
                            })
                    ],
                  ),
                );
              },
            ),
      );
    });
  }
}
