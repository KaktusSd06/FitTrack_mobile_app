import 'package:fittrack/data/models/message_model.dart';
import 'package:fittrack/data/models/trainer_model.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/data/services/trainer_messages_service.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_event.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_state.dart';
import 'package:fittrack/presentation/screens/features/message_from_trainer/bloc/message_event.dart';
import 'package:fittrack/presentation/screens/features/message_from_trainer/bloc/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {

  final TrainerCommentService _messagesService;

  MessageBloc({required TrainerCommentService service}) : _messagesService = service,  super(MessageInitial()) {
    on<GetMessageByDate>(_onGetMessageByDate);
  }

  Future<void> _onGetMessageByDate(
  GetMessageByDate event,
      Emitter<MessageState> emit,
      ) async {
    emit(MessageLoading());
    try {

      List<MessageModel> messages = await _messagesService.getCommentsByUserId(date: event.date);
      
      emit(MessageLoaded(
        messages: messages,
      ));
    }
    catch(e){
      emit(MessageError(message:  e.toString()));
    }
  }
}
