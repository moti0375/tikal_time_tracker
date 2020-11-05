import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/resources/colors.dart';
import 'package:tikal_time_tracker/ui/time_list_tile.dart';

class TimeRecordListViewBuilder extends StatelessWidget {
  final List<TimeRecord> items;
  final bool intermittently;
  final bool dismissibleItems;
  final Function(TimeRecord) onItemClick;
  final Function(TimeRecord) onItemDismissed;
  final Function(TimeRecord) onItemLongClick;

  TimeRecordListViewBuilder(
      {this.items,
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
      TimeRecord item, BuildContext context, bool dismissible) {
//    print("_buildListTile: ${item.toString()}");
    return Container(
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
      onTap: onItemClick != null ? () => onItemClick(item) : null,
      onLongClick: onItemLongClick != null ? () => onItemLongClick(item) : null,
    );
  }

  Widget _buildListView(List<TimeRecord> items, BuildContext context,
      bool intermittently, bool dismissible) {


    return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: AppColors.GeneralDividerGray, height: 1),
        itemBuilder: (context, i) {
          return _buildListTile(items[i], context, dismissible);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }
}

