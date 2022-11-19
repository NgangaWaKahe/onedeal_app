class UploadRespond {
  List<String> status = [];

  UploadRespond(this.status);

  UploadRespond.empty() {
    status = [];
  }

  static UploadRespond parseRespond(dynamic map) {
    List<String> uploadFiles = [];
    for (var w in map["filename"]) {
      uploadFiles.add(w);
    }

    return UploadRespond(
      uploadFiles,
    );
  }
}
