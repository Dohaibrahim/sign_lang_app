class LearnRes {
  final String message;
  final List<Question> questions;

  LearnRes({required this.message, required this.questions});

  factory LearnRes.fromJson(Map<String, dynamic> json) {
    var questionList = json['questions'] as List;
    List<Question> questions =
        questionList.map((i) => Question.fromJson(i)).toList();

    return LearnRes(
      message: json['message'],
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final String id;
  final String level;
  final List<String> signUrls;
  final List<String> signTexts;
  final String type;
  final String question;
  final List<Option> options;
  final List<String> correctOptions;
  final String? createdAt;
  final String? updatedAt;

  Question({
    required this.id,
    required this.level,
    required this.signUrls,
    required this.signTexts,
    required this.type,
    required this.question,
    required this.options,
    required this.correctOptions,
    this.createdAt,
    this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List;
    List<Option> options = optionsList.map((i) => Option.fromJson(i)).toList();

    return Question(
      id: json['_id'],
      level: json['level'],
      signUrls: List<String>.from(json['sign_Url'] ?? []),
      signTexts: List<String>.from(json['sign_Text'] ?? []),
      type: json['type'],
      question: json['question'],
      options: options,
      correctOptions: List<String>.from(json['correctOptions'] ?? []),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'level': level,
      'sign_Url': signUrls,
      'sign_Text': signTexts,
      'type': type,
      'question': question,
      'options': options.map((o) => o.toJson()).toList(),
      'correctOptions': correctOptions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Option {
  final String text;
  final int score;
  final String id;

  Option({required this.text, required this.score, required this.id});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'],
      score: json['score'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'score': score,
      '_id': id,
    };
  }
}
