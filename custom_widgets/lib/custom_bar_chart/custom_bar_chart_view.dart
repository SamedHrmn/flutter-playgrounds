import 'package:custom_widgets/custom_bar_chart/custom_bar_chart.dart';
import 'package:custom_widgets/custom_bar_chart/custom_bar_chart_data.dart';
import 'package:custom_widgets/custom_bar_chart/datetime_extension.dart';
import 'package:flutter/material.dart';

class WeightTrackerView extends StatefulWidget {
  const WeightTrackerView({super.key});

  @override
  State<WeightTrackerView> createState() => _WeightTrackerViewState();
}

class _WeightTrackerViewState extends State<WeightTrackerView> {
  late final PageController pageController;
  BarChartPageData? activePage;
  late final List<BarChartPageData> barChartPages;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  void updateActivePage(int index) {
    setState(() {
      activePage = barChartPages[index];
    });
  }

  void initPage() {
    pageController = PageController();
    barChartPages = [
      BarChartPageData(barChartData: CustomBarChartData.generateDummyList(), page: 0),
      BarChartPageData(
          barChartData: CustomBarChartData.generateDummyList(
            start: DateTime.now().add(
              const Duration(days: 7),
            ),
          ),
          page: 1),
      BarChartPageData(
          barChartData: CustomBarChartData.generateDummyList(
            start: DateTime.now().add(
              const Duration(days: 14),
            ),
          ),
          page: 2),
    ];

    activePage = barChartPages.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            controlButtons(),
            dateRangeText(),
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: barChartPages.length,
                onPageChanged: updateActivePage,
                itemBuilder: (context, index) {
                  return CustomBarChart(
                    datas: barChartPages[index].barChartData ?? const [],
                    barGradient: const LinearGradient(
                      colors: [
                        Color(0xFF5474E8),
                        Colors.white,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    lineColor: const Color(0xFF5474e8),
                    nodeColor: const Color(0xFF7E74FB),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row dateRangeText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (activePage != null) ...{
          Text(activePage!.startDay?.showAsRangeFormat() ?? '-'),
          const SizedBox(
            width: 16,
            height: 1,
            child: ColoredBox(
              color: Colors.red,
            ),
          ),
          Text(activePage!.endDay?.showAsRangeFormat() ?? '-'),
        },
      ],
    );
  }

  Padding controlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filled(
            onPressed: () {
              pageController.previousPage(duration: Durations.short3, curve: Curves.linear);
            },
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton.filled(
            onPressed: () {
              pageController.nextPage(duration: Durations.short3, curve: Curves.linear);
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
