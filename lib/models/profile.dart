class Profile {
    Profile({
        required this.email,
        required this.firstName,
        required this.username,
        required this.mNumber,
        required this.imageUrl,
        required this.courses,
        required this.createdAt,
        required this.updatedAt,
    });

    final String email;
    final String firstName;
    final String username;
    final String mNumber;
    final String? imageUrl;
    final List<String> courses;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Profile copyWith({
        String? email,
        String? firstName,
        String? username,
        String? mNumber,
        String? imageUrl,
        List<String>? courses,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return Profile(
            email: email ?? this.email,
            firstName: firstName ?? this.firstName,
            username: username ?? this.username,
            mNumber: mNumber ?? this.mNumber,
            imageUrl: imageUrl ?? this.imageUrl,
            courses: courses ?? this.courses,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory Profile.fromJson(Map<String, dynamic> json){ 
        return Profile(
            email: json["email"],
            firstName: json["firstname"],
            username: json["username"],
            mNumber: json["m_number"],
            imageUrl: json["image_url"],
            courses: json["courses"] == null ? [] : List<String>.from(json["courses"]!.map((x) => x)),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "email": email,
        "firstname": firstName,
        "username": username,
        "m_number": mNumber,
        "image_url": imageUrl,
        "courses": courses.map((x) => x).toList(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };

    @override
    String toString(){
        return "$email, $firstName, $username, $mNumber, $imageUrl, $courses, $createdAt, $updatedAt, ";
    }
}
