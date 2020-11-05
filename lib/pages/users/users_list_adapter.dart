import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/resources/colors.dart';



class UsersListAdapter extends StatelessWidget{

  final List<Member> items;
  UsersListAdapter({this.items});

  @override
  Widget build(BuildContext context) {
    return _buildListView(items);
  }


  Widget _buildListTile(Member item){
    return Container(
      child: ListTile(
        isThreeLine: false,
        dense: true,
        leading: Icon(Icons.perm_contact_calendar, color: Colors.black54),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text("${item.name}", style: TextStyle(fontSize: 15.0, color: item.hasIncompleteEntry ? Colors.red: Colors.black)),
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.email, style: TextStyle(fontSize: 12.0)),
            Text(item.role.toString().split(".").last, style: TextStyle(fontSize: 12.0))
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Member> items) {


    return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: AppColors.GeneralDividerGray, height: 1),
        itemBuilder: (context, i) {
          return _buildListTile(items[i]);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }


}

