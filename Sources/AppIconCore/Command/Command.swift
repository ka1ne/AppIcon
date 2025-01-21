import Foundation
import SwiftShell

enum Command {
    case createDirectory(output: String)
    case extractImage(base: String, output: String, size: Float)
    case createJSON(json: String, output: String)

    func execute() throws {
        switch self {
        case .createDirectory(let output):
            try execute("/bin/mkdir", "-p", output)
        case .extractImage(let base, let output, let size):
            #if os(macOS)
                try execute("/usr/bin/sips", "-Z", "\(size)", base, "--out", output)
            #else
                // Use ImageMagick's convert command on Linux
                try execute("/usr/bin/convert", base, "-resize", "\(Int(size))x\(Int(size))", output)
            #endif
        case .createJSON(let json, let output):
            let writefile = try open(forWriting: output, overwrite: true)
            writefile.write(json)
            writefile.close()
        }
    }

    private func execute(_ executable: String, _ args: String...) throws {
        print("Executing: \(executable) \(args.joined(separator: " "))")
        let runOutput = run(executable, args)

        if !runOutput.succeeded {
            print("Command failed with error: \(runOutput.stderror)")
            throw LocalError.execution
        }
    }
}
