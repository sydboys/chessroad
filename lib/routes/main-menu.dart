import 'package:chessroad/engine/engine.dart';
import 'package:flutter/material.dart';
import '../common/color-consts.dart';
import '../main.dart';
import 'battle-page.dart';
import 'rank-page.dart';
import 'settings-page.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  //
  AnimationController inController, shadowController;
  Animation inAnimation, shadowAnimation;

  @override
  void initState() {
    //
    super.initState();

    inController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    inAnimation = CurvedAnimation(parent: inController, curve: Curves.bounceIn);
    inAnimation = new Tween(begin: 1.6, end: 1.0).animate(inController);

    shadowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    shadowAnimation = new Tween(begin: 0.0, end: 12.0).animate(shadowController);

    inController.addStatusListener((status) {
      if (status == AnimationStatus.completed) shadowController.forward();
    });
    shadowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) shadowController.reverse();
    });

    /// use 'try...catch' to avoid exception -
    /// 'setState() or markNeedsBuild() called during build.'
    inAnimation.addListener(() {
      try {
        setState(() {});
      } catch (e) {}
    });
    shadowAnimation.addListener(() {
      try {
        setState(() {});
      } catch (e) {}
    });

    inController.forward();
  }

  navigateTo(Widget page) async {
    //
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));

    inController.reset();
    shadowController.reset();
    inController.forward();
  }

  @override
  Widget build(BuildContext context) {
    //
    final nameShadow = Shadow(
      color: Color.fromARGB(0x99, 66, 0, 0),
      offset: Offset(0, shadowAnimation.value / 2),
      blurRadius: shadowAnimation.value,
    );
    final menuItemShadow = Shadow(
      color: Color.fromARGB(0x7F, 0, 0, 0),
      offset: Offset(0, shadowAnimation.value / 6),
      blurRadius: shadowAnimation.value / 3,
    );

    final nameStyle = TextStyle(
      fontSize: 64,
      color: Colors.black,
      shadows: [nameShadow],
    );
    final menuItemStyle = TextStyle(
      fontSize: 28,
      color: ColorConsts.Primary,
      shadows: [menuItemShadow],
    );

    final menuItems = Center(
      child: Column(
        children: <Widget>[
          Expanded(child: SizedBox(), flex: 3),
          Hero(tag: 'logo', child: Image.asset('images/logo.png')),
          Expanded(child: SizedBox()),
          Transform.scale(
            scale: inAnimation.value,
            child: Text('中国象棋', style: nameStyle, textAlign: TextAlign.center),
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('单机对战', style: menuItemStyle),
            onPressed: () => navigateTo(BattlePage(EngineType.Native)),
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('挑战云主机', style: menuItemStyle),
            onPressed: () => navigateTo(BattlePage(EngineType.Cloud)),
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('排行榜', style: menuItemStyle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RankPage()),
              );
            },
          ),
          Expanded(child: SizedBox(), flex: 3),
          Text('用心娱乐，为爱传承', style: TextStyle(color: Colors.black54, fontSize: 16)),
          Expanded(child: SizedBox()),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: ColorConsts.LightBackground,
      body: Stack(
        children: <Widget>[
          Positioned(right: 0, top: 0, child: Image(image: AssetImage('images/mei.png'))),
          Positioned(left: 0, bottom: 0, child: Image(image: AssetImage('images/zhu.png'))),
          menuItems,
          Positioned(
            top: ChessRoadApp.StatusBarHeight,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: ColorConsts.Primary),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //
    inController.dispose();
    shadowController.dispose();

    super.dispose();
  }
}
