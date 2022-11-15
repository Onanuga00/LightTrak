import 'package:flutter/material.dart';
import 'package:train_app/widgets/train_card.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // final see = DateTimeRange(start: DateTime.now(), end: DateTime(2023,31,24)).;
  final List<Widget> dates = [
    const Tab(text: 'Nov 13'),
    const Tab(text: 'Nov 14'),
    const Tab(text: 'Nov 15'),
    const Tab(text: 'Nov 16'),
    const Tab(text: 'Nov 17'),
    const Tab(text: 'Nov 18'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dates.length,
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.3),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const Text("Available Trains",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22)),
          backgroundColor: const Color(0xff03314b),
          bottom: TabBar(
            isScrollable: true,
            padding: const EdgeInsets.only(right: 1.0),
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.yellowAccent,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            tabs: dates,
          ),
        ),
        body: TabBarView(children: [
          ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                    onTap: () {
                      context.push('/options');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TrainCard(
                        to: 'Yaounde',
                        toCode: 'YDE',
                        fromCode: 'NGA',
                        from: 'Ngaoundere',
                        cost: '10000',
                        trainName: 'Camrail',
                        arrivalTime: '${DateTime.now()}'.split('.')[0],
                        departureTime: '${DateTime.now()}'.split('.')[0],
                        duration: '15h 15m',
                      ),
                    ));
              }),
          const Center(child: Text('Nov 14')),
          const Center(child: Text('Nov 15')),
          const Center(child: Text('Nov 16')),
          const Center(child: Text('Nov 17')),
          const Center(child: Text('Nov 18'))
        ]),
        // extendBody: true,
      ),
    );
  }
}
