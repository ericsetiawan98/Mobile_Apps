import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:test_venteny_app/models/video_model.dart';


abstract class VideoEvent {}

class FetchVideos extends VideoEvent {}


abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoModel> videos;

  VideoLoaded(this.videos);
}

class VideoEmpty extends VideoState {
  final String message;

  VideoEmpty(this.message);
}

class VideoError extends VideoState {
  final String error;

  VideoError(this.error);
}

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoInitial()) {
    on<FetchVideos>(_onFetchVideos);
  }

  Future<void> _onFetchVideos(FetchVideos event, Emitter<VideoState> emit) async {
    emit(VideoLoading());

    try {
      final response = await http.get(
        Uri.parse('https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json'),
      );

      print('API Response status code: ${response.statusCode}');
      print('API Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<VideoModel> videos = data.map((json) => VideoModel.fromJson(json)).toList();

        if (videos.isEmpty) {
          emit(VideoEmpty('No videos available.'));
        } else {
          emit(VideoLoaded(videos));
        }
      } else {
        emit(VideoError('Failed to load videos. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      print('Error: $e');
      emit(VideoError('An error occurred: $e'));
    }
  }
}