import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:daily_report_tv/ui/provider/main_provider.dart';
import 'package:daily_report_tv/utils/coloors.dart';
import 'package:daily_report_tv/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, provider, _) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.reports.isEmpty
                  ? const Center(
                      child: Text("Bugunga ma'lumotlar mavjud emas"),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: Get.width - 32,
                              height: 70,
                              decoration: BoxDecoration(
                                color: primary,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 11,
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                      ),
                                      child: AnimatedTextKit(
                                        repeatForever: true,
                                        animatedTexts: [
                                          ...provider.aforizmlar.map(
                                            (aforizm) => FadeAnimatedText(
                                              aforizm,
                                              fadeOutBegin: 0.6,
                                              fadeInEnd: 0.3,
                                              textAlign: TextAlign.center,
                                              duration: const Duration(seconds: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      provider.time,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Table(
                          border: const TableBorder(
                            top: BorderSide(
                              color: Colors.grey,
                            ),
                            left: BorderSide(
                              color: Colors.grey,
                            ),
                            right: BorderSide(
                              color: Colors.grey,
                            ),
                            verticalInside: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).devicePixelRatio * 80,
                                    ),
                                    Text(
                                      'Patoklar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ishchilar soni',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Reja',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Real ish',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Farq',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              // shrinkWrap: true,
                              children: [
                                Table(
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                  ),
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(2),
                                    3: FlexColumnWidth(2),
                                    4: FlexColumnWidth(3),
                                  },
                                  children: provider.reports.map((report) {
                                    List patoks = report['patoks'];
                                    List<TableRow> patokRows = patoks.map((patok) {
                                      String name = patok['patok'];
                                      int wCount = patok['workers_count'];
                                      // int tMinutes = patok['total_minutes'];
                                      Map product = (patok['products'] as List).first ?? {};
                                      int kutilayotgan = int.parse((product['kutilayotgan'] as double).toStringAsFixed(0));
                                      int realIsh = product['real_ish'] ?? 0;
                                      int differanceIsh = realIsh - kutilayotgan;

                                      int index = patoks.indexOf(patok);

                                      return TableRow(
                                        decoration: BoxDecoration(
                                          color: index.isEven ? Colors.grey.shade100 : Colors.transparent,
                                        ),
                                        children: [
                                          SizedBox.fromSize(
                                            size: Size.fromHeight(MediaQuery.of(context).devicePixelRatio * 50),
                                            child: Center(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              '$wCount',
                                              style: const TextStyle(
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              '$kutilayotgan',
                                              style: const TextStyle(
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              '$realIsh',
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              '$differanceIsh  |${provider.calcPercentage(kutilayotgan, realIsh)}',
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: differanceIsh > 0
                                                    ? Colors.green
                                                    : differanceIsh == 0
                                                        ? Colors.black
                                                        : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList();

                                    return patokRows;
                                  }).first,
                                )
                              ],
                            ),
                          ),
                        ),
                        // total
                        const SizedBox(height: 16),
                        Table(
                          border: TableBorder.all(
                            color: Colors.grey,
                          ),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(3),
                          },
                          children: provider.reports.map((report) {
                            List patoks = report['patoks'];

                            int totalWorkers = patoks.fold(0, (prev, patok) => prev + (patok['workers_count'] as int));
                            int totalKutilayotgan = patoks.fold(
                                0,
                                (prev, patok) =>
                                    prev +
                                    int.parse(
                                      (((patok['products'] as List).first?['kutilayotgan'] ?? 0) as double).toStringAsFixed(0),
                                    ));
                            int totalRealIsh = patoks.fold(0, (prev, patok) => prev + (patok['products'] as List).fold(0, (prev, product) => prev + (product['real_ish'] as int)));
                            int totalDifferanceIsh = totalRealIsh - totalKutilayotgan;

                            return TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                              ),
                              children: [
                                SizedBox.fromSize(
                                  size: Size.fromHeight(MediaQuery.of(context).devicePixelRatio * 45),
                                  child: const Center(
                                    child: Text(
                                      'Jami',
                                      style: TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '$totalWorkers',
                                    style: const TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '$totalKutilayotgan',
                                    style: const TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '$totalRealIsh',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '$totalDifferanceIsh  |${provider.calcPercentage(totalKutilayotgan, totalRealIsh)}',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: totalDifferanceIsh > 0
                                          ? Colors.green
                                          : totalDifferanceIsh == 0
                                              ? Colors.black
                                              : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text("Ohirgi yangilanish: "),
                            Text(
                              provider.updatedAt?.stringTime ?? "Yangilanmagan",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
      );
    });
  }
}
