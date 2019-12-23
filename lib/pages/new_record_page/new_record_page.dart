import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page_event.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_state_model.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
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
import 'package:tikal_time_tracker/pages/new_record_page/new_record_bloc.dart';
import 'package:tikal_time_tracker/ui/time_picker.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/new_record_event.dart';

class NewRecordPage extends StatefulWidget {
  final NewRecordPageBloc bloc;

  NewRecordPage({this.bloc});

  @override
  State<StatefulWidget> createState() {
    return new NewRecordPageState();
  }

  static Widget create(List<Project> projects, TimeRecord timeRecord) {
    return Consumer<BaseAuth>(
      builder: (context, auth, _) => Provider<NewRecordPageBloc>(
        create: (context) => NewRecordPageBloc(
          locator<Analytics>(),
          projects,
          timeRecord,
          repository: locator<AppRepository>(),
        ),
        child: Consumer<NewRecordPageBloc>(
          builder: (context, bloc, _) => NewRecordPage(bloc: bloc),
        ),
        dispose: (context, bloc) => bloc.dispose(),
      ),
    );
  }
}

class NewRecordPageState extends State<NewRecordPage> {
  TextEditingController startTimeController =
      new TextEditingController(text: "");
  TextEditingController finishTimeController =
      new TextEditingController(text: "");
  TextEditingController dateInputController =
      new TextEditingController(text: "");
  TextEditingController durationInputController =
      new TextEditingController(text: "");
  TextEditingController commentInputController =
      new TextEditingController(text: "");
  FocusNode commentFocusNode;
  FocusNode startPickerNode;
  FocusNode endPickerNode;

  @override
  void initState() {
    super.initState();
    _setCommentController();
    _setFocusNodes();
  }

  @override
  initUpdateRecord() {
//    print("_initUpdateRecord: date: ${widget.timeRecord.date.toString()}");
//    _selectedDate = widget.timeRecord.date;
//    _startTime = widget.timeRecord.start;
//    _finishTime = widget.timeRecord.finish;
//
//    print("initUpdateRecord: ${widget.timeRecord.project}");
//    var p = _projects.firstWhere((p) {
//      return p.value == widget.timeRecord.project.value;
//    });
//    presenter.projectSelected(p);
//    presenter.taskSelected(widget.timeRecord.task);
//    presenter.commentEntered(widget.timeRecord.comment);
//    presenter.dateSelected(_selectedDate);
//    presenter.startTimeSelected(_startTime);
//    presenter.endTimeSelected(_finishTime);
  }

//  @override
//  void showDuration(Duration duration) {
//    setState(() {
//      durationInputController = TextEditingController(
//          text: _duration == null
//              ? ""
//              : Utils.buildTimeStringFromDuration(_duration));
//    });
//  }

  _setCommentController() {
    commentInputController = TextEditingController();
    commentInputController.addListener(() => widget.bloc
        .dispatchEvent(OnComment(comment: commentInputController.text)));
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

  Row _buildButtonsRow(NewRecordStateModel newRecordStateModel) {
    List<Widget> children;
    if (newRecordStateModel.flow == NewRecordFlow.update_record) {
      children = [
        Expanded(
          child: _buildSaveButton(newRecordStateModel),
        ),
        Expanded(
          child: _buildDeleteButton(),
        )
      ];
    } else {
      children = [
        Expanded(
          child: _buildSaveButton(newRecordStateModel),
        )
      ];
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  void _updateFieldsValues(NewRecordStateModel stateModel) {
    commentInputController.text = stateModel.timeRecord.comment;
    durationInputController.text = stateModel.timeRecord.duration == null
        ? ""
        : Utils.buildTimeStringFromDuration(stateModel.timeRecord.duration);
  }

  Widget buildPageBody(
      AsyncSnapshot<NewRecordStateModel> snapshot,
      BuildContext context,
      Row _buildButtonsRow(NewRecordStateModel newRecordStateModel)) {
    print("buildPageBody: ");
    _updateFieldsValues(snapshot.data);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: ListView(
              children: <Widget>[
                new TimeTrackerPageTitle(),
                buildProjectsDropDown(snapshot.data),
                buildTasksDropDown(snapshot.data),
                buildDatePicker(snapshot.data),
                buildStartTimePicker(context, snapshot.data),
                buildFinishTimePicker(context, snapshot.data),
                buildDurationField(),
                buildCommentField(snapshot.data)
              ],
            ),
          ),
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(flex: 1, child: _buildButtonsRow(snapshot.data))
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<NewRecordPageBloc>(context);
    return StreamBuilder<NewRecordStateModel>(
      stream: bloc.stateStream,
      initialData: NewRecordStateModel(),
      builder: (context, snapshot) {
        print(
            "NewRecordPage builder: snapshot => ${snapshot.connectionState}, ${snapshot.data}");
        return Scaffold(
          appBar: PlatformAppbar(
            title: Text(snapshot.data.flow == NewRecordFlow.update_record
                ? Strings.edit_record_page_title
                : Strings.new_record_page_title),
          ).build(context),
          body: SafeArea(
            child: buildPageBody(snapshot, context, _buildButtonsRow),
          ),
        );
      },
    );
  }

  Container buildDurationField() {
    return Container(
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
  }

  Container buildCommentField(NewRecordStateModel stateModel) {
    return Container(
        padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
        child: TextFormField(
            textInputAction: TextInputAction.done,
            focusNode: commentFocusNode,
            onFieldSubmitted: (comment) {
              if (stateModel.formOk) {
                widget.bloc.dispatchEvent(OnSaveButtonClicked(context: context));
              }
            },
            maxLines: 4,
            controller: commentInputController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                hintText: Strings.note_hint)));
  }

  Padding _buildDeleteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: RaisedButton(
        onPressed: () {
          _showDeleteAlertDialog();
//        analytics.logEvent(
//            NewRecordeEvent.click(EVENT_NAME.DELETE_RECORD_CLICKED).setUser(User.me.name));
        },
        color: Colors.orangeAccent,
        child: Text(Strings.delete_button_text,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Padding _buildSaveButton(NewRecordStateModel stateModel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (stateModel.formOk) {
            print("_buildSaveButton: ");
//          analytics.logEvent(
//              NewRecordeEvent.click(EVENT_NAME.SAVE_RECORD_CLICKED));
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            widget.bloc.dispatchEvent(OnSaveButtonClicked(context: context));
          }
        },
        color: stateModel.formOk ? Colors.orangeAccent : Colors.grey,
        child: Text(Strings.save_button_text,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  TimeTrackerDatePicker buildDatePicker(NewRecordStateModel stateModel) {
    print("buildDatePicker: ${stateModel.timeRecord.date}");
    return TimeTrackerDatePicker(
        initializedDateTime: stateModel.timeRecord.date,
        onSubmittedCallback: (date) =>
            widget.bloc.dispatchEvent(OnDateSelected(selectedDate: date)));
  }

  TimeTrackerTimePicker buildStartTimePicker(
      BuildContext context, NewRecordStateModel stateModel) {
    print("buildStartTimePicker: ${stateModel.timeRecord.start}");
    return TimeTrackerTimePicker(
      pickerName: "startTimePicker: ",
      initialTimeValue: stateModel.timeRecord.start,
      hint: "Start Time",
      onTimeSelected: (TimeOfDay time) =>
          widget.bloc.dispatchEvent(OnStartTime(selectedTime: time)),
      onNowButtonClicked: () =>
          {widget.bloc.dispatchEvent(OnNowButtonClicked())},
    );
  }

  TimeTrackerTimePicker buildFinishTimePicker(
      BuildContext context, NewRecordStateModel stateModel) {
    return TimeTrackerTimePicker(
        pickerName: "finishTimePicker: ",
        initialTimeValue: stateModel.timeRecord.finish,
        hint: "Finish Time",
        onTimeSelected: (TimeOfDay time) => {
              widget.bloc.dispatchEvent(OnFinishTime(selectedTime: time)),
              FocusScope.of(context).requestFocus(commentFocusNode)
            },
        onNowButtonClicked: () =>
            {widget.bloc.dispatchEvent(OnNowButtonClicked())});
  }

  Container buildTasksDropDown(NewRecordStateModel stateModel) {
    return Container(
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
              value: stateModel.timeRecord.task,
              items: stateModel.tasks.map((Task value) {
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
              onChanged: (Task value) => widget.bloc
                  .dispatchEvent(OnSelectedTask(selectedTask: value))),
        ));
  }

  Container buildProjectsDropDown(NewRecordStateModel newRecordStateModel) {
    print("buildProjectsDropDown: ${newRecordStateModel.projects}");
    return Container(
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
              value: newRecordStateModel.timeRecord.project,
              items: newRecordStateModel.projects.map((Project value) {
                return new DropdownMenuItem<Project>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Project value) => widget.bloc.dispatchEvent(OnSelectedProject(selectedProject: value))),
        ));
  }

  void _showDeleteAlertDialog() {
    PlatformAlertDialog dialog = PlatformAlertDialog(
      title: Strings.delete_alert_title,
      content: Strings.delete_alert_subtitle,
      defaultActionText: "OK",
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Strings.delete_cancel_text),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            widget.bloc.dispatchEvent(OnDeleteButtonClicked(context: context));
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
//    analytics.logEvent(
//        NewRecordeEvent.impression(EVENT_NAME.FAILED_TO_EDIT_OR_SAVE)
//            .setUser(User.me.name)
//            .setDetails(e is AppException ? e.cause : e.toString())
//            .view());
  }
}

enum NewRecordFlow { new_record, update_record }
