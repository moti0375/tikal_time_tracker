import 'package:flutter/material.dart';
import 'generate_report_page.dart';
import 'place_holder_content.dart';
import '../../data/user.dart';
typedef Widget ItemWidgetBuilder<T>(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget{

  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;

  ListItemBuilder({this.items, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    print("ItemWidgetBuilder: build.." );
    if(items == null){
      final user = User();
      print("ItemWidgetBuilder: items are null user: $user" );
      return GenerateReportPage();
    } else {
      if(items.length == 0){
        print("ItemWidgetBuilder: items size 0" );
        return _noWorkPlaceHolder();
      } else {
        print("ItemWidgetBuilder: build the list" );
        return _buildList();
      }
    }
  }

  Widget _noWorkPlaceHolder(){
      return PlaceholderContent();
  }

  Widget _buildList(){
    return Center();
  }
}