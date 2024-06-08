class SocketException {
  String message = "Internet Connection";
  SocketException(this.message);
}

class NoInternet {
  String message = "No Internet Connection";
  NoInternet(this.message);
}

class HttpException {
  String message = "Http Status check success or failure";
  HttpException(this.message);
}

class FormatException {
  String message = "unable to process data";
  FormatException(this.message);
}

class TimeoutException {
  String message = "Connection timeout";
  TimeoutException(this.message);
}
class IOException {
  String message = "Handling the Input Output Reletad Exception";
  IOException(this.message);
}