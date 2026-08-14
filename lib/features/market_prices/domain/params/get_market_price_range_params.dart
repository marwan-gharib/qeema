class GetMarketPriceRangeParams {
  const GetMarketPriceRangeParams({
    required this.assetTypeCode,
    required this.from,
    required this.to,
  });

  final String assetTypeCode;
  final DateTime from;
  final DateTime to;
}
