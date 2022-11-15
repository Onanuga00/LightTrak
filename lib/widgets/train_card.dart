import 'package:flutter/material.dart';

class TrainCard extends StatelessWidget {
  const TrainCard(
      {Key? key,
      required this.to,
      required this.from,
      this.cost,
      this.trainName,
      required this.arrivalTime,
      required this.departureTime,
      required this.duration,
      required this.toCode,
      required this.fromCode})
      : super(key: key);
  final String to;
  final String toCode;
  final String fromCode;
  final String from;
  final String? cost;
  final String? trainName;
  final String arrivalTime;
  final String departureTime;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height*0.3,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xff03314B),
                radius: 10,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(
                    Icons.directions_train_sharp,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                trainName.toString(),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Text(
                  from,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  to,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Row(
                  children: [
                    Text(
                      fromCode,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    Expanded(child: Container()),
                    const CircleDot(),
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 15,
                          child: LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(
                                  (constraints.constrainWidth() / 7).floor(),
                                  (index) => Text(
                                        '-',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.blueGrey.shade300),
                                      )),
                            );
                          }),
                        )),
                    const CircleDot(),
                    Expanded(child: Container()),
                    Text(
                      toCode,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    )
                  ],
                ),
                Icon(
                  Icons.directions_train_rounded,
                  color: Colors.blueGrey.shade300,
                  size: 20,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 5),
            child: Row(
              children: [
                Text(
                  departureTime,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  duration,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  arrivalTime,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                    (constraints.constrainWidth() / 7).floor(),
                    (index) => Text(
                          '-',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.blueGrey.shade300),
                        )),
              );
            }),
          ),
          Row(
            children: [
              const Spacer(),
              Text(
                "USD $cost",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleDot extends StatelessWidget {
  const CircleDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueGrey.shade300, width: 3)),
    );
  }
}
