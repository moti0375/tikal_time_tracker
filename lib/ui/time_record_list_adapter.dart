import 'package:flutter/material.dart';
import '../data/models.dart';



class TimeRecordListAdapter extends StatelessWidget{

  List<TimeRecord> items;
  ListAdapterClickListener adapterClickListener;

  TimeRecordListAdapter({this.items, this.adapterClickListener});

  @override
  Widget build(BuildContext context) {
    return _buildListView(items);
  }


  Widget _buildListTile(TimeRecord item, Color color){
    print("_buildListTile: ${item.toString()}");
    return Container(
      decoration: BoxDecoration(
          color: color
      ),
      child: ListTile(
        dense: true,
        onTap: (){
          adapterClickListener.onListItemClicked(item);
        },
        onLongPress: (){
          adapterClickListener.onListItemLongClick(item);
        },
        leading: Icon(Icons.work, color: Colors.lightBlueAccent),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text("${item.project.name}", style: TextStyle(fontSize: 15.0)),
            Text("${item.task.name}", style: TextStyle(fontSize: 15.0) )
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                child: Text(
                    "${item.date.day}/${item.date.month}/${item.date.year}",
                    style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: Text(
                    "${item.start.hour}:${item.start.minute}",
                    style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: Text("-", style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: item.finish == null ? Text("") : Text(
                    "${item.finish.hour}:${item.finish.minute}",
                    style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                child: Text(",", style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: item.duration == null ? Text("Uncompleted", style: TextStyle(color: Colors.red),) : Text(item.getDurationString(),
                    style: TextStyle(fontSize: 12.0))),

          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<TimeRecord> items) {
    DateTime day;

    Color evenColor = Colors.white;
    Color oddColor = Colors.grey[200];
    Color color = evenColor;

    return ListView.builder(
        itemBuilder: (context, i) {

          if (day != null && (items[i].date.day != day.day)) {
            if (color == evenColor) {
              color = oddColor;
            } else {
              color = evenColor;
            }
          }

          day = items[i].date;
          return _buildListTile(items[i], color);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }


}

class ListAdapterClickListener{
   void onListItemClicked(TimeRecord item){}
   void onListItemLongClick(TimeRecord item){}
}
