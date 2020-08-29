import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/reports_event.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';

class ReportAnalysisPage extends StatefulWidget {

  final List<Map<String, dynamic>> analysis;
  ReportAnalysisPage({this.analysis});

  @override
  State<StatefulWidget> createState() {
    return ReportAnalysisPageState();
  }
}

class ReportAnalysisPageState extends State<ReportAnalysisPage>{
  final analytics = locator<Analytics>();
  int  currentAnalysisIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentAnalysisIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(title: Strings.report_analysis_page_title, context: context),
      body: Center(
        child: InkWell(
          onTap: () => _switchAnalysis(context),
          child: PieChart(
            dataMap: widget.analysis[currentAnalysisIndex],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar({String title, BuildContext context}) {
    return PlatformAppbar(
      heroTag: "ReportAnalysisPage",
      title: Text(title),
      actions: null,
    ).build(context);
  }

  void _switchAnalysis(BuildContext context) {
    analytics.logEvent(ReportsEvent.click(EVENT_NAME.ACTION_REPORT_ANALYSIS_TAP)
        .setUser(Provider.of<BaseAuth>(context).getCurrentUser().name));

    setState(() {
      if(currentAnalysisIndex == widget.analysis.length-1){
        currentAnalysisIndex = 0;
      } else {
        currentAnalysisIndex++;
      }
    });
  }
}
