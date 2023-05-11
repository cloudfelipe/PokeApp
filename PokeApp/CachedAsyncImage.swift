//
//  CachedAsyncImage.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import SwiftUI

private final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func get(_ key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }
}

struct CachedAsyncImage<Content: View>: View {
    @State private var image: UIImage?
   
    let url: URL
    let content: (Image) -> Content
    
    init(url: URL, @ViewBuilder content: @escaping (Image) -> Content) {
        self.url = url
        self.content = content
    }
    
    var body: some View {
        Group {
            if image != nil {
                content(Image(uiImage: image!))
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if let cachedImage = ImageCache.shared.get(url.absoluteString) {
                self.image = cachedImage
            } else {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                    ImageCache.shared.set(url.absoluteString, image: downloadedImage)
                }
            }
        }.resume()
    }
}


struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedAsyncImage(url: URL(string: Pokemon.sample().imageUrl)!) { image in
            return image
                .resizable()
                .frame(width: 300, height: 300)
        }
    }
}
