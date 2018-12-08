
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


}