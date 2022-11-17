class ErrorRespond {
  String status = "";

  ErrorRespond(this.status);

  static ErrorRespond parseRespond(dynamic map) {
    return ErrorRespond(
      map["status"],
    );
  }
}
