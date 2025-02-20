import 'package:flutter/material.dart';
import 'package:uber_bagare/Pages/list_fighter_view.dart';
import 'package:uber_bagare/Pages/map_view.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.list,
                  size: 50,
                )),
                Tab(
                    icon: Icon(
                  Icons.map_outlined,
                  size: 50,
                )),
              ],
            ),
            title: Center(
              child: Text("Uber Bagarre"),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: ListFighterView()),
              Center(child: MapView())
            ],
          ),
        ));
  }
}
