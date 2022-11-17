class ResponseResult<T> {
  List<T> transactions;
  int respondCode = 0;
  String requestType = "";

  ResponseResult(this.transactions, this.respondCode);

  ResponseResult.withRequest(this.transactions, this.respondCode, this.requestType);
}

class ResponseSingleResult<T> {
  T res;
  int respondCode = 0;

  ResponseSingleResult(this.res, this.respondCode);

}

class ResponseMappedResult<T> {
  Map<String, List<T>> transactions;
  int respondCode = 0;

  ResponseMappedResult(this.transactions, this.respondCode);
}