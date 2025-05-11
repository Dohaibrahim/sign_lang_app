import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sign_lang_app/core/widgets/top_snackbar.dart';
import 'package:sign_lang_app/features/learn/data/models/question_response.dart'
    as model; // Use alias 'model'
import 'package:sign_lang_app/features/learn/presentation/manager/score_tracker_cubit/score_tracker_cubit.dart';
import 'package:sign_lang_app/features/learn/presentation/quizs.dart/widgets/answer.dart';
import 'package:sign_lang_app/features/learn/presentation/quizs.dart/widgets/darg_drop_question.dart';
import 'package:sign_lang_app/features/learn/presentation/widgets/continue_button.dart';
import 'package:sign_lang_app/features/learn/presentation/widgets/questions_tracker.dart';
import './question.dart';

class Quiz extends StatefulWidget {
  final List<model.Question> questions;
  final int questionIndex;
  final Function(int, int) answerQuestion;
  final int? selectedAnswerIndex;
  final bool showFeedback;
  final VoidCallback onNextQuestion;

  const Quiz({
    super.key,
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
    required this.selectedAnswerIndex,
    required this.showFeedback,
    required this.onNextQuestion,
  });

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  AudioPlayer? _audioPlayer;
  bool _isAudioInitialized = false;

  Future<void> _initializeAudio() async {
    if (!_isAudioInitialized) {
      try {
        _audioPlayer = AudioPlayer();
        await _audioPlayer?.setVolume(1.0);
        await _audioPlayer?.setReleaseMode(ReleaseMode.stop);
        _isAudioInitialized = true;
      } catch (e) {
        print('Error initializing audio: $e');
      }
    }
  }

  Future<void> _playSuccessSound() async {
    if (!_isAudioInitialized) {
      await _initializeAudio();
    }
    
    try {
      if (_audioPlayer != null) {
        print('Attempting to play sound...');
        await _audioPlayer?.play(AssetSource('sound/sonido-correcto-331225.mp3'));
        print('Sound play initiated');
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Quiz oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionIndex != widget.questionIndex) {
      _audioPlayer?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[widget.questionIndex];

    // Handle drag & drop question separately
    if (currentQuestion.type == 'drag_drop') {
      return DragDropQuestion(
        question: currentQuestion,
        onNextQuestion: () {
          _audioPlayer?.stop();
          widget.onNextQuestion();
        },
      );
    }

    final answers = currentQuestion.options;
    final correctAnswerIndex = answers.indexWhere((answer) => answer.score == 10);
    context.read<ScoreTrackerCubit>().emit(widget.questionIndex + 1);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  _audioPlayer?.stop();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primaryContainer,
                )),
            QuestionsTracker(totalQ: widget.questions.length),
          ],
        ),
        Question(
          currentQuestion.question,
          currentQuestion.signUrls.isNotEmpty 
              ? currentQuestion.signUrls.first 
              : '',
        ),
        ...answers.asMap().entries.map((entry) {
          final idx = entry.key;
          final answer = entry.value;
          final isCorrect = idx == correctAnswerIndex;
          final isSelected = idx == widget.selectedAnswerIndex;

          Color backgroundColor = Colors.transparent;
          if (widget.showFeedback) {
            if (isSelected) {
              backgroundColor = isCorrect ? Colors.green : Colors.red;
            }
            if (isCorrect && !isSelected) backgroundColor = Colors.green;
          }

          return Answer(
            () {
              widget.answerQuestion(answer.score, idx);

              if (answer.score == 10) {
                _playSuccessSound();
                TopSnackBar.show(
                  context,
                  title: 'Correct 🎉',
                  message: 'Well done! That was the right answer.',
                  contentType: ContentType.success,
                  color: const Color(0xff19A7CE),
                );
              } else {
                TopSnackBar.show(
                  context,
                  title: 'Oops 😕',
                  message: "That's not the correct answer.",
                  contentType: ContentType.failure,
                  color: Colors.redAccent,
                );
              }
            },
            answer.text,
            backgroundColor: backgroundColor,
          );
        }).toList(),
        if (widget.showFeedback || currentQuestion.type == 'drag_drop')
          ContinueButton(text: 'Continue', onPressed: widget.onNextQuestion),
      ],
    );
  }
}
