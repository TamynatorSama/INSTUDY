import 'package:flutter/material.dart';
import 'package:instudy/models/profile.dart';
import 'package:instudy/repo/profile_repo.dart';
import 'package:instudy/utils/feedback_snackbar.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo _repo = ProfileRepo();
  Profile? profile;
  fetchProfile(BuildContext context) {
    _repo.getProfile().then((value) {
      if (value.status) {
        profile = value.result;
        notifyListeners();
        return;
      }
      showFeedbackSnackbar(context, message: value.message);
    });
  }
}
