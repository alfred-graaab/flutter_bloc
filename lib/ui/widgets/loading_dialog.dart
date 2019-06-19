import 'package:flutter/material.dart';
import 'package:flutter_bloc/utils/localizations.dart';
import 'package:progress_hud/progress_hud.dart';

class LoadingDialog extends StatelessWidget {
  final String text;

  LoadingDialog({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.grey,
      borderRadius: 5.0,
      loading: true,
      text: text == null || text.isEmpty
          ? AppLocalizations.of(context).loading
          : text,
    );
  }
}
