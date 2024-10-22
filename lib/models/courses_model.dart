class Course{
  final String id;
  final String name;
  final String instructor;
  final String title;
  final String semesterType;
  final String degree;
  final bool status;

  const Course({required this.degree,required this.id,required this.instructor,required this.name,required this.semesterType,required this.status,required this.title});
  factory Course.fromJson(Map<String,dynamic>json)=>Course(degree: json["degree"], id: json["_id"] ?? json["id"], instructor: json["instructor"], 
  name: json["name"], semesterType: json["semester_type"], status: json["status"]==true, title: json["title"]);


  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instructor": instructor,
        "title": title,
        "semester_type": semesterType,
        "degree": degree,
        "status": status,
    };

    @override
    String toString(){
        return "$id, $name, $instructor, $title, $semesterType, $degree, $status ";
    }

    @override
    operator ==(Object other)=>other is Course && other.id == id;
    
      @override
      int get hashCode => Object.hashAll([id,name,instructor,title]);
    
}
