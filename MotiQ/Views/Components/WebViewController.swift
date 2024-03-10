import SwiftUI
import RevenueCat
import WebKit
import Foundation
import StoreKit

extension SKStoreReviewController {
  public static func requestReviewInCurrentScene() {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      DispatchQueue.main.async {
        requestReview(in: scene)
      }
    }
  }
}

struct WebView: UIViewRepresentable {

  func makeUIView(context: UIViewRepresentableContext<WebView>) -> WebView.UIViewType {
    WKWebView(frame: .zero)
  }

  func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
    let formUrl = "https://36838a2b.sibforms.com/serve/MUIEAI4kVJVjBuZCD_M5bH77lS5L92HgPKg5uhPWMUGc2jhsME527CIMpF4aS5zABf7j_LwblPuJNEicRme1yrooCt3NiqCuzDkf6dAVcxu_4aYMrbGBkUp5BQ9KzcYB7fFh94NefpsVVEj_YAdK_Dw8Vz7WjXN3rL-5ZM_ilnD-1kBWlHuELFfEz-G5TCNNhtJKDpaMLCPP5Az5"
    let request = URLRequest(url: URL(string: formUrl)!)
    uiView.load(request)
  }
}
