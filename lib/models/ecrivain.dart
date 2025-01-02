class Ecrivain {
  String id;
  String nom;
  String prenom;
  String tel;

  Ecrivain({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.tel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'tel': tel,
    };
  }

  factory Ecrivain.fromMap(Map<String, dynamic> map) {
    return Ecrivain(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      tel: map['tel'],
    );
  }
}
