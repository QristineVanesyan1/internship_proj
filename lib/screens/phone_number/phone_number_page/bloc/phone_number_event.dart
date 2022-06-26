part of 'phone_number_bloc.dart';

abstract class PhoneNumberEvent extends Equatable {
  const PhoneNumberEvent();

  @override
  List<Object> get props => [];
}

class CheckEmail extends PhoneNumberEvent {
  const CheckEmail({required this.email});
  final String email;
}

class CheckPhoneNumber extends PhoneNumberEvent {
  const CheckPhoneNumber({required this.phoneNumber});
  final String phoneNumber;
}

class CheckUsedEmailEvent extends PhoneNumberEvent {
  const CheckUsedEmailEvent({required this.email});
  final String email;
}

class CheckUsedPhoneEvent extends PhoneNumberEvent {
  const CheckUsedPhoneEvent({required this.phoneNumber});
  final String phoneNumber;
}
