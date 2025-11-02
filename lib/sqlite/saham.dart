class Saham {
  final int tickerid;
  final String ticker;
  final int open;
  final int high;
  final int last;
  final double change;

  Saham({
    required this.tickerid,
    required this.ticker,
    required this.open,
    required this.high,
    required this.last,
    required this.change,
  });

  factory Saham.fromMap(Map<String, dynamic> map) {
    return Saham(
      tickerid: map['tickerid'],
      ticker: map['ticker'],
      open: map['open'],
      high: map['high'],
      last: map['last'],
      change: map['change'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tickerid': tickerid,
      'ticker': ticker,
      'open': open,
      'high': high,
      'last': last,
      'change': change,
    };
  }
}
