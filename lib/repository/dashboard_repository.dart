import 'package:dio/dio.dart';
import 'package:logistika/routes/app_adapters.dart';
import 'package:logistika/services/api_client/api_client.dart';
import 'package:logistika/services/exceptions/server_exception.dart';
import 'package:logistika/shared/constants.dart';

class DashboardRepository extends IDashboardRepository {
  final ApiClient apiClient;
  DashboardRepository({required this.apiClient});

  @override
  Future getTest(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/donasi/index.php?action=list_donasi", query: {
        'limit': query['limit'] ?? '1',
        'page': query['page'] ?? '0'
      });
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // SUMBANGAN
  //
  @override
  Future getDonations(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/donasi/index.php?action=list_donasi", query: {
        'limit': query['limit'] ?? '1',
        'page': query['page'] ?? '0'
      });
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getDetailDonation(id) async {
    try {
      final response = await apiClient.get(
        "$BASE_URL/API/donasi/index.php?action=get_detail&id=$id",
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postSubmitDonation(body) async {
    try {
      var data = {
        'masuk': body['masuk'],
        'keterangan': body['keterangan'],
        'id_donasi': body['id_donasi'],
        'id_member': body['id_member'],
        'amount': body['amount'],
        'customerName': body['customerName'],
        'email': body['email'],
        'phoneNumber': body['phoneNumber'],
        'channel': body['channel'] ?? "bcava",
        'payment_channel': body['payment_channel'] ?? "29",
        'expiredTime': body['expiredTime'] ?? "60",
        'reusableStatus': body['reusableStatus'] ?? "false",
      };
      final response = await apiClient.post(
          "$BASE_URL/API/donasi/index.php?action=insert_donasi", data);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // HOME
  //

  @override
  Future getPostComment(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/post/?action=get_all_comment_post&limit=${query['limit']}&id=${query['id']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postComment(query, comment) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/post/?action=insert_new_comment&id=${query['id']}&id_member=${query['id_member']}",
          {
            'comment': comment,
          });
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postLike(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/post/?action=insert_like_post&id=${query['id']}&id_member=${query['id_member']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postPost(id, body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/post/?action=insert_new_post&id=$id",
        body,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {},
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getPost(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/post/?action=get_all_post&row=${query['row']}&page=${query['page']}&id_member=${query['id_member']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // AGENDA
  //
  @override
  Future getAgenda(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/agenda/?action=get_all_agenda", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // ALUMNI
  //
  @override
  Future getTotalAlumni() async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/member.php?action=count_all_member");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getAlumniByAngkatan(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/member.php?action=get_all_member&by_angkatan=${query['by_angkatan']}&page=${query['page']}&row=${query['row']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getAlumniByName(query) async {
    try {
      final response = apiClient.get(
          await "$BASE_URL/API/member.php?action=get_all_member&by_name=${query['by_name']}&page=${query['page']}&row=${query['row']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getAlumniByCity(query) async {
    try {
      final response = apiClient.get(
          await "$BASE_URL/API/member.php?action=get_all_member&by_city=${query['by_city']}&page=${query['page']}&row=${query['row']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getAlumniKoordinator(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/member.php?action=get_all_member_kordinator&search=${query['search']}&page=${query['page']}&row=${query['row']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getChart(query) async {
    try {
      // final response = await apiClient.get(
      //     "$BASE_URL/API/member.php?action=count_all_member&by_angkatan=${query['by_angkatan']}&row=${query['row']}");
      final response = await apiClient.get(
          "$BASE_URL/API/member.php?action=count_all_member&by_angkatan=${query['by_angkatan']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // BEASISWA
  //

  @override
  Future getPaymentMethod(limit) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/pembayaran/?action=get_all_metode_bayar&limit=${limit}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postDonationScholarship(body) async {
    try {
      var data = {
        'total50': body['total50'],
        'total100': body['total100'],
        'lumpsum': body['lumpsum'],
        'id_member': body['id_member'],
        'amount': body['amount'],
        'customerName': body['customerName'],
        'email': body['email'],
        'phoneNumber': body['phoneNumber'],
        'channel': body['channel'] ?? "bcava",
        'payment_channel': body['payment_channel'] ?? "29",
        'expiredTime': body['expiredTime'] ?? "60",
        'reusableStatus': body['reusableStatus'] ?? "false",
      };
      final response = await apiClient.post(
          "$BASE_URL/API/beasiswa.php?action=insert_beasiswa", data);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getReportScholarship(year) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/beasiswa.php?action=get_ringkasan_laporan_beasiswa&year=$year");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getTahunPenerima(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/beasiswa.php?action=get_tahun_riwayat_beasiswa",
          query: {
            "row": query['row'] ?? "100",
            "page": query['page'] ?? "0",
          });
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getDaftarPenerimaBeasiswa(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/beasiswa.php?action=get_riwayat_beasiswa",
          query: {
            "row": query['row'] ?? "20",
            "page": query['page'] ?? "0",
            "year": query['year']
          });
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getDaftarDonaturBeasiswa(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/beasiswa.php?action=get_donatur_beasiswa",
          query: {
            "row": query['row'] ?? "100",
            "page": query['page'] ?? "0",
            "year": query['year']
          });
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // GROUP
  //

  @override
  Future getCommentId(id) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/group.php?action=get_post_id&comment_id=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postGroupLike(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/group.php?action=set_like_group&group_id=${query['group_id']}&comment_id=${query['comment_id']}&id_member=${query['id_member']}");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postGroupComment(body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/group.php?action=insert_comment", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getMember(query) async {
    var params = {
      "row": query["row"] ?? "250",
      "page": query["page"] ?? "0",
      "id_group": query["id_group"],
      "is_join": query["is_join"] ?? "yes",
      "keyword": query["keyword"],
    };

    try {
      final response = await apiClient.get(
          "$BASE_URL/API/group.php?action=get_group_member",
          query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getMemberRequest(query) async {
    var params = {
      "row": query["row"] ?? "250",
      "page": query["page"] ?? "0",
      "id_group": query["id_group"],
      "is_request": query["is_request"] ?? "yes",
      "keyword": query["keyword"],
    };

    try {
      final response = await apiClient.get(
          "$BASE_URL/API/group.php?action=get_group_member",
          query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getMemberToInvite(query) async {
    var params = {
      "row": query["row"] ?? "250",
      "page": query["page"] ?? "0",
      "id_group": query["id_group"],
      "keyword": query["keyword"],
    };
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/group.php?action=get_member_non_group",
          query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getAllGroupPost(query) async {
    var params = {
      "row": query["row"] ?? "250",
      "page": query["page"] ?? "0",
      "id_member": query["id_member"],
    };
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/group.php?action=get_posting_group",
          query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getGroupPost(query) async {
    var params = {
      "row": query["row"] ?? "250",
      "page": query["page"] ?? "0",
      "group_id": query["group_id"],
    };
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/group.php?action=get_posting_group",
          query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getNotJoinedGroup(query) async {
    var params = {
      "row": query["row"] ?? "100",
      "page": query["page"] ?? "0",
      "id_member": query["id_member"],
      "i_join": query["i_join"] ?? "no",
      "keyword": query["keyword"]
    };
    try {
      final response = await apiClient
          .get("$BASE_URL/API/group.php?action=get_all_group", query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getJoinedGroup(query) async {
    var params = {
      "row": query["row"] ?? "100",
      "page": query["page"] ?? "0",
      "id_member": query["id_member"],
      "i_join": query["i_join"] ?? "yes",
      "keyword": query["keyword"]
    };
    try {
      final response = await apiClient
          .get("$BASE_URL/API/group.php?action=get_all_group", query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getSingleGroup(query) async {
    var params = {
      "id_group": query["id_group"],
    };
    try {
      final response = await apiClient
          .get("$BASE_URL/API/group.php?action=get_all_group", query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future createGroup(body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/group.php?action=insert_group",
        body,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {},
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future requestJoinGroup(body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/group.php?action=join_group",
        body,
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future approveJoinGroup(body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/group.php?action=set_approval_group_member", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future createPostGroup(body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/group.php?action=posting_group",
        body,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {},
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // PROFILE
  //
  @override
  Future getIndividual(id) async {
    try {
      final response =
          await apiClient.get("$BASE_URL/API/?action=get_member_id&id=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getIndustri() async {
    try {
      final response =
          await apiClient.get("$BASE_URL/API/?action=get_industri");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getTypeJobs() async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/pekerjaan/?action=get_jenis_pekerjaan");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getJob(id) async {
    try {
      final response =
          await apiClient.get("$BASE_URL/API/?action=get_member_jobs&id=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getStudy(id) async {
    try {
      final response =
          await apiClient.get("$BASE_URL/API/?action=get_member_edu&id=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getCertification(id) async {
    try {
      final response =
          await apiClient.get("$BASE_URL/API/?action=get_member_cert&id=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future updateProfile(id, body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/?action=update_member&id=$id", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future updateJob(id, body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/?action=update_member_pekerjaan&id=$id", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future updateStudy(id, body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/?action=update_member_pendidikan&id=$id", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future updateCertificate(id, body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/?action=update_member_sertifikasi&id=$id", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future deleteJob(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/?action=delete_pekerjaan_member", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future deleteStudy(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/?action=delete_pendidikan_member", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future deleteCert(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/?action=delete_sertifikasi_member", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postPhotoProfile(id, body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/profile/?action=update_profile_picture&id_member=$id",
        body,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {},
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // REFERENSI
  //
  @override
  Future postReference(id, body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/referensi/?action=insert_new_referensi&id_member=$id",
        body,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {},
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getReference() async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/referensi/?action=get_all_referensi");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // MORE
  //

  // pekerjaan
  @override
  Future getJobs(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/pekerjaan/?action=get_all_jobs", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getJobsByMemberId(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/pekerjaan/?action=get_all_jobs", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future removeJob(id) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/pekerjaan/?action=delete_jobs&id=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future insertJob(body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/pekerjaan/?action=insert_jobs",
        body,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {},
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // bursa
  @override
  Future getBursa(params) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/bursa/?action=get_all_bursa", query: params);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getDetailBursa(id) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/bursa/?action=get_bursa_id", query: {'id': id});
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getBursaCategory() async {
    try {
      final response =
          await apiClient.get("$BASE_URL/API/bursa/?action=get_kategori");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getBursaByKategori(id) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/bursa/?action=get_by_kategori&id_kategori=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future insertBursa(body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/API/bursa/?action=insert_new",
        body,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {},
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // pemilu
  @override
  Future getElection(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/election/index.php?action=get_all_election",
          query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future getCandidate(id) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/election/index.php?action=get_kandidat&id_election=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  // polling

  Future getPolling(id) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/polling/?action=get_all_polling&id_member=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future getOption(id) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/polling/?action=get_polling_kandidat&id_polling=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future submitPolling(query) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/polling/?action=pemilihan_polling", query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future getPollingResult(id) async {
    try {
      final response = await apiClient
          .get("$BASE_URL/API/polling/?action=get_result&id_polling=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future getPemiluResultHistory(id) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/election/index.php?action=get_voters&id_election=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future getPemiluResult(id) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/polling/index.php?action=get_election_result&id_election=$id");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future getPemiluState(query) async {
    try {
      final response = await apiClient.get(
          "$BASE_URL/API/election/index.php?action=election_activities",
          query: query);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  Future postPemiluRegist(data) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/election/index.php?action=register_election", data);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }
}
