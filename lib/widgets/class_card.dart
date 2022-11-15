import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  const ClassCard(
      {super.key,
      this.onTap,
      this.cost,
      this.className,
      required this.classBenefits,
      required this.iconList});

  final void Function()? onTap;
  final String? cost;
  final String? className;
  final List<String> classBenefits;
  final List<IconData> iconList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  className.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                Text(
                  cost.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.green),
                )
              ],
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 2,
              height: 30,
            ),
            Column(
              children: List.generate(
                  classBenefits.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              iconList[index],
                              color: Colors.green,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              classBenefits[index],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      )),
            )
          ],
        ),
      ),
    );
  }
}
