class Livre {
  String id;
  String titre;
  String isbn;
  String dateSortie;
  String photo;
  String ecrivainId;

  Livre({
    required this.id,
    required this.titre,
    required this.isbn,
    required this.dateSortie,
    required this.photo,
    required this.ecrivainId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'isbn': isbn,
      'dateSortie': dateSortie,
      'photo': photo,
      'ecrivainId': ecrivainId,
    };
  }

  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      id: map['id'],
      titre: map['titre'],
      isbn: map['isbn'],
      dateSortie: map['dateSortie'],
      photo: map['photo'],
      ecrivainId: map['ecrivainId'],
    );
  }
}
