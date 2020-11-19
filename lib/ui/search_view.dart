import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/resources/colors.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class SearchView extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  final String initialValue;

  const SearchView({Key key, this.onChanged, this.hint, this.initialValue = Strings.empty_string}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String _value = Strings.empty_string;

  TextEditingController _controller;

  @override
  void initState() {
    print("SearchView initState");

    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController();
  }

  void _clear() {
    setState(() {
      _value = Strings.empty_string;
      _controller.clear();
      widget.onChanged(_value);
      Utils.hideSoftKeyboard(context);
    });
  }

 @override
  void didUpdateWidget(covariant SearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("SearchView: didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    print("SearchView: build");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: AppColors.GenericTextGray), borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.search, size: 24, color: AppColors.GenericTextGray),
          Expanded(child: _createSearchTextInput()),
          Visibility(
              visible: _value != null && _value.isNotEmpty,
              child: InkWell(
                child: Icon(Icons.cancel, size: 24, color: AppColors.GenericTextGray),
                onTap: () => _clear(),
              ))
        ],
      ),
    );
  }

  Widget _createSearchTextInput() {
    return TextField(
      key: Key('searchViewInputText'),
      controller: _controller,
      onChanged: (v) {
        setState(() {
          _value = v;
        });
        widget.onChanged(v);
      },
      decoration: InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8)),
    );
  }
}
