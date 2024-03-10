import Foundation

struct QuotesModel: Codable, Hashable {
  let q: String
  let a: String

  init(q: String, a: String) {
    self.q = q
    self.a = a
  }

  static func quotesMock() -> QuotesModel {
    let mock = QuotesModel(q: "My quote", a: "By me")
    return mock
  }
}
