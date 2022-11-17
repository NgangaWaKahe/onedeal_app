class ReservationFilter {
  String customerid = "";
  String order = "desc";
  String sort = "rental_date";

  ReservationFilter(this.customerid);

  ReservationFilter.empty();
}
