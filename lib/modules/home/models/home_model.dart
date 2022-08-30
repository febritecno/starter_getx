class PostModel {
  dynamic idPost;
  dynamic parentCommentId;
  dynamic comment;
  dynamic photo;
  dynamic idMember;
  dynamic timestamp;
  dynamic fullname;
  dynamic userpic;
  dynamic jumlahLike;
  dynamic isLike;
  dynamic jumlahComment;

  PostModel(
      {this.idPost,
      this.parentCommentId,
      this.comment,
      this.photo,
      this.idMember,
      this.timestamp,
      this.fullname,
      this.userpic,
      this.jumlahComment,
      this.isLike,
      this.jumlahLike});

  PostModel.fromJson(Map<String, dynamic> json) {
    idPost = json['id_post'];
    parentCommentId = json['parent_comment_id'];
    comment = json['comment'];
    photo = json['photo'];
    idMember = json['id_member'];
    timestamp = json['timestamp'];
    fullname = json['fullname'];
    userpic = json['userpic'];
    jumlahLike = json['jumlah_like'];
    isLike = json['is_like'].toString();
    jumlahComment = json['jumlah_komentar'];
  }
}

class AgendaModel {
  String? id;
  String? judul;
  String? deskripsi;
  String? subjudul;
  String? subdeskripsi;
  String? photo;
  String? photoBg;
  String? sts;
  String? created;
  String? tgl_akhir;
  String? tgl_awal;
  String? lokasi;

  AgendaModel(
      {this.id,
      this.judul,
      this.deskripsi,
      this.subjudul,
      this.subdeskripsi,
      this.photo,
      this.photoBg,
      this.sts,
      this.created,
      this.tgl_akhir,
      this.tgl_awal,
      this.lokasi});

  AgendaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    judul = json['judul'] ?? "";
    deskripsi = json['deskripsi'] ?? "";
    subjudul = json['subjudul'] ?? "";
    subdeskripsi = json['subdeskripsi'] ?? "";
    photo = json['photo'] ?? "";
    photoBg = json['photo_bg'] ?? "";
    sts = json['sts'] ?? "";
    created = json['created'] ?? "";
    tgl_awal = json['tgl_awal'];
    tgl_akhir = json['tgl_akhir'];
    lokasi = json['lokasi'];
  }
}

class PostCommentsModel {
  String? idPost;
  String? parentCommentId;
  String? comment;
  String? photo;
  String? idMember;
  String? nickname;
  String? userpic;
  PostCommentsModel(
      {this.idPost,
      this.parentCommentId,
      this.comment,
      this.photo,
      this.idMember,
      this.nickname,
      this.userpic});

  PostCommentsModel.fromJson(Map<String, dynamic> json) {
    idPost = json['id_post'] ?? "";
    parentCommentId = json['parent_comment_id'] ?? "";
    comment = json['comment'] ?? "";
    photo = json['photo'] ?? "";
    idMember = json['id_member'] ?? "";
    nickname = json['nickname'] ?? "";
    userpic = json['userpic'] ?? "";
  }
}
