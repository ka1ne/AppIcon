import AppIconCore
import ArgumentParser
import Foundation

enum AppIconError: Error {
    case invalidImageFormat
    case downloadFailed
    case imageExtractionFailed
    case jsonExtractionFailed
}

struct AppIcon: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "appicon",
        abstract: "AppIcon generates *.appiconset contains each resolution image for iOS",
        version: "1.0.6"
    )

    @Argument(help: "The path or URL to the base image (1024x1024.png)")
    var imageSource: String

    @Option(help: "The name of the generated image")
    var iconName = "AppIcon"

    @Option(help: "The path of the generated appiconset")
    var outputPath = "AppIcon"

    @Flag(help: "Generate also Mac icons")
    var mac = false

    @Flag(help: "Generate also Apple Watch icons")
    var watch = false

    func validate() throws {
        guard imageSource.lowercased().hasSuffix(".png") else {
            print(imageSource)
            throw ValidationError("The image should have a .png extension")
        }
    }

    func run() throws {
        let tempImagePath = "/tmp/input_image.png"
        var inputImagePath: String

        if let url = URL(string: imageSource), url.scheme != nil {
            do {
                try downloadImage(from: url, to: tempImagePath)
                inputImagePath = tempImagePath
            } catch {
                print("Download failed with error: \(error.localizedDescription)")
                throw AppIconError.downloadFailed
            }
        } else {
            guard FileManager.default.fileExists(atPath: imageSource) else {
                throw ValidationError("The input image does not exist at the specified path")
            }
            inputImagePath = imageSource
        }

        let outputExpansion = ".appiconset"
        let outputPath = self.outputPath.hasSuffix(outputExpansion) ? self.outputPath : "\(self.outputPath)\(outputExpansion)"
        let platform = Platform(mac: mac, watch: watch)

        do {
            try ImageExtractor.extract(base: inputImagePath, output: outputPath, iconName: iconName, platform: platform)
        } catch {
            print("Image Extraction Error has occurred: \(error.localizedDescription)")
            throw AppIconError.imageExtractionFailed
        }

        do {
            try JsonExtractor.extract(output: outputPath, iconName: iconName, platform: platform)
        } catch {
            print("Json Extraction Error has occurred: \(error.localizedDescription)")
            throw AppIconError.jsonExtractionFailed
        }

        print("\(outputPath) has been generated 🎉")

        if inputImagePath == tempImagePath {
            try? FileManager.default.removeItem(atPath: tempImagePath)
        }
    }

    private func downloadImage(from url: URL, to path: String) throws {
        do {
            let data = try Data(contentsOf: url)
            guard let image = NSImage(data: data), image.isValid else {
                throw AppIconError.invalidImageFormat
            }
            try data.write(to: URL(fileURLWithPath: path))
        } catch let error as AppIconError {
            throw error
        } catch {
            print("Download failed: \(error.localizedDescription)")
            throw AppIconError.downloadFailed
        }
    }
}

do {
    var appIcon = try AppIcon.parse()
    try appIcon.run()
} catch {
    AppIcon.exit(withError: error)
}
