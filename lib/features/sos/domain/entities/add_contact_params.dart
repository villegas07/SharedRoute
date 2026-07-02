import 'package:equatable/equatable.dart';

class AddContactParams extends Equatable {
  final String name;
  final String phone;
  final String relationship;

  const AddContactParams({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  @override
  List<Object> get props => [name, phone, relationship];
}
