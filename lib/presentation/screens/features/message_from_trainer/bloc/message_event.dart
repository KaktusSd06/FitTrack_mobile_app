import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class GetMessageByDate extends MessageEvent {
  final DateTime date;
  const GetMessageByDate({
    required this.date,
});

  @override
  List<Object?> get props => [date];
}