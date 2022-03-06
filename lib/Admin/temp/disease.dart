class Disease {
  final int count;
  final String name;
  Disease(this.count, this.name);

  Disease.fromMap(Map<String, dynamic> map)
      : assert(map['count'] != null),
        assert(map['name'] != null),
        count = map['count'],
        name = map['name'];

  @override
  String toString() => "Record<$count>";
}
