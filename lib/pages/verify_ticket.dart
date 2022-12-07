import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scan/scan.dart';
import 'package:train_app/models/model_dao.dart';

import 'ticket_options.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  ScanController controller = ScanController();
  bool barcode = false;
  String _platformVersion = 'Unknown';
  // List<String> tickedIDs = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Verify Passenger Ticket',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Consumer(builder: (context, ref, child) {
              AsyncValue<List<String>> ticketIDs =
                  ref.watch(futureTicketIDProvider);
              return ticketIDs.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
                data: (ids) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width *
                      0.8, // custom wrap size
                  height: 250,
                  child: ScanView(
                    controller: controller,
                    scanAreaScale: 0.85,
                    scanLineColor: Colors.green.shade400,
                    onCapture: (data) {
                      controller.pause();
                      if (ids.contains(data)) {
                        setState(() {
                          barcode = true;
                        });
                      }
                    },
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 30,
            ),
            barcode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.done_all_rounded,
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text('Success',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          )),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: 60,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text('No match yet',
                          style: TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                controller.resume();
                setState(() {
                  barcode = false;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown, width: 2.0),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Do another scan',
                  style: TextStyle(fontSize: 20, color: Colors.brown),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Return Home',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
