
class UserModel {
  String? uid;
  String? email;
  String? pseudo;
  String? photo;
  int points;

  UserModel({this.uid, this.email, this.pseudo,this.photo, this.points = 0});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      pseudo: map['pseudo'],
      photo: map['photo'],
      points: map['points'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'pseudo': pseudo,
      'photo': photo,
      'points': points,
    };
  }

  void setPoints(int val) {
    points = (points + val);
  }

  void setuid(String unUid) {
    uid = unUid;
  }
  void setPseudo(String unPseudo){
    pseudo = unPseudo;
  }
  void setPhoto(String unePhoto){
    photo = unePhoto;
  }
}
