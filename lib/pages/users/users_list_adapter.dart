import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';



class UsersListAdapter extends StatelessWidget{

  List<Member> items;
  UsersListAdapter({this.items});

  @override
  Widget build(BuildContext context) {
    return _buildListView(items);
  }


  Widget _buildListTile(Member item, Color color){
    return Container(
      decoration: BoxDecoration(
          color: color
      ),
      child: ListTile(
        isThreeLine: false,
        dense: true,
        leading: Icon(Icons.perm_contact_calendar, color: Colors.lightBlueAccent),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text("${item.name}", style: TextStyle(fontSize: 15.0)),
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.email, style: TextStyle(fontSize: 12.0)),
            Text(item.role, style: TextStyle(fontSize: 12.0))
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Member> items) {
    DateTime day;

    Color evenColor = Colors.white;
    Color oddColor = Colors.grey[200];
    Color color = evenColor;

    return ListView.builder(
        itemBuilder: (context, i) {

          if (i % 2 == 0) {
            color = evenColor;
          } else {
            color = oddColor;
          }
          return _buildListTile(items[i], color);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }


}

