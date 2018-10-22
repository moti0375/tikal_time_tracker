import '../../data/member.dart';
class MembersPresenterContract{
  void loadUsers(){return null;}
  void subscribe(MembersViewContract view){return null;}
}

class MembersViewContract{
  void showMembers(List<Member> members){return null;}
  void setLoadingIndicator(bool loading){}
}