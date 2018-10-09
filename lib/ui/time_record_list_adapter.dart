import 'package:flutter/material.dart';
import '../data/models.dart';



class TimeRecordListAdapter extends StatelessWidget{

  List<TimeRecord> items;
  ListAdapterClickListener adapterClickListener;
  bool intermittently;

  TimeRecordListAdapter({this.items, this.adapterClickListener, this.intermittently});

  @override
  Widget build(BuildContext context) {
    return _buildListView(items, context, this.intermittently);
  }


  Widget _buildListTile(TimeRecord item, Color color, BuildContext context){
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                child: Text(
                    "${item.date.day}/${item.date.month}/${item.date.year}",
                    style: TextStyle(fontSize: 12.0))),
            SizedBox(
              width: 4.0,
            ),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                child: Text(
                    "${item.start.hour}:${item.start.minute} - ${item.finish.hour}:${item.finish.minute}",
                    style: TextStyle(fontSize: 12.0))),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Text(",", style: TextStyle(fontSize: 12.0))
            ),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: item.duration == null ? Text("Uncompleted", style: TextStyle(color: Colors.red),) : Text(item.getDurationString(),
                    style: TextStyle(fontSize: 12.0))),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
            child: Text(item.comment, style: TextStyle(fontSize: 12.0,), softWrap: false, maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<TimeRecord> items, BuildContext context, bool intermittently) {
    DateTime day;

    Color evenColor = Colors.white;
    Color oddColor = Colors.grey[200];
    Color color = evenColor;

    return ListView.builder(
        itemBuilder: (context, i) {

          if(intermittently){
            if( i %2 == 0){
              color = evenColor;
            }else{
              color = oddColor;
            }
          }else{
            if (day != null && (items[i].date.day != day.day)) {
              if (color == evenColor) {
                color = oddColor;
              } else {
                color = evenColor;
              }
            }
          }

          day = items[i].date;
          return _buildListTile(items[i], color, context);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }


}

class ListAdapterClickListener{
   void onListItemClicked(TimeRecord item){}
   void onListItemLongClick(TimeRecord item){}
}
