class MarketPrice {
  final String commodity;
  final String unit;
  final String price;

  MarketPrice({required this.commodity, required this.unit, required this.price});

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      commodity: json['Commodity'] ?? 'Unknown',
      unit: json['Unit'] ?? 'kg',
      price: json['Average'] ?? 'N/A',
    );
  }
}