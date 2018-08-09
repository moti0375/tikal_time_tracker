class User{
  String name;
  String login;
  Role role;

  User({this.name, this.login, this.role});
}

class Time{
  String project;
  String task;
  double start;
  double finish;
  double duration;
  DateTime dateTime;

  Time({this.project, this.task, this.start, this.finish, this.duration,
      this.dateTime});
}

enum Role{
  User,
  Admin
}

enum JobTask{
  Accounting,
  ArmyService,
  Consulting,
  Development,
  General,
  HR,
  Illness,
  Management,
  Marketing,
  Meeting,
  Training,
  Sales,
  PersonalAbsence,
  Subscription,
  Vacation,
  Transport
}

class Project{
  final String name;
  final List<JobTask> tasks;
  const Project({this.name, this.tasks});
}