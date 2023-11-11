import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Color lavender = const Color(0xFF9177E0);
Color mint = const Color(0xFF77E08E);
Color background = const Color(0xFFFCFCFF);
Color text_info = const Color(0xFF595859);
Color text_sub = const Color(0xFFADADAD);
Color trans = Colors.transparent;

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark, // Android dark???
            statusBarBrightness: Brightness.light, // iOS dark???
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        bottomNavigationBar: SizedBox(
            height: 60,
            child: BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              iconSize: 25,
              backgroundColor: Colors.white,
              selectedItemColor: lavender,
              unselectedItemColor: Colors.black,
              currentIndex: currentPageIndex,
              showSelectedLabels: false,
              selectedFontSize: 0.0,
              unselectedFontSize: 0.0,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.recent_actors_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.area_chart_outlined),
                  label: '',
                ),
              ],
            )),
        body: <Widget>[
          Container(
              color: background,
              child: Column(children: [TopPlashka(), SeePlot()])),
          Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text('Page 2')),
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
              child: Text('Today',
                  style:
                      TextStyle(fontFamily: 'Inter-Regular', fontSize: 24)))),
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
        padding: EdgeInsets.only(bottom: 18),
        alignment: Alignment.bottomCenter,
        //decoration: BoxDecoration(
        //  border: Border.all(
        //    color: Colors.black, width: 1.0, style: BorderStyle.solid)),
        child: Week());
  }
}

class TopPlashka extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        //constraints: BoxConstraints(
        //  minHeight: MediaQuery.of(context).size.height * 0.22),
        decoration: BoxDecoration(
            color: Colors.white,
            //border: Border.all(width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateAndProfilePic(),
              Align(alignment: Alignment.bottomCenter, child: CalendarScroll())
            ]));
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
                Container(
                    padding:
                        EdgeInsets.only(left: 0, right: 10, top: 0, bottom: 0),
                    child: Icon(Icons.info_outline, color: lavender)),
                Text('Log your data to see graph for today',
                    style: TextStyle(fontFamily: 'Inter-Regular', fontSize: 16))
              ]))
        ]));
  }
}

class DayCont extends Container {
  String day = 'None';
  String date = 'None';
  Color ic = mint;

  DayCont(this.day, this.date, this.ic);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        alignment: Alignment.center,
        child: Column(children: [
          Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Icon(Icons.done_outline_rounded, color: ic)),
          Container(
              width: 50,
              height: 50,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 12,
                            color: Colors.black)),
                    Text(date,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 20,
                            color: Colors.black))
                  ]))
        ]));
  }
}

class DayCurr extends Container {
  String day = 'None';
  String date = 'None';

  DayCurr(this.day, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 5, left: 5),
        //decoration: BoxDecoration(
        // border: Border.all(
        //   color: Colors.black, width: 1.0, style: BorderStyle.solid)),
        width: 50,
        alignment: Alignment.center,
        child: Column(children: [
          Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Icon(Icons.done_outline_rounded, color: trans)),
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: lavender,
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 12,
                            color: Colors.white)),
                    Text(date,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 20,
                            color: Colors.white))
                  ]))
        ]));
  }
}

class Week extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
          padding: EdgeInsets.only(left: 8), child: Icon(Icons.arrow_back_ios)),
      DayCont('Wed', '7', mint),
      DayCont('Ths', '8', mint),
      DayCont('Fri', '9', mint),
      DayCont('Sat', '10', trans),
      DayCont('Sun', '11', mint),
      DayCurr('Mon', '12'),
      Container(
          padding: EdgeInsets.only(left: 8, right: 3),
          child: Icon(Icons.arrow_forward_ios)),
    ]));
  }
}
