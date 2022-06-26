part of 'birthday_bloc.dart';

abstract class BirthdayEvent extends Equatable {
  const BirthdayEvent();

  @override
  List<Object> get props => [];
}

class CheckAge extends BirthdayEvent {
  const CheckAge({required this.selectedDate});
  final DateTime selectedDate;
}
