import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sign_lang_app/core/errors/failure.dart';
import 'package:sign_lang_app/core/utils/api_service.dart';
import 'package:sign_lang_app/core/utils/constants.dart';
import 'package:sign_lang_app/features/learn/data/models/question_response.dart';

abstract class LearnRemoteDataSource {
  Future<Either<Failure, List<Question>>> fetchQuestionList(String id);
  Future<Either<Failure, LearnRes>> avatarSignBeforeQuizList(String id);
}

class LearnRemoteDataSourceImpl extends LearnRemoteDataSource {
  @override
  final DioClient dioClient;

  LearnRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<Question>>> fetchQuestionList(String id) async {
    try {
      var response = await dioClient.get('${ApiUrls.questions}/$id');

      log('printttt ${(response.data['level']['Questions'] as List)}');
      var questions = (response.data['level']['Questions'] as List)
          .map((json) => Question.fromJson(json))
          .toList();
      log('printttt');
      return Right(questions);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LearnRes>> avatarSignBeforeQuizList(String id) async {
    try {
      var response = await dioClient.get('${ApiUrls.guidebook}/$id');

      var questions = (response.data['category']['Questions'] as List)
          .map((json) => Question.fromJson(json))
          .toList();

      // Constructing the LearnRes object
      var learnRes =
          LearnRes(message: response.data['message'], questions: questions);

      return Right(learnRes);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
