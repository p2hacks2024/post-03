//
//  WebView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI
import WebKit

public struct WebView: View {
    private let url: URL
    @State private var isLoading: Bool = false
    @State private var loadingProgress: Double = 0

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView(value: loadingProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
            }
            WebViewRepresentation(
                url: url,
                loadingProgress: $loadingProgress,
                isLoading: $isLoading
            )
        }
    }
}

#Preview {
    WebView(url: URL(string: "https://kantacky.com")!)
}

private struct WebViewRepresentation: UIViewRepresentable {
    private let webView: WKWebView = .init()
    private let url: URL
    @Binding private var loadingProgress: Double
    @Binding private var isLoading: Bool
    @Binding private var title: String

    init(
        url: URL,
        loadingProgress: Binding<Double> = .constant(0),
        isLoading: Binding<Bool> = .constant(false),
        title: Binding<String> = .constant("")
    ) {
        self.url = url
        _loadingProgress = loadingProgress
        _isLoading = isLoading
        _title = title
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ view: WKWebView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        private var parent: WebViewRepresentation
        private var observations: [NSKeyValueObservation] = []

        init(_ parent: WebViewRepresentation) {
            self.parent = parent
            super.init()
            self.observe()
        }

        deinit {
            observations.forEach({ $0.invalidate() })
            observations.removeAll()
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy) -> Void
        ) {
            decisionHandler(.allow)
        }

        private func observe() {
            let progressObservation = parent.webView.observe(\.estimatedProgress, options: .new) {
                [weak self] _, value in
                Task {
                    await self?.onEstimatedProgressChanged(value.newValue ?? 0)
                }
            }

            let isLoadingObservation = parent.webView.observe(\.isLoading, options: .new) {
                [weak self] _, value in
                Task {
                    await self?.onIsLoadingChanged(value.newValue ?? false)
                }
            }

            let titleObservation = parent.webView.observe(\.title, options: .new) {
                [weak self] _, value in
                Task {
                    await self?.onTitleChanged((value.newValue ?? "") ?? "")
                }
            }

            observations = [
                progressObservation,
                isLoadingObservation,
                titleObservation,
            ]
        }

        private func onEstimatedProgressChanged(_ newValue: Double) {
            withAnimation {
                parent.loadingProgress = newValue
            }
        }

        private func onIsLoadingChanged(_ newValue: Bool) {
            parent.isLoading = newValue
        }

        private func onTitleChanged(_ newValue: String) {
            parent.title = newValue
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title = webView.title ?? ""
        }
    }
}
