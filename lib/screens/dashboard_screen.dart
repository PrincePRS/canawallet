import 'package:cancoin_wallet/screens/browser/browser_screen.dart';
import 'package:cancoin_wallet/screens/notify/notify_screen.dart';
import 'package:cancoin_wallet/screens/setting/setting_screen.dart';
import 'package:cancoin_wallet/screens/wallet/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  bool _hideNavBar = false;

  List<Widget> _buildScreens() {
    return [
      WalletScreen(),
      BrowserScreen(),
      SettingScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.layerGroup, size: 30),
        title: "Home",
        textStyle: TextStyle(fontSize: 16, fontFamily: Strings.fSemiBold),
        activeColorPrimary: color.btnPrimaryColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: color.lightTextColor,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.alternateExternalLink, size: 30),
        title: ("DApps"),
        textStyle: TextStyle(fontSize: 16, fontFamily: Strings.fSemiBold),
        activeColorPrimary: color.btnPrimaryColor,
        inactiveColorPrimary: color.lightTextColor,
        inactiveColorSecondary: Colors.white,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.cog, size: 30),
        title: ('setting'.tr),
        textStyle: TextStyle(fontSize: 16, fontFamily: Strings.fSemiBold),
        activeColorPrimary: color.btnPrimaryColor,
        inactiveColorPrimary: color.lightTextColor,
        activeColorSecondary: Colors.white,
        inactiveColorSecondary: Colors.white
      ),
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.bell, size: 30),
        title: ("Notification"),
        textStyle: TextStyle(fontSize: 16, fontFamily: Strings.fSemiBold),
        activeColorPrimary: color.btnPrimaryColor,
        inactiveColorPrimary: color.lightTextColor,
        activeColorSecondary: Colors.white,
        inactiveColorSecondary: Colors.white
      )
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : 70,
          hideNavigationBarWhenKeyboardShows: true,
          margin: EdgeInsets.all(0.0),
          popActionScreens: PopActionScreensType.all,
          bottomScreenMargin: 70.0,
          selectedTabScreenContext: (context) {},
          hideNavigationBar: _hideNavBar,
          decoration: NavBarDecoration(
            colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.circular(0.0)
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 50),
            curve: Curves.decelerate
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.easeInCirc,
            duration: Duration(milliseconds: 50),
          ),
          navBarStyle: NavBarStyle.style10, // Choose the nav bar style with this property
        ),
      );
    });
  }
}