import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
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
      appBar: _buildAppBar(title: "Report Analysis", context: context),
      body: Center(
        child: InkWell(
          onTap: _switchAnalysis,
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

  void _switchAnalysis() {
    setState(() {
      if(currentAnalysisIndex == widget.analysis.length-1){
        currentAnalysisIndex = 0;
      } else {
        currentAnalysisIndex++;
      }
    });
  }
}
