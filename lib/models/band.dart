class Band {
  String id;
  String name;
  int votes;
  String image;

  Band({this.id, this.name, this.votes, this.image});

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
      id: obj['id'],
      name: obj['name'],
      votes: obj['votes'],
      image: obj['image']);
}
