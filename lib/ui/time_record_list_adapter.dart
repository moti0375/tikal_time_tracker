import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/ui/time_list_tile.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class TimeRecordListAdapter extends StatelessWidget {
  final List<TimeRecord> items;
  final ListAdapterClickListener adapterClickListener;
  final bool intermittently;
  final bool dismissibleItems;
  final Function(TimeRecord) onItemClick;
  final Function(TimeRecord) onItemDismissed;
  final Function(TimeRecord) onItemLongClick;

  TimeRecordListAdapter(
      {this.items,
      this.adapterClickListener,
      this.intermittently,
      this.dismissibleItems = false,
      this.onItemClick,
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
      child: dismissible ? _buildDismissibleItem(item) : _buildTile(item),
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
        if (onItemDismissed != null) {
          onItemDismissed(item);
        }
      },
      child: _buildTile(item),
    );
  }

  TimeListTile _buildTile(TimeRecord item) {
    return TimeListTile(
      timeRecord: item,
      onTap: () => onItemClick(item),
      onLongClick: () => onItemLongClick(item),
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
}

abstract class ListAdapterClickListener {
  void onListItemClicked(TimeRecord item);

  void onListItemLongClick(TimeRecord item);

  void onListItemDismissed(TimeRecord item);
}
