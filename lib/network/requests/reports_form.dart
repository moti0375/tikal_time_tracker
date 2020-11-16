import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/utils/formatters.dart';
class ReportForm{

  String favoriteReport;
  Project project;
  Task task;
  Period period;
  DateTime startDate;
  DateTime endDate;
  int chProject = 1;
  int chTask = 1;
  int chStart = 1;
  int chFinish = 1;
  int chNote = 1;
  List<Member> members;

  ReportForm({this.project, this.task, this.startDate, this.endDate, this.period, this.members});

  @override
  String toString() {
    return 'ReportForm{favoriteReport: $favoriteReport, project: $project, task: $task, period: $period, startDate: $startDate, endDate: $endDate, chProject: $chProject, chTask: $chTask, chStart: $chStart, chFinish: $chFinish, chNote: $chNote, members: $members}';
  }


  Map<String, dynamic> toMap() {
//    print("form serializer: toMap: ${form.toString()}");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["start_date"] = dateFormat.format(this.startDate);
    map["end_date"] = dateFormat.format(this.endDate);
    map["project"] = this.project == null ? "" : "${this.project.value}";
    map["task"] = this.task == null ? "" : "${this.task.value}";
    map["period"] = "${this.period.value}";
    map["chduration"] = "1";
    map["chnote"] = "1";
    map["chclient"] = "1";
    map["chinvoice"] = "0";
    map["chpaid"] = "0";
    map["chip"] = "0";
    map["chcost"] = "0";
    map["chstart"] = "1";
    map["chfinish"] = "1";
    map["chproject"] = "1";
    map["chtask"] = "1";
    map["chtotalsonly"] = "0";
    map["chcf_1"] = "0";
    map["chunits"] = "0";
    map["fav_report_changed"] = "";
    map["btn_generate"] = "Generate";
    map["group_by"] = "no_grouping";


    if(this.members != null){
      String usersArray = this.members.map((member){
        print("processing: ${member.toString()}");
        return "'${member.id.split("_").last}'";
      }).toList().toString();

      usersArray = usersArray.toString().substring(1, usersArray.toString().length-1);
      map["users[]"] = usersArray;
    }

//    print("form serializer: membersJson: ${map.toString()}");

    return map;
  }

}