import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_bloc.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page_event.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_state_model.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/ui/platform_alert_dialog.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/ui/time_picker.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class NewRecordPage extends StatefulWidget {
  final NewRecordPageBloc bloc;

  NewRecordPage({this.bloc});

  @override
  State<StatefulWidget> createState() {
    return new NewRecordPageState();
  }

  static Widget create(
      List<Project> projects, TimeRecord timeRecord, DateTime date) {
    return Consumer<BaseAuth>(
      builder: (context, auth, _) => Provider<NewRecordPageBloc>(
        create: (context) => NewRecordPageBloc(
          locator<Analytics>(),
          projects,
          timeRecord,
          date,
          auth: auth,
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
  TextEditingController durationInputController =
      new TextEditingController(text: Strings.empty_string);
  TextEditingController commentInputController =
      new TextEditingController(text: Strings.empty_string);
  FocusNode commentFocusNode;

  @override
  void initState() {
    super.initState();
    _setCommentController();
    _setFocusNodes();
  }

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
        ? Strings.empty_string
        : Utils.buildTimeStringFromDuration(stateModel.timeRecord.duration);
  }

  Widget buildPageBody(
      AsyncSnapshot<NewRecordStateModel> snapshot,
      BuildContext context,
      Row _buildButtonsRow(NewRecordStateModel newRecordStateModel)) {
    _updateFieldsValues(snapshot.data);
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          new TimeTrackerPageTitle(),
          Expanded(
            child: ListView(
              children: <Widget>[
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
          _buildButtonsRow(snapshot.data)
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
                Utils.hideSoftKeyboard(context);
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
      child: AnimationButton(
        onPressed: () => _showDeleteAlertDialog,
        buttonText: Strings.delete_button_text,
      ),
    );
  }

  Padding _buildSaveButton(NewRecordStateModel stateModel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: AnimationButton(
        onPressed: stateModel.formOk
            ? () {
                if (stateModel.formOk) {
                  Utils.hideSoftKeyboard(context);
                  widget.bloc
                      .dispatchEvent(OnSaveButtonClicked(context: context));
                }
              }
            : null,
        buttonText: Strings.save_button_text,
      ),
    );
  }

  TimeTrackerDatePicker buildDatePicker(NewRecordStateModel stateModel) {
    print("buildDatePicker: ${stateModel.timeRecord.date}");
    return TimeTrackerDatePicker(
      initializedDateTime: stateModel.timeRecord.date,
      onSubmittedCallback: (date) =>
          widget.bloc.dispatchEvent(OnDateSelected(selectedDate: date)),
    );
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
      onNowButtonClicked: () => widget.bloc.dispatchEvent(OnNowButtonClicked()),
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
      onNowButtonClicked: () => widget.bloc.dispatchEvent(OnNowButtonClicked()),
    );
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
              onChanged: (Project value) => widget.bloc
                  .dispatchEvent(OnSelectedProject(selectedProject: value))),
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
