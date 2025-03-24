import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boybin/models/user_model.dart';

// Define the base class for all user-related events.
abstract class UserEvent {}

// Event to set a new user.
class SetUserEvent extends UserEvent {
  final User user;

  SetUserEvent(this.user);
}

// Event to clear the user (logout)
class ClearUserEvent extends UserEvent {}

// Define the base class for all user-related states.
abstract class UserState {}

// Initial state when no user is loaded.
class UserInitial extends UserState {}

// State representing a loaded user.
class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

// Bloc to handle user events and manage user states.
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    // Handle the SetUserEvent by emitting a UserLoaded state.
    on<SetUserEvent>((event, emit) {
      emit(UserLoaded(event.user));
    });

    // Handle the ClearUserEvent by emitting the UserInitial state.
    on<ClearUserEvent>((event, emit) {
      emit(UserInitial());
    });
  }
}