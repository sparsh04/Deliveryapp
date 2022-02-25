// ignore_for_file: unused_import

import 'package:delivery/constant.dart';
import 'package:delivery/orders.dart';
import 'package:delivery/payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  //const BottomBar({Key? key}) : super(key: key);
  var index;
  BottomBar(this.index);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Orders();
    Payments();
  }

  List<Widget> screen = [
    Orders(),
    Payments(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screen,
      ),
      // body: screen[_selectedIndex],
      //child: screen[_selectedIndex]),
      bottomNavigationBar: Container(
          height: 60,
          color: whitecolors,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: BottomAppBar(
                color: whitecolors,
                elevation: 2,
                // color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconBottomBar(
                          icon: "assets/icons/home.svg",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          selected: _selectedIndex == 0,
                          text: 'Active Orders',
                        ),
                        IconBottomBar(
                          icon: "assets/icons/package.svg",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          selected: _selectedIndex == 1,
                          text: 'All Orders',
                        ),
                      ],
                    )),
              ))),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final String text;
  final bool selected;
  final String icon;
  final Function() onPressed;

  const IconBottomBar(
      {key,
      required this.text,
      required this.selected,
      required this.onPressed,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: greencolor.withOpacity(0.5),
      onTap: onPressed,
      child: SizedBox(
        width: screenWidth(context) / 4.5,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            icon,
            color: selected ? greencolor : textcolorgrey,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  // height: .10,
                  color: selected ? Colors.green : Colors.grey)),
        ]),
      ),
    );
  }

  double screenHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}
