import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/ui/platform_alert_dialog.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_contract.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_presenter.dart';
import 'package:tikal_time_tracker/ui/time_picker.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/new_record_event.dart';

// ignore: must_be_immutable
class NewRecordPage extends StatefulWidget {
  List<Project> projects;
  DateTime dateTime;
  TimeRecord timeRecord;

  NewRecordFlow flow;

  NewRecordPage({this.projects, this.dateTime, this.timeRecord, this.flow});

  @override
  State<StatefulWidget> createState() {
    return new NewRecordPageState();
  }
}

class NewRecordPageState extends State<NewRecordPage>
    implements NewRecordViewContract {
  Analytics analytics = Analytics();
  Project _selectedProject;
  TimeOfDay _startTime;
  TimeOfDay _finishTime;
  Duration _duration;
  DateTime _selectedDate;
  TextEditingController startTimeController;
  TextEditingController finishTimeController;
  TextEditingController dateInputController;
  TextEditingController durationInputController;
  TextEditingController commentInputController;
  FocusNode commentFocusNode;
  FocusNode startPickerNode;
  FocusNode endPickerNode;
  bool isSaveButtonEnabled = false;
  TimeRecordsRepository repository = new TimeRecordsRepository();
  NewRecordPresenterContract presenter;

  List<Project> _projects = new List<Project>();

  Task _selectedTask;
  List<Task> _tasks = new List<Task>();

  @override
  void initState() {
    super.initState();
    print("initState: flow ${widget.flow}");
    _projects.addAll(widget.projects);
    _selectedDate = widget.dateTime;
    _setCommentController();
    _setFocusNodes();
    _setPresenter();
    analytics.logEvent(
        NewRecordeEvent.impression(EVENT_NAME.NEW_TIME_PAGE_OPENED).view());
  }

  @override
  void showSaveRecordFailed() {
    // TODO: implement showSaveRecordFailed
  }

  @override
  void showSaveRecordSuccess(TimeRecord timeRecord) {
    analytics.logEvent(
        NewRecordeEvent.impression(EVENT_NAME.RECORD_SAVED_SUCCESS).view());
    Navigator.of(context).pop(timeRecord);
  }

  @override
  initNewRecord() {
    analytics.logEvent(
        NewRecordeEvent.impression(EVENT_NAME.CREATING_NEW_RECORD).view());

//    print("_initNewRecord:");
    startTimeController = new TextEditingController(
      text: "",
    );
    finishTimeController = new TextEditingController(text: "");
    dateInputController = new TextEditingController(text: "");
    if (widget.dateTime != null) {
      _selectedDate = widget.dateTime;
      presenter.dateSelected(_selectedDate);
    }
  }

  @override
  initUpdateRecord() {
    analytics
        .logEvent(NewRecordeEvent.impression(EVENT_NAME.EDITING_RECORD).view());
//    print("_initUpdateRecord: date: ${widget.timeRecord.date.toString()}");
    _selectedDate = widget.timeRecord.date;
    _startTime = widget.timeRecord.start;
    _finishTime = widget.timeRecord.finish;

    presenter.projectSelected(widget.timeRecord.project);
    presenter.taskSelected(widget.timeRecord.task);
    presenter.commentEntered(widget.timeRecord.comment);
    presenter.dateSelected(_selectedDate);
    presenter.startTimeSelected(_startTime);
    presenter.endTimeSelected(_finishTime);

    setState(() {
      TextEditingValue textEditingValue =
          TextEditingValue(text: widget.timeRecord.comment);
      commentInputController.value = textEditingValue;
    });
  }

  @override
  void showSelectedProject(Project value) {
    setState(() {
//      print("_onProjectSelected");
      _selectedProject = value;
    });
  }

  @override
  void showAssignedTasks(List<Task> tasks) {
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  void showSelectedTask(Task value) {
    setState(() {
      _selectedTask = value;
    });
  }

  @override
  void showDuration(Duration duration) {
    setState(() {
      _duration = duration;
      durationInputController = TextEditingController(
          text: _duration == null
              ? ""
              : Utils.buildTimeStringFromDuration(_duration));
    });
  }

  @override
  void setButtonState(bool enabled) {
    setState(() {
      isSaveButtonEnabled = enabled;
    });
  }

  _setCommentController() {
    commentInputController = TextEditingController();
    commentInputController.addListener(() {
      presenter.commentEntered(commentInputController.text);
    });
  }

  _setFocusNodes() {
    commentFocusNode = FocusNode();
    commentFocusNode.addListener(() {
      if (commentFocusNode.hasFocus && commentInputController.text.isEmpty) {
        commentInputController.clear();
      }
    });
    startPickerNode = FocusNode();
    endPickerNode = FocusNode();
    endPickerNode.addListener(() {
      if (!endPickerNode.hasFocus) {
        print("no focus anymore..");
        endPickerNode.unfocus();
        //   FocusScope.of(context).requestFocus(null);
//        endPickerNode.dispose();
      }
    });
  }

  _setPresenter() {
    presenter = NewRecordPresenter(
        repository: repository,
        timeRecord: widget.timeRecord,
        flow: widget.flow);
    presenter.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.drop_down_project_title,
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedProject,
              items: _projects.map((Project value) {
                return new DropdownMenuItem<Project>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Project value) {
                presenter.projectSelected(value);
              }),
        ));

    final tasksDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.drop_down_task_title,
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedTask,
              items: _tasks.map((Task value) {
                return new DropdownMenuItem<Task>(
                  value: value,
                  child: new Text(
                    value.name
                        .toString()
                        .substring(value.toString().indexOf('.') + 1),
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Task value) {
                presenter.taskSelected(value);
              }),
        ));

    final finishTimePicker = TimeTrackerTimePicker(
      pickerName: "finishTimePicker: ",
      initialTimeValue: _finishTime,
      hint: "Finish Time",
      focusNode: endPickerNode,
      callback: (TimeOfDay time) {
        presenter.endTimeSelected(time);
      },
      onSubmitCallback: () {
//      print("finishTimePicker submitted");
        FocusScope.of(context).requestFocus(commentFocusNode);
      },
    );

    final startTimePicker = TimeTrackerTimePicker(
      pickerName: "startTimePicker: ",
      initialTimeValue: _startTime,
      hint: "Start Time",
      focusNode: startPickerNode,
      callback: (TimeOfDay time) {
        presenter.startTimeSelected(time);
      },
      onSubmitCallback: () {
//      print("startTimePicker submitted");
        finishTimePicker.requestFocus(context);
      },
    );

    Widget datePicker = TimeTrackerDatePicker(
        initializedDateTime: _selectedDate,
        onSubmittedCallback: (date) {
//      print("datePicker: callback ${date.toString()}");
          presenter.dateSelected(date);
        });

    final durationInput = Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Container(
            child: new Flexible(
                child: new TextField(
                    enabled: false,
                    controller: durationInputController,
                    decoration: InputDecoration(
                        hintText: Strings.duration_hint,
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1)),
          ),
        ],
      ),
    );

    Widget _saveButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (isSaveButtonEnabled) {
            analytics.logEvent(
                NewRecordeEvent.click(EVENT_NAME.SAVE_RECORD_CLICKED));
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            presenter.saveButtonClicked();
          }
        },
        color: isSaveButtonEnabled ? Colors.orangeAccent : Colors.grey,
        child: Text(Strings.save_button_text,
            style: TextStyle(color: Colors.white)),
      ),
    );

    Widget _deleteButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: RaisedButton(
        onPressed: () {
          _showDeleteAlertDialog();
          analytics.logEvent(
              NewRecordeEvent.click(EVENT_NAME.DELETE_RECORD_CLICKED));
        },
        color: Colors.orangeAccent,
        child: Text(Strings.delete_button_text,
            style: TextStyle(color: Colors.white)),
      ),
    );

    Row _buildButtonsRow() {
      List<Widget> children;
      if (widget.flow == NewRecordFlow.update_record) {
        children = [
          Expanded(
            child: _saveButton,
          ),
          Expanded(
            child: _deleteButton,
          )
        ];
      } else {
        children = [
          Expanded(
            child: _saveButton,
          )
        ];
      }

      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      );
    }

    Widget _commentField = Container(
        padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
        child: TextFormField(
            textInputAction: TextInputAction.done,
            focusNode: commentFocusNode,
            onFieldSubmitted: (comment) {
              if (isSaveButtonEnabled) {
                presenter.saveButtonClicked();
              }
            },
            maxLines: 4,
            controller: commentInputController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                hintText: Strings.note_hint)));

    return Scaffold(
      appBar: PlatformAppbar(
        title: Text(widget.flow == NewRecordFlow.update_record
            ? Strings.edit_record_page_title
            : Strings.new_record_page_title),
      ).build(context),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: ListView(
                  children: <Widget>[
                    new TimeTrackerPageTitle(),
                    projectsDropDown,
                    tasksDropDown,
                    datePicker,
                    startTimePicker,
                    finishTimePicker,
                    durationInput,
                    _commentField
                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(flex: 1, child: _buildButtonsRow())
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _createEmptyDropDown() {
    _tasks.add(_selectedTask);
    return _tasks.map((Task item) {
      //print("item: $item");
      return new DropdownMenuItem<Task>(
        value: item,
        child: new Text(
          item.name,
          style: TextStyle(fontSize: 25.0),
        ),
      );
    }).toList();
  }

  void _showDeleteAlertDialog() {
    PlatformAlertDialog dialog = PlatformAlertDialog(
      title: Strings.delete_alert_title,
      content: Strings.delete_alert_subtitle,
      defaultActionText: "OK",
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(Strings.delete_cancel_text),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            presenter.deleteButtonClicked();
          },
          child: Text(Strings.delete_approve_text),
        )
      ],
    );

    dialog.show(context);
  }

  @override
  void onError(Exception e) {
    print("onError: ${e.toString()}");
    analytics.logEvent(NewRecordeEvent.impression(EVENT_NAME.FAILED_TO_EDIT_OR_SAVE).setDetails(e.toString()).view());
    PlatformAlertDialog dialog = PlatformAlertDialog(
        title: "Edit Record Error",
        content: e is AppException ? e.cause : "There was an error",
        defaultActionText: "OK",
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Strings.ok),
          ),
        ]);
    dialog.show(context);
  }
}

enum NewRecordFlow { new_record, update_record }
