
import 'package:flutter/material.dart';

extension NavigatorStateExts on NavigatorState {
  Future<void> popUntilAndReplace(String routenName) async {
    popUntil(ModalRoute.withName(routenName));
    await Navigator.of(context).pushReplacementNamed(routenName);
  }
}