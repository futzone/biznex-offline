import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/ui/pages/login_pages/onboard_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/constants/intro_static.dart';

class LoginHalfPage extends HookConsumerWidget {
  final AppModel app;

  LoginHalfPage(this.app, {super.key});

  final List<String> _images = [
    "assets/images/img.png",
    "assets/images/img_1.png",
    "assets/images/img_2.png",
  ];

  @override
  Widget build(BuildContext context, ref) {
    final currentIndex = useState(0);
    final language = context.locale.languageCode == 'en' ? 'uz' : context.locale.languageCode;
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                onPageChanged: (int page, _) => currentIndex.value = page,
              ),
              items: _images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(i),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: Dis.only(left: 35, right: 35, bottom: 35, top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 24,
              children: [
                if (app.pincode.isNotEmpty)
                  SimpleButton(
                    onPressed: () {
                      AppRouter.open(context, OnboardPage());
                    },
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                if (app.pincode.isNotEmpty) Spacer(),
                Text(
                  introStatic[currentIndex.value][language].toString(),
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: mediumFamily,
                    color: Colors.white,
                  ),
                ),
                Row(
                  spacing: 8,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: 8,
                      width: index == currentIndex.value ? 60 : 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: index == currentIndex.value ? Colors.white : Colors.grey,
                      ),
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
