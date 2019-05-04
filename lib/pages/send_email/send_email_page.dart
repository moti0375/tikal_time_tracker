import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/send_email/send_email_contract.dart';
import 'package:tikal_time_tracker/pages/send_email/send_email_presenter.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/email_event.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';

class SendEmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SendEmailPageState();
  }
}

class SendEmailPageState extends State<SendEmailPage> implements SendMailContractView{

  Analytics analytics = Analytics();
  SendMailContractPresenter presenter;
  String status = "";
  TextEditingController toInputTextController;
  TextEditingController ccInputTextController;
  TextEditingController subjectInputTextController;


  @override
  void initState() {
    super.initState();
    presenter = SendEmailPresenter(repository: TimeRecordsRepository());
    presenter.subscribe(this);
    analytics.logEvent(EmailEvent.impression(EVENT_NAME.EMAIL_SCREEN).open());

  }

  @override
  Widget build(BuildContext context) {
    Widget fromRow() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Text(Strings.from_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: Strings.from_hint,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget toRow() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Text("To(*): ",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  onChanged: presenter.onToInputTextChanged,
                  controller: toInputTextController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget ccRow() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Text(Strings.cc_title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  onChanged: presenter.onCcInputTextChanged,
                  controller: ccInputTextController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget subjectRow() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Text(Strings.subject_title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  onChanged: presenter.onSubjectInputTextChanged,
                  controller: subjectInputTextController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget commentRow() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
                child: Text(Strings.comment_title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            Flexible(
              flex: 2,
              child: Container(
                height: 25,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  onChanged: presenter.onCommentInputTextChanged,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget statusRow() {
      return Container(
        height: 15,
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 35),
        child: Text(status, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
        textAlign: TextAlign.center),
      );
    }

    var sendButton = Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Colors.orangeAccent.shade100,
          elevation: 2.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              setState(() {
                status = "";
              });
              analytics.logEvent(EmailEvent.click(EVENT_NAME.SEND_MAIL_CLICKED));
              presenter.onSendMailButtonClicked();
            },
            color: Colors.orangeAccent ,
            child: Text(Strings.send_button_text, style: TextStyle(color: Colors.white)),
          )),
    );

    return Scaffold(
      appBar: PlatformAppbar(
        title: Text(Strings.send_email_page_title),
      ).build(context),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TimeTrackerPageTitle(),
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: <Widget>[
                fromRow(),
                toRow(),
                ccRow(),
                subjectRow(),
                commentRow(),
                statusRow()
              ],
            )
            ),
            Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    sendButton
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  void logOut() {
    // TODO: implement logOut
  }

  @override
  void showPageDetails(SendEmailForm form) {
    analytics.logEvent(EmailEvent.impression(EVENT_NAME.MAIL_FORM_LOADED).view());
    setState(() {
      toInputTextController = TextEditingController(text: form.to);
      ccInputTextController = TextEditingController(text: form.cc);
      subjectInputTextController = TextEditingController(text: form.subject);
      presenter.onToInputTextChanged(form.to);
      presenter.onCcInputTextChanged(form.cc);
      presenter.onSubjectInputTextChanged(form.subject);
    });
  }

  @override
  void showSentStatus(String status) {
    analytics.logEvent(EmailEvent.impression(EVENT_NAME.MAIL_SENT).view().setDetails("status: $status"));
    setState(() {
      this.status = status;
    });
  }
}
