//
//  ContentView.swift
//  DyadSampleApp
//
//  Created by Dyad Team
//

import SwiftUI

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

struct ContentView: View {
    @State private var posts: [Post] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            fetchPosts()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if posts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No posts available")
                            .font(.headline)
                        Button("Load Posts") {
                            fetchPosts()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(posts) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Dyad Sample App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: fetchPosts) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            if posts.isEmpty {
                fetchPosts()
            }
        }
    }
    
    private func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        NetworkService.shared.fetchPosts { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedPosts):
                    self.posts = Array(fetchedPosts.prefix(10))
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
