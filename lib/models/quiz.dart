class Quiz {
  Quiz({
    required this.question,
    required this.options,
  });

  final String question;
  final List<Option> options;

  Quiz copyWith({
    String? question,
    List<Option>? options,
  }) {
    return Quiz(
      question: question ?? this.question,
      options: options ?? this.options,
    );
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json["question"],
      options: (json["options"] as List).map((e) {
        Map<String, dynamic> option = e;
        List<String> keys = option.keys.toList();
        String optionLetter = keys.firstWhere((e) => e.length == 1);

        return Option(
            optionLetter: optionLetter, optionText:option[optionLetter], answer: option["answer"]);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "question": question,
      };

  @override
  String toString() {
    return "$question, $options, ";
  }
}

class Option {
  Option({
    required this.optionLetter,
    required this.optionText,
    required this.answer,
  });

  final String optionLetter;
  final bool answer;
  final String? optionText;

  Option copyWith({
    String? optionText,
    bool? answer,
    String? optionLetter,
  }) {
    return Option(
        optionLetter: optionLetter ?? this.optionLetter,
        answer: answer ?? this.answer,
        optionText: optionText ?? this.optionText);
  }

  @override
  String toString() {
    return "$optionLetter, $answer, $optionText";
  }
}
