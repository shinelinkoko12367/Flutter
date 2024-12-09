import 'package:map_bloc_crud/Model/UserModel.dart';

abstract class DataEvent {}

class FetchData extends DataEvent {}

class CreateData extends DataEvent {
  final User user;
  CreateData(this.user);
}

class UpdateData extends DataEvent {
  final String id;
  final User user;
  UpdateData(this.id, this.user);
}

class DeleteData extends DataEvent {
  final String id;
  DeleteData(this.id);
}
