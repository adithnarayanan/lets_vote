// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'election.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElectionAdapter extends TypeAdapter<Election> {
  @override
  final typeId = 0;

  @override
  Election read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Election(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
      (fields[3] as List)?.cast<Candidate>(),
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Election obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.officeLevel)
      ..writeByte(3)
      ..write(obj.candidates)
      ..writeByte(4)
      ..write(obj.chosenIndex);
  }
}
