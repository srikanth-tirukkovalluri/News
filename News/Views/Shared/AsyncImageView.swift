//
//  AsyncImageView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import SwiftUI

// A reusable view to load an image from a URL with loading and error states.
struct AsyncImageView: View {
    let url: URL? // The URL of the image to load (Optional for flexibility)
    let contentMode: ContentMode // How the image should scale within its frame (e.g., .fit, .fill)
    let width: CGFloat?     // Optional fixed width for the image/placeholder
    let height: CGFloat?    // Optional fixed height for the image/placeholder
    
    // Initializer to make the view easy to configure
    init(url: URL?, contentMode: ContentMode = .fit, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.url = url
        self.contentMode = contentMode
        self.width = width
        self.height = height
    }
    
    var body: some View {
        // AsyncImage handles the asynchronous loading and provides phases
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                // MARK: Inline Spinner while Downloading
                // Display a ProgressView (spinner) when the image is still loading.
                if url == nil {
                    // If url isn't provided, display a placeholder icon
                    placeholderImage(color: .gray, accessibilityLabel: "Image not provided")
                } else {
                    ProgressView()
                        .frame(width: width, height: height) // Apply specified size for consistent layout
                        .foregroundColor(.gray) // Customize spinner color
                        .accessibilityLabel("Loading image") // Provide accessibility label for screen readers
                }
            case .success(let image):
                // MARK: Display Loaded Image
                // Once successfully downloaded, display the image.
                image
                    .resizable() // Make the image resizable
                    .aspectRatio(contentMode: contentMode) // Apply the chosen content mode
                    .frame(width: width, height: height) // Apply the frame size
                    .clipped() // Clip any content that overflows the frame
                    .transition(.opacity.animation(.easeIn(duration: 0.2))) // Optional: Fade-in effect
                
            case .failure(let error):
                // MARK: Error Placeholder
                // If loading fails, display a placeholder icon and potentially the error.
                placeholderImage(color: .red, accessibilityLabel: "Image failed to load: \(error.localizedDescription)")
            @unknown default:
                // Fallback for any future, unknown AsyncImagePhase cases
                EmptyView()
            }
        }
    }
    
    func placeholderImage(color: Color = .gray, accessibilityLabel: String = "") -> some View {
        Image(systemName: "photo.fill") // Generic image placeholder icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .foregroundColor(color)
            .opacity(0.6)
            .accessibilityLabel(accessibilityLabel) // Detailed accessibility
    }
}

#Preview {
    AsyncImageView(url: URL(string: "https://deadline.com/wp-content/uploads/2025/07/MCDFAFO_WD046.jpg?w=1024"))
}
