import 'package:flutter/material.dart';
import 'package:instudy/models/courses_model.dart';
import 'package:instudy/repo/auth_repo.dart';

class CourseProvider extends ChangeNotifier {
  AuthRepo _repo = AuthRepo();

  List<Course> courses = [];
  List<String> semesters = [];

  Future<({List<Course> courses, List<String> semester})> fetchCourses(
      {BuildContext? context}) async {
    if (semesters.isNotEmpty) {
      return (courses: courses, semester: semesters);
    }

    await _repo.getCourses().then((value) {
    
      if (!value.status ) {
        if(context != null){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              value.message,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 13, color: Colors.white),
            )));
        }
        
        return;
      }
      
      courses = value.result!.$1;
      semesters = value.result!.$2;
    });
    return (courses: courses, semester: semesters);
  }
}
