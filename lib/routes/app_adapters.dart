abstract class IAuthRepository {
  Future postLogin(Map body);
  Future postRegister(Map body);
  Future postForget(Map body);
}

abstract class IDashboardRepository {
  // HOME
  //
  Future getPostComment(limit);
  Future postComment(query, body);
  Future postLike(query);
  Future postPost(id, body);
  Future getPost(limit);
  // AGENDA
  //
  Future getAgenda(query);
  // ALUMNI
  //
  Future getTotalAlumni();
  Future getAlumniByAngkatan(query);
  Future getAlumniByName(query);
  Future getAlumniByCity(query);
  Future getAlumniKoordinator(query);
  Future getChart(query);
  // BEASISWA
  //
  Future postDonationScholarship(body);
  Future getReportScholarship(year);
  Future getDaftarPenerimaBeasiswa(query);
  Future getPaymentMethod(query);
  Future getTahunPenerima(query);
  Future getDaftarDonaturBeasiswa(query);
  // GROUP
  //
  Future getMember(query);
  Future getMemberRequest(query);
  Future getMemberToInvite(query);
  Future getAllGroupPost(query);
  Future getGroupPost(query);
  Future getNotJoinedGroup(query);
  Future getJoinedGroup(query);
  Future getSingleGroup(query);
  Future createGroup(body);
  Future requestJoinGroup(body);
  Future approveJoinGroup(body);
  Future createPostGroup(body);
  Future postGroupLike(body);
  Future postGroupComment(body);
  Future getCommentId(id);
  // PROFILE
  //
  Future getIndustri();
  Future getTypeJobs();
  Future getIndividual(query);
  Future getJob(query);
  Future getStudy(query);
  Future getCertification(query);
  Future updateProfile(id, body);
  Future updateJob(id, body);
  Future updateStudy(id, body);
  Future updateCertificate(id, body);
  Future deleteJob(body);
  Future deleteStudy(body);
  Future deleteCert(body);
  Future postPhotoProfile(id, body);
  // REFERENSI
  //
  Future postReference(id, body);
  Future getReference();
  // SUMBANGAN
  //
  Future getDonations(query);
  Future getDetailDonation(id);
  Future postSubmitDonation(body);
  // PEKERJAAN
  //
  Future getJobs(query);
  Future getJobsByMemberId(memberId);
  Future insertJob(body);
  Future removeJob(id);
  // BURSA
  //
  Future getBursa(params);
  Future getBursaByKategori(id);
  Future getDetailBursa(id);
  Future getBursaCategory();
  Future insertBursa(body);
  // PEMILU
  //
  getElection(query);
  getCandidate(query);
  getPemiluResultHistory(id);
  getPemiluResult(id);
  getPemiluState(query);
  postPemiluRegist(data);
  // POLLING
  //
  getPolling(id);
  getOption(id);
  submitPolling(query);
  getPollingResult(id);
}
