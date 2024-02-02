class Track {

  int? id;
  String? title;
  String? note;
  int? tempo;
  int? sort;

  Track({ this.id, this.title, this.tempo, this.note, this.sort });

  Map<String, Object?> toMap() {
    return <String, dynamic>{
      'id':       id,
      'title':    title,
      'note':     note,
      'tempo':    tempo,
      'sort':    sort
    };
  }

  Track.fromMap(Map<String, dynamic> map) {
    id          = map['id'];
    title       = map['title'];
    note        = map['note'];
    tempo       = map['tempo'];
    sort        = map['sort'];
  }
}