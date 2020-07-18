import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tikal_time_tracker/data/exceptions/errors.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

class DomParser {
  static const String TAG = "DomParser";

  DomParser();

  DateFormat timeFormat = DateFormat('H:m');

  User getUserFromDom(String domStr) {
//    debugPrint("$TAG: domStr: $domStr");

    String pageTitle = domStr.substring(domStr.indexOf("<!-- page title and user details -->"), domStr.indexOf("<!-- end of page title and user details -->"));
    String trtd = "<tr><td>";
    String trtdEnd = "</td></tr>";
    String dash = " - ";
    String comma = ", ";
    String userDetails = pageTitle.substring(pageTitle.indexOf(trtd) + trtd.length);
    userDetails = userDetails.substring(0, userDetails.indexOf(trtdEnd));
    print("UserDetails: $userDetails");

    String name = userDetails.substring(0, userDetails.indexOf(dash));
    String roleStr = userDetails.substring(userDetails.indexOf(dash) + dash.length, userDetails.indexOf(comma));
    Role role = _getRoleFromRoleString(roleStr);
    String company = userDetails.substring(userDetails.indexOf(comma) + 1);
    print("$TAG: name: $name, role: $role, company: $company");
    List<Task> tasks = _extractTasks(domStr);
    List<Project> projects = _extractProjectsForUser(domStr, tasks);

    List<Remote> remotes = _extractRemoteFromDom(domStr);
    return User.builder(name, role, company, projects, tasks, remotes);
  }

  List<Project> _extractProjectsForUser(String domStr, List<Task> tasks) {
    List<Project> projects = _extractProjects(domStr);

    Map<int, List<int>> tasksForProjects = _extractTasksForProjects(domStr, projects);

//    debugPrint("_extractTasks: $domStr");

    projects.forEach((p) {
      List<Task> tasksForProj = List<Task>();
//      print("getUserFromDom: p = ${p.name}:${tasksForProjects[p.value]}");
      tasksForProjects[p.value].forEach((t) {
        Task task = tasks.firstWhere((e) {
//          print("firstWhere: $t -> ${e.value}:${e.name}");
          return (e.value == t);
        }, orElse: () => null);
        if (task != null) {
          tasksForProj.add(task);
        }
      });
//      print("getUserFromDom: tasksForProj ${p.name} : ${tasksForProj.toString()}");
      p.tasks = tasksForProj;
    });

//    print("getUserFromDom: ${projects.toString()}");
    return projects;
  }

  List<Project> _extractProjects(String domStr) {
    String firstDelimiter = "var projects = new Array();";
    String secondDelimiter = "// Prepare an array of task ids for projects";
    String buffer = domStr.substring(domStr.indexOf(firstDelimiter) + firstDelimiter.length, domStr.indexOf(secondDelimiter));

    List<String> projects = buffer.split("projects[idx] = new Array(");

    projects.removeAt(0);

    projects = projects.map((it) {
      return it.substring(0, it.indexOf("\");"));
    }).toList();

    // print("_extractProjects: ${projects.toString()}");

    List<Project> result = projects.map((projectStr) {
      String container = projectStr.replaceAll("\"", "");
      List<String> m = container.split(",");
      print("${m[0].trim()}:${m[1].trim()}");
      String name = m[1].trim();
      String value = m[0].trim();

      int val = int.tryParse(value);

      return Project(name: name, value: val);
    }).toList();
    //  print("_extractProjects result: ${result.toString()}");
    return result;
  }

  List<Task> _extractTasks(String domStr) {
    String startBuffer = "var task_names = new Array();";
    String endBuffer = "// Prepare an array of template";
//    String endBuffer = "// Mandatory top options"; //Old version TimeTracker
    String tasksStart = domStr.substring(domStr.indexOf(startBuffer) + startBuffer.length + 1, domStr.indexOf(endBuffer));
    List<String> tasksList = tasksStart.split(";");

//    debugPrint("_extractTasks: $domStr" );
    tasksList.removeLast();

    List<Task> tasks = tasksList.map((taskStr) {
      String delimiter = "[";
      int value = int.tryParse(taskStr.substring(taskStr.indexOf(delimiter) + 1, taskStr.indexOf("]")));
      String name = taskStr.replaceAll("\"", "").substring(taskStr.indexOf("= ") + 2).trim();
      return Task(name: name, value: value);
    }).toList();
//    print("_extractTasks: ${tasks.toString()}");
    return tasks;
  }

  Map<int, List<int>> _extractTasksForProjects(String domStr, List<Project> projects) {
    String startDelimiter = "var task_ids = new Array()";
    String endDelimiter = "// Prepare an array of task names.";

    String container = domStr.substring(domStr.indexOf(startDelimiter) + startDelimiter.length, domStr.indexOf(endDelimiter));
//    print("_extractTasksForProjects: container $container");

    List<String> l = container.split(";");
    l.removeAt(0);
    l.removeLast();
//    print("_extractTasksForProjects: $l");

    Map<int, List<int>> projectsAndTasks = Map<int, List<int>>();
    l.forEach((it) {
//      print("_extractTasksForProjects: ${it.substring(it.indexOf("[") + 1, it.indexOf("]"))}");
      int prjVal = int.tryParse(it.substring(it.indexOf("[") + 1, it.indexOf("]")));
      List<int> tasks = it.substring(it.indexOf(" = ") + 3).replaceAll("\"", "").split(",").map((it) {
        return int.tryParse(it.trim());
      }).toList();

      tasks.remove(14); //There is no task 14
//      print("_extractTasksForProjects: tasks ${tasks.toString()}");

      projectsAndTasks[prjVal] = tasks;
    });

//    print("_extractTasksForProjects ${projectsAndTasks.toString()}");
    return projectsAndTasks;
  }

  List<Remote> _extractRemoteFromDom(String domStr) {
    debugPrint("starting _extractRemoteFromDom: ");

    String firstDelimiter = 'id="time_field_5"';
    String secondDelimiter = '</select>';
    String buffer = domStr.substring(domStr.indexOf(firstDelimiter) + firstDelimiter.length, domStr.indexOf(secondDelimiter)).trim();

    buffer = buffer.substring(buffer.indexOf('</option>') + '</option>'.length).trim();
    List<String> remoteRows = buffer.split('\n');

    List<Remote> remotes = remoteRows.map((r) {
      debugPrint("parsing: $r ...");
      String valueStartBuffer = '<option value="';
      String valueEndBuffer = '"';
      var value = r.substring(r.indexOf(valueStartBuffer) + valueStartBuffer.length);
      value = value.substring(0, value.indexOf(valueEndBuffer));

      String nameStartBuffer = '>';
      String nameEndBuffer = '<';
      String name = r.substring(r.indexOf(nameStartBuffer) + nameStartBuffer.length);

      name = name.substring(0, name.indexOf(nameEndBuffer));
      return Remote(value: int.parse(value), name: name.trim());
    }).toList();

//    print("getUserFromDom: ${projects.toString()}");
    return remotes;
  }

  TimeReport parseTimePage(String timeDomStr) {
    String start = "<table border=\"0\" cellpadding=\"3\" cellspacing=\"1\" width=\"100%\">";
    String stop = "</table>";
    String buffer = timeDomStr.substring(timeDomStr.indexOf(start) + start.length);
    buffer = buffer.substring(0, buffer.indexOf(stop));

//    debugPrint("parseTimePage $timeDomStr");

    DateTime date = _extractDateTime(timeDomStr);

    List<String> rows = buffer.trim().split("<tr");
    rows.removeAt(0);
    rows.removeAt(0);
    //debugPrint("$TAG rows: ${rows.toString()}, size: ${rows.length}");

    try {
      rows = rows.map((r) {
        return r.substring(r.indexOf(">") + 1, r.indexOf("</tr>"));
      }).toList();
    } on RangeError catch (e) {
      print("There was a RangeError, return empty report: ${e.message}");
      return TimeReport(date: date, timeReport: List<TimeRecord>());
    }

    List<TimeRecord> result = rows.map((row) {
      List<String> cells = row.split("</td>");

      cells = cells.map((it) {
        return it.substring(it.indexOf(">") + 1);
      }).toList();
//     debugPrint("cells: ${cells.toString()}, size: ${cells.length}");

      Task task = User.me.tasks.firstWhere((it) {
//        print("firstWhere: ${it.name}:${cells[1]}");
        return it.name == cells[1];
      });

      TimeOfDay start;
      try {
        start = TimeOfDay.fromDateTime(timeFormat.parse(cells[2]));
      } catch (e) {
        if (e is FormatException) {
          start = null;
        }
      }
      TimeOfDay finish;
      try {
        finish = TimeOfDay.fromDateTime(timeFormat.parse(cells[3]));
      } catch (e) {
        if (e is FormatException) {
          finish = null;
        }
      }

//      .substring(cells[6].indexOf("id=")+1, cells[6].indexOf("\">"))
      int trackerId = int.parse(cells[6].substring(cells[6].indexOf("id=") + 3, cells[6].indexOf("\">")).trim());
//      print("trackerId: $trackerId");

      Project project = User.me.projects.firstWhere((it) {
        return it.name == cells[0];
      });

      return TimeRecord(id: trackerId, project: project, task: task, start: start, date: date, finish: finish, comment: cells[5].trim().replaceAll("&nbsp;", ""));
    }).toList();

    Duration dayTotal = parseTotalValue(timeDomStr, "Day total:");
    Duration weekTotal = parseTotalValue(timeDomStr, "Week total:");
    Duration monthTotal = parseTotalValue(timeDomStr, "Month total:");

    String remainQuotaNeedle = "Remaining quota:";
    String overQuotaNeedle = "Over quota:";
    bool overQuota = false;

    Duration remainTotal;

    if (timeDomStr.contains(overQuotaNeedle)) {
      overQuota = true;
      remainTotal = parseOverQuota(timeDomStr, overQuotaNeedle);
    } else {
      remainTotal = parseRemainQuote(timeDomStr, remainQuotaNeedle);
    }

    String message = null;
    if (timeDomStr.contains("Time interval overlaps")) {
      message = Strings.interval_overlap;
    }
    TimeReport report = TimeReport(timeReport: result, dayTotal: dayTotal, weekTotal: weekTotal, monthTotal: monthTotal, quota: remainTotal, overQuota: overQuota, message: message);
    return report;
  }

  DateTime _extractDateTime(String domStr) {
    String pageTitleStart = "<!-- page title and user details -->";
    String pageTitleEnd = "<!-- end of page title and user details -->";

    String timeStr = domStr.substring(domStr.indexOf(pageTitleStart) + pageTitleStart.length);
    timeStr = timeStr.substring(0, timeStr.indexOf(pageTitleEnd));

    timeStr = timeStr.substring(timeStr.indexOf("Time: ") + 6, timeStr.indexOf("</div>"));
//    print("_extractDateTime: $timeStr");
    DateFormat formatter = DateFormat("y-MM-d");
    return formatter.parse(timeStr.trim());
  }

  List<Member> parseUsersPage(String domStr, Role myRole) {
    String start = "<table cellspacing=\"1\" cellpadding=\"3\" border=\"0\" width=\"100%\">";
    String end = "</table>";
    String span = "</span>";

    String buffer = domStr.substring(domStr.indexOf(start) + start.length);
    buffer = buffer.substring(0, buffer.indexOf(end));

    List<String> rows = buffer.split("</tr>");
    rows.removeAt(0);
    if (myRole != Role.User) {
      rows.removeAt(0);
    }
    rows.removeLast();

    List<Member> members = rows.map((r) {
      List<String> cells = r.substring(r.indexOf("<td>")).split("</td>");
      cells = cells.map((cell) {
        return cell.substring(cell.indexOf("<td>") + 4);
      }).toList();

      cells.removeLast();
      //First cell (user name) should be stripped explicitly
      cells[0] = cells[0].substring(cells[0].indexOf(span) + span.length).trim();
//      print("parseUsersPage: buffer:  $cells");
      if (myRole != Role.User) {
        return createMemberForManager(cells);
      }

      Role role = _getRoleFromRoleString(cells[2]);
      return Member(name: cells[0], email: cells[1], role: role, hasIncompleteEntry: false);
    }).toList();

//     print("members: ${members.toString()}");
    return members;
  }

  Member createMemberForManager(List<String> cells) {
    String name;
    bool hasIncompleteEntry = false;

    if (cells[0].contains("User has an uncompleted time entry")) {
      hasIncompleteEntry = true;
    }
    name = cells[0].substring(cells[0].indexOf("span>") + 5).trim();
    debugPrint("user: ${cells[0]}");
    Role role = _getRoleFromRoleString(cells[2]);
    return Member(name: name, email: cells[1], role: role, hasIncompleteEntry: hasIncompleteEntry);
  }

  List<TimeRecord> parseReportPage(String domStr, Role role) {
//     print("parseReportPage: $domStr");
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formStart = "<form name=\"reportForm\" method=\"post\">";
    String formEnd = "</form>";
    String reportStart = "-- normal report -->";
    String reportEnd = "</table>";
    String buffer = domStr.substring(domStr.indexOf(formStart) + formStart.length, domStr.indexOf(formEnd));
//    debugPrint("parseReportPage: $buffer");

    buffer = buffer.substring(buffer.indexOf(reportStart) + reportStart.length);
    buffer = buffer.substring(0, buffer.indexOf(reportEnd));

    List<String> rows = buffer.split("</tr>");

    rows.removeAt(0);
    rows.removeLast();
    rows.removeLast();
    rows.removeLast();

    List<TimeRecord> records = rows.map((row) {
      List<String> cells = row.substring(row.indexOf("<td ")).split("</td>");
      cells.removeLast();
      cells = cells.map((cell) {
        cell = cell.substring(cell.indexOf("<td") + 3);
        return cell.substring(cell.indexOf(">") + 1);
      }).toList();

//      print("parseReportPage: cells ${cells.toString()}");

      DateTime dateTime = dateFormat.parse(cells[0]);
      Project project;
      Task task;
      String userName;

      int cellsOffset = 0;
      switch (role) {
        case Role.User:
          {
//            print("parsing for User");
            project = User.me.projects.firstWhere((it) {
              return it.name == cells[1 + cellsOffset];
            });

            task = User.me.tasks.firstWhere((it) {
              return it.name == cells[2 + cellsOffset];
            });
            break;
          }
        default:
          {
//            print("parsing for Manager");
            cellsOffset = 1;
            userName = cells[1];
            project = Project(name: cells[1 + cellsOffset]);
            task = Task(name: cells[2 + cellsOffset]);
            break;
          }
      }

      TimeOfDay start;

      try {
        start = TimeOfDay.fromDateTime(timeFormat.parse(cells[3 + cellsOffset]));
      } catch (e) {
        if (e is FormatException) {
          start = null;
        }
      }

      TimeOfDay finish;

      try {
        finish = TimeOfDay.fromDateTime(timeFormat.parse(cells[4 + cellsOffset]));
      } catch (e) {
        if (e is FormatException) {
          finish = null;
        }
      }

      Duration d;
      if (start == null && finish == null) {
        TimeOfDay duration = TimeOfDay.fromDateTime(timeFormat.parse(cells[5 + cellsOffset]));
        d = Duration(hours: duration.hour, minutes: duration.minute);
      }

      return TimeRecord(date: dateTime, project: project, task: task, start: start, finish: finish, duration: d, comment: cells[6].trim().replaceAll("&nbsp;", ""), userName: userName);
    }).toList();

//    print("parseReportPage: ${records.toString()}");
    return records;
  }

  String parseResetPasswordResponse(String response) {
    if (response.contains("Password reset request sent by email")) {
      return "Password reset request sent by email";
    } else if (response.contains("No user with this login")) {
      return "No user with this login";
    } else {
      return "Failed to reset password";
    }
  }

  String parseSaveAndAddTimeResponse(String response) {
    final String errorTdStart = "<td class=\"error\">";
    if (response.indexOf(errorTdStart) > 0) {
      String buffer = response.substring(response.indexOf(errorTdStart) + errorTdStart.length);
      buffer = buffer.substring(0, buffer.indexOf("<br>")).trim();
      print("parseSaveAndAddTimeResponse: Error: $buffer");
      if (buffer.isNotEmpty) {
        if (buffer.contains(uncompletedExistsError)) {
          String idStart = buffer.substring(buffer.indexOf("?") + 4);
          idStart = idStart.substring(0, idStart.indexOf("\'"));
          print("parseSaveAndAddTimeResponse: incompleteId: ${int.parse(idStart)}");
          final e = IncompleteRecordException(cause: buffer.trim().substring(0, buffer.indexOf("<a href")).trim(), recordId: int.parse(idStart));
          throw e;
        }

        final e = AppException(cause: buffer);
        throw e;
      }
    }

    return response;
  }

  List<Member> parseGenerateReportPage(String apiResponse) {
    String buffer = apiResponse.substring(apiResponse.indexOf(">Deselect all"), apiResponse.indexOf("function setAllusers(value)"));
    String tableStart = "100%\">";
    buffer = buffer.substring(buffer.indexOf(tableStart) + tableStart.length, buffer.indexOf("</table>")).trim();
    List<String> trs = buffer.split("<tr>");
    debugPrint("tr: $trs");

    trs.removeAt(0);
    trs = trs.map((tr) {
      tr = tr.substring(0, tr.indexOf("</tr>")).trim();
      return tr;
    }).toList();

    List<Member> members = List();

    trs.forEach((tds) {
      List<String> b = tds.split("</td>");
      b.removeLast();
      print("$b: ${b.length}");
      b.forEach((cb) {
        Member member = _getMemberFromCheckbox(cb.trim());
        if (member != null) {
          members.add(member);
        }
//        print(member.toString());
      });
    });

//    print("${members.length}, ${members.toString()}");
    return members;
  }

  Role _getRoleFromRoleString(String roleStr) {
    switch (roleStr) {
      case "Manager":
        {
          return Role.Manager;
        }
      case "Co-Manager":
        {
          return Role.CoManager;
        }
      case "Top-Manager":
        {
          return Role.TopManager;
        }
      case "User":
        {
          return Role.User;
        }
      default:
        {
          return Role.User;
        }
    }
  }

  Member _getMemberFromCheckbox(String cbString) {
    print("_getMemberFromCheckbox: $cbString");

    String name;
    int value;
    String id;

    if (!cbString.contains("type=\"checkbox\"")) {
      return null;
    }

    if (cbString.contains("checked")) {
      id = cbString.substring(cbString.indexOf("id=\"") + 4, cbString.indexOf("checked=") - 2);
    } else {
      id = cbString.substring(cbString.indexOf("id=\"") + 4, cbString.indexOf("value=") - 2);
    }

    String needle = "value=\"";
    var b = cbString.substring(cbString.indexOf(needle) + needle.length);
    b = b.substring(0, b.indexOf("\""));
    value = int.parse(b);
    String lableDelimiter = "<label for=";
    b = cbString.substring(cbString.indexOf(lableDelimiter) + 1);
    name = b.substring(b.indexOf(">") + 1, b.indexOf("<"));
//    print("_getMemberFromCheckbox: id : $id, value: $value, name: $name");

    return Member(id: id, value: value, name: name);
  }

  SendEmailForm parseSendEmailPage(String response) {
    String formStart = "<form name=\"mailForm\" method=\"post\">";
    String formEnd = "form>";
    String formTableStart = " <table cellspacing=\"4\" cellpadding=\"7\" border=\"0\">";
    String formBuffer = response.substring(response.indexOf(formStart));
    formBuffer = formBuffer.substring(0, formBuffer.indexOf(formEnd));
    formBuffer = formBuffer.substring(formBuffer.indexOf(formTableStart) + formTableStart.length);

    String toStringStartTitle = "<td align=\"right\">To (*):<\/td>";
    String toString = formBuffer.substring(formBuffer.indexOf(toStringStartTitle) + toStringStartTitle.length);
    toString = toString.substring(toString.indexOf("value=\"") + 7, toString.indexOf("\">"));

    String ccStringStartTitle = "<td align=\"right\">Cc:<\/td>";
    String ccString = formBuffer.substring(formBuffer.indexOf(ccStringStartTitle) + ccStringStartTitle.length);
    ccString = ccString.substring(ccString.indexOf("value=\"") + 7, ccString.indexOf("\">"));

    String subjectStringStartTitle = "<td align=\"right\">Subject (*):<\/td>";
    String subjectString = formBuffer.substring(formBuffer.indexOf(subjectStringStartTitle) + subjectStringStartTitle.length);
    subjectString = subjectString.substring(subjectString.indexOf("value=\"") + 7, subjectString.indexOf("\">"));

//    debugPrint("parseSendEmailPager: page body: $formBuffer");
    return SendEmailForm(to: toString, cc: ccString, subject: subjectString);
  }

  String parseSendEmailResponse(String response) {
    debugPrint("parseSendEmailResponse: $response");
    if (response.contains("Report sent")) {
      return "Report sent";
    } else {
      return "Failed to sent report";
    }
  }

  Duration parseTotalValue(String response, String needle) {
    Duration dayTotal;
    String buffer = response;
    if (response.contains(needle)) {
      buffer = response.substring(response.indexOf(needle) + needle.length);
      buffer = buffer.substring(0, buffer.indexOf("<")).trim();
      var totalArray = buffer.split(":");
      String totalHour = totalArray[0];
      String totalMinutes = totalArray[1];
      dayTotal = new Duration(hours: int.parse(totalHour), minutes: int.parse(totalMinutes));
    } else {
      dayTotal = Duration(hours: 0, minutes: 0);
    }

    print("$needle: ${dayTotal.toString()}");
    return dayTotal;
  }

  Duration parseRemainQuote(String response, String needle) {
    Duration dayTotal;
    String buffer = response;
    if (response.contains(needle)) {
      buffer = response.substring(response.indexOf(needle) + needle.length);
      if (buffer.contains("red;\">")) {
        buffer = buffer.substring(buffer.indexOf("red;\">") + "red;\">".length);
      }
      buffer = buffer.substring(0, buffer.indexOf("<")).trim();
      var totalArray = buffer.split(":");
      String totalHour = totalArray[0];
      String totalMinutes = totalArray[1];
      dayTotal = new Duration(hours: int.parse(totalHour), minutes: int.parse(totalMinutes));
    } else {
      dayTotal = Duration(hours: 0, minutes: 0);
    }

    print("$needle: ${dayTotal.toString()}");
    return dayTotal;
  }

  Duration parseOverQuota(String response, String needle) {
    Duration dayTotal;
    String buffer = response;
    if (response.contains(needle)) {
      buffer = response.substring(response.indexOf(needle) + needle.length);
      if (buffer.contains("green;\">")) {
        buffer = buffer.substring(buffer.indexOf("green;\">") + "green;\">".length);
      }
      buffer = buffer.substring(0, buffer.indexOf("<")).trim();
      var totalArray = buffer.split(":");
      String totalHour = totalArray[0];
      String totalMinutes = totalArray[1];
      dayTotal = new Duration(hours: int.parse(totalHour), minutes: int.parse(totalMinutes));
    } else {
      dayTotal = Duration(hours: 0, minutes: 0);
    }

    print("$needle: ${dayTotal.toString()}");
    return dayTotal;
  }

  Future<DateTime> parseIncompleteRecordResponse(String response) async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String dateNeedle = "id=\"date\"";
    String valueNeedle = "value=\"";
    String buffer = response.substring(response.indexOf(dateNeedle) + dateNeedle.length);
    buffer = buffer.substring(buffer.indexOf(valueNeedle) + valueNeedle.length);
    String recordDate = buffer.substring(0, buffer.indexOf("\""));
    debugPrint("parseIncompleteRecordResponse: $recordDate");
    return dateFormat.parse(recordDate);
  }
}
