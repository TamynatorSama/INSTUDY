

enum ButtonType { regular, fatButton, flexible, flexi, pill }

enum PaymentCardType { active, recent, payout }

enum ListType { unordered, ordered }

enum OrderCardType { newOrder, activeOrder, delivered, cancelled, refund }

enum HttpRequestType { get, post, put, delete }

enum PinPutStatus {
  idle,
  success,
  error,
}

enum VendorSetupProcess { identityVerification, storeSetup, completed }

enum TrackBreakDownType { upDown, leftRight }

enum ProductUpdateType {
  about,
  stockStatus,
  category,
  activeStatus,
  pricing,
  title
}

enum LegalType { termsOfUse, privacyPolicy, buyingPolicy }

enum StockStatus { outOfStock, inStock, lowStock }

enum ProductType { education, car, property }

extension ConvertToString on StockStatus {
  String convert() => this == StockStatus.outOfStock
      ? "Out of stock"
      : this == StockStatus.inStock
          ? "In stock"
          : "Low stock";
}

extension StockStatusConverter on String {
  StockStatus convertToStockStatus() => this == "inStock"
      ? StockStatus.inStock
      : this == "lowStock"
          ? StockStatus.lowStock
          : StockStatus.outOfStock;
}
enum PropertyType {
  flat,
  duplex,
  bungalow,
  terrace,
  semiDetachedBungalow,
  detached
}
