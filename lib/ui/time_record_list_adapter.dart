import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class TimeRecordListAdapter extends StatelessWidget {
  final List<TimeRecord> items;
  final ListAdapterClickListener adapterClickListener;
  final bool intermittently;
  final bool dismissibleItems;
  final Function(TimeRecord) onItemClickListener;
  final Function(TimeRecord) onItemDismissed;
  final Function(TimeRecord) onItemLongClick;

  TimeRecordListAdapter(
      {this.items,
      this.adapterClickListener,
      this.intermittently,
      this.dismissibleItems = false,
      this.onItemClickListener,
      this.onItemDismissed,
      this.onItemLongClick});

  @override
  Widget build(BuildContext context) {
    return _buildListView(
        items, context, this.intermittently, this.dismissibleItems);
  }

  Widget _buildListTile(
      TimeRecord item, Color color, BuildContext context, bool dismissible) {
//    print("_buildListTile: ${item.toString()}");
    return Container(
      decoration: BoxDecoration(color: color),
      child: dismissible ? _buildDismissibleItem(item) : _tileItem(item),
    );
  }

  Widget _buildDismissibleItem(TimeRecord item) {
    return Dismissible(
      key: Key("${item.id}"),
      background: Container(
        color: Colors.black38,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onItemDismissed ?? onItemDismissed(item);
      },
      child: _tileItem(item),
    );
  }

  ListTile _tileItem(TimeRecord item) {
    return ListTile(
      dense: true,
      onTap: () {
        adapterClickListener ?? adapterClickListener.onListItemClicked(item);
        onItemClickListener ?? onItemClickListener(item);
      },
      onLongPress: () {
        adapterClickListener ?? adapterClickListener.onListItemLongClick(item);
        onItemLongClick ?? onItemLongClick(item);
      },
      leading: Icon(Icons.work, color: Colors.lightBlueAccent),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: buildTitleRow(item)),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
              child: Text(
                  "${item.date.day}/${item.date.month}/${item.date.year}",
                  style: TextStyle(fontSize: 12.0))),
          SizedBox(
            width: 4.0,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
              child: Text(
                  item.start == null
                      ? "No Start"
                      : "${Utils.buildTimeStringFromTime(item.start)} - " +
                          (item.finish == null
                              ? "No End"
                              : "${Utils.buildTimeStringFromTime(item.finish)}"),
                  style: TextStyle(fontSize: 12.0))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Text(",", style: TextStyle(fontSize: 12.0))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
              child: item.duration == null
                  ? Text(
                      "Uncompleted",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(item.getDurationString(),
                      style: TextStyle(fontSize: 12.0))),
          SizedBox(
            width: 4.0,
          ),
          Expanded(
              child: Text(item.comment,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                  softWrap: false,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis))
        ],
      ),
    );
  }

  Widget _buildListView(List<TimeRecord> items, BuildContext context,
      bool intermittently, bool dismissible) {
    DateTime day;

    Color evenColor = Colors.white;
    Color oddColor = Colors.grey[200];
    Color color = evenColor;

    return ListView.builder(
        itemBuilder: (context, i) {
          if (intermittently) {
            if (i % 2 == 0) {
              color = evenColor;
            } else {
              color = oddColor;
            }
          } else {
            if (day != null && (items[i].date.day != day.day)) {
              if (color == evenColor) {
                color = oddColor;
              } else {
                color = evenColor;
              }
            }
          }

          day = items[i].date;
          return _buildListTile(items[i], color, context, dismissible);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }

  List<Widget> buildTitleRow(TimeRecord timeRecord) {
    if (timeRecord.userName != null) {
      return [
        Text("${timeRecord.userName}", style: TextStyle(fontSize: 15.0)),
        Text("${timeRecord.project.name}", style: TextStyle(fontSize: 15.0)),
        Text("${timeRecord.task.name}", style: TextStyle(fontSize: 15.0))
      ];
    } else {
      return [
        Text("${timeRecord.project.name}", style: TextStyle(fontSize: 15.0)),
        Text("${timeRecord.task.name}", style: TextStyle(fontSize: 15.0))
      ];
    }
  }
}

abstract class ListAdapterClickListener {
  void onListItemClicked(TimeRecord item);
  void onListItemLongClick(TimeRecord item);
  void onListItemDismissed(TimeRecord item);
}
