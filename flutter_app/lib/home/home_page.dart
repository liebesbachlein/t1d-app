import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 0;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark, // Android dark
            statusBarBrightness: Brightness.light, // iOS dark
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.lightGreen,
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: '',
            ),
            NavigationDestination(
              //selectedIcon: Icon(Icons.access_time),
              icon: Icon(Icons.access_time),
              label: '',
            ),
            NavigationDestination(
              //selectedIcon: Icon(Icons.add_circle_outline),
              icon: Icon(Icons.add_circle),
              label: '',
            ),
            NavigationDestination(
              //selectedIcon: Icon(Icons.add_circle_outline),
              icon: Icon(Icons.recent_actors),
              label: '',
            ),
            NavigationDestination(
              //selectedIcon: Icon(Icons.add_circle_outline),
              icon: Icon(Icons.area_chart),
              label: '',
            ),
          ],
        ),
        body: <Widget>[
          Container(
              color: Colors.grey,
              child: Column(children: [TopPlashka(), SeePlot()])),
          Container(
            color: Colors.green,
            alignment: Alignment.center,
            child: const Text('Page 2'),
          ),
          Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text('Page 3')),
          Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Page 4')),
          Container(
              color: Colors.purple,
              alignment: Alignment.center,
              child: const Text('Page 3'))
        ][currentPageIndex]);
  }
}

class DateAndProfilePic extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          child: Padding(
              padding: EdgeInsets.only(left: 29, right: 29),
              child: Text('Today'))),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(color: Colors.transparent),
              alignment: Alignment.center,
              child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: Colors.black,
                  ))))
    ]));
  }
}

class CalendarScroll extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            //border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(24)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('<'),
          Column(children: [
            Row(children: [Text('+ + + +')]),
            Row(children: [Text('Wed Ths Fri Sat Sun Mon')]),
            Row(children: [Text('7 8 9 10 11 12')]),
          ])
        ]));
  }
}

class TopPlashka extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.22),
        decoration: BoxDecoration(
            color: Colors.white,
            //border: Border.all(width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24))),
        child: Column(children: [DateAndProfilePic(), CalendarScroll()]));
  }
}

class SeePlot extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 17, right: 17, top: 37),
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(children: [
          Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 26, bottom: 26),
              alignment: Alignment.topLeft,
              child: Row(children: [
                Icon(Icons.favorite),
                Text('Log your data to see graph for today')
              ]))
        ]));
  }
}
