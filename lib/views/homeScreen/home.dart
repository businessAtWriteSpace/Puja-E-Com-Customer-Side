
import 'package:e_commerce_app/views/cartScreen/cart_screen.dart';
import 'package:e_commerce_app/views/categoryScreen/category_screen.dart';
import 'package:e_commerce_app/views/homeScreen/home_screen.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../controller/home_controller.dart';
import '../../widgets/exit_dialog.dart';
import '../profileScreen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //init home controller
    var controller = Get.put(HomeController());
    var navbarItem = [
      BottomNavigationBarItem(icon: Image.asset(icHome, width: 26,), label: home),
      BottomNavigationBarItem(icon: Image.asset(icCategories, width: 26,), label: categories),
      BottomNavigationBarItem(icon: Image.asset(icCart, width: 26,), label: cart),
      BottomNavigationBarItem(icon: Image.asset(icProfile, width: 26,), label: account),
    ];
    var navBody = [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    return WillPopScope(
      onWillPop: () async{
        showDialog(
          barrierDismissible: false,
            context: context, builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(() =>Expanded(child: navBody.elementAt(controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx( () =>
          BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            items: navbarItem,
            backgroundColor: whiteColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: redColor,
            selectedLabelStyle: TextStyle(fontFamily: semibold),
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
