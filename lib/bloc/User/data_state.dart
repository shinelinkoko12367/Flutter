import 'package:map_bloc_crud/Model/UserModel.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<User> data;
  DataLoaded(this.data);
}

class DataError extends DataState {
  final String message;
  DataError(this.message);
}

class DataCreated extends DataState {
  final User data;
  DataCreated(this.data);
}

class DataUpdated extends DataState {
  final User data;
  DataUpdated(this.data);
}

class DataDeleted extends DataState {}
