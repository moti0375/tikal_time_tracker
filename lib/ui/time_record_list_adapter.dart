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
    return Container(
      decoration: BoxDecoration(
          color: color
      ),
      child: ListTile(
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
            Text("${item.project}", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            Text("${item.task.name}", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold) )
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                child: Text(
                    "${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year}",
                    style: TextStyle(fontSize: 12.0))),
            SizedBox(width: 2.0),
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
                child: Text(
                    "${item.finish.hour}:${item.finish.minute}",
                    style: TextStyle(fontSize: 12.0))),
            SizedBox(width: 2.0),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                child: Text(",", style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: Text(item.getDurationString(),
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

          if (day != null && (items[i].dateTime.day != day.day)) {
            if (color == evenColor) {
              color = oddColor;
            } else {
              color = evenColor;
            }
          }

          day = items[i].dateTime;
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
