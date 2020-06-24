class CastCrew{
  final num id;
  final String name;
  final String profileImagePath;
  final String role;

  CastCrew(this.id, this.name, this.profileImagePath, this.role);

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => id;

  @override
  String toString() => '$id $name as $role';
}