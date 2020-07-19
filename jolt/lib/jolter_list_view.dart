import 'package:flutter/material.dart';
import './jolter_list_entry.dart';
import './size_config.dart';

class JolterListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 70,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
          JolterListEntry(),
        ],
      ),
    );
  }
}
