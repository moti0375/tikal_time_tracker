
class SendEmailForm {
  String to;
  String from;
  String cc;
  String comment;
  String subject;

  SendEmailForm({this.to, this.from, this.cc, this.comment, this.subject});

  @override
  String toString() {
    return 'SendEmailForm{to: $to, from: $from, cc: $cc, comment: $comment, subject: $subject}';
  }

  Map<String, String> toMap() {
    Map<String, String> map = Map<String, String>();
    map["receiver"] = this.to;
    map["cc"] = this.cc;
    map["subject"] = this.subject;
    map["comment"] = this.comment;
    map["btn_send"] = "Send";
    return map;
  }

}