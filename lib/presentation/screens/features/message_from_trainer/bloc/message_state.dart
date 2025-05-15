import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/models/message_model.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageModel> messages;

  const MessageLoaded({
    required this.messages,
  });

  @override
  List<Object?> get props => [messages];
}

class MessageError extends MessageState {
  final String message;

  const MessageError({required this.message});

  @override
  List<Object?> get props => [message];
}