# AppIcon

[![Build Status](https://travis-ci.com/Nonchalant/AppIcon.svg?branch=master)](https://travis-ci.com/Nonchalant/AppIcon)
![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Nonchalant/AppIcon/master/LICENSE.md)
[![GitHub release](https://img.shields.io/github/release/Nonchalant/AppIcon.svg)](https://github.com/Nonchalant/AppIcon/releases)
![Xcode](https://img.shields.io/badge/Xcode-14.2-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-5.7.2-brightgreen.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

`AppIcon` generates `*.appiconset` contains each resolution image for iOS, MacOS.

```
AppIcon.appiconset
├── Contents.json
├── AppIcon-20.0x20.0@2x.png
├── AppIcon-20.0x20.0@3x.png
├── AppIcon-29.0x29.0@2x.png
├── AppIcon-29.0x29.0@3x.png
├── AppIcon-40.0x40.0@2x.png
├── AppIcon-40.0x40.0@3x.png
├── AppIcon-60.0x60.0@2x.png
├── AppIcon-60.0x60.0@3x.png
└── AppIcon-1024.0x1024.0@1x.png
```

## Demo

![](Document/Images/appicon.gif)

## Installation

### Homebrew

```
$ brew install Nonchalant/appicon/appicon
```

### [Mint](https://github.com/yonaskolb/Mint)

```bash
$ mint run nonchalant/appicon
```

### Manual

Clone the master branch of the repository, then run make install.

```
$ git clone https://github.com/Nonchalant/AppIcon.git
$ make install
```

## Usage

`AppIcon` needs path of base image(`.png`). The size of base image is 1024x1024 pixel preferably.

```
$ appicon iTunesIcon-1024x1024.png
```

## Option

You can see options by `appicon --help`.

#### --icon-name

Default: `AppIcon`

#### --output-path

Default: `./AppIcon.appiconset`

#### --mac

Default: false

#### --watch

Default: false

## Develop

### Runs debug build

```
$ make debug
```

### Runs release build

```
$ make build
```

### Runs tests

```
$ make test
```

## Author

Takeshi Ihara <afrontier829@gmail.com>


# AppIcon GitHub Action

This GitHub Action generates app icons for iOS and macOS applications using the AppIcon tool. It can be triggered manually or via a webhook to automatically generate app icons based on a provided image URL.

## Usage

You can use this action in your workflow by adding the following step:

```yaml
- name: Generate App Icons
  uses: ka1ne/AppIcon@v1  # Replace with the latest version
  with:
    icon-source: 'https://example.com/path/to/icon.png'
    output-path: './Assets.xcassets/AppIcon.appiconset'
    icon-name: 'MyAppIcon'
    mac: 'true'
    watch: 'false'
```

### Inputs

- `icon-source` (required): Path or URL of the base icon image (1024x1024 PNG)
- `output-path` (optional): Path where the generated AppIcon.appiconset will be saved (default: './AppIcon.appiconset')
- `icon-name` (optional): Name for the generated icons (default: 'AppIcon')
- `mac` (optional): Generate macOS icons (default: 'false')
- `watch` (optional): Generate watchOS icons (default: 'false')

## Repository Dispatch API Usage

To trigger this action programmatically via GitHub's API, follow these steps:

1. Create a GitHub Personal Access Token (PAT) with `repo` scope.

2. Send a POST request to GitHub's Repository Dispatch API:

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_GITHUB_PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/{owner}/{repo}/dispatches \
  -d '{
    "event_type": "generate-app-icon",
    "client_payload": {
      "icon_source": "https://example.com/path/to/icon.png"
    }
  }'
```

The `client_payload` should contain:
- `icon_source` (required): Path or URL to your 1024x1024 PNG icon

### Example JSON Payload

```json
{
  "event_type": "generate-app-icon",
  "client_payload": {
    "icon_source": "https://example.com/path/to/icon.png"
  }
}
```

Note: The other parameters (`output_path`, `icon_name`, `mac`, `watch`) are configured in the workflow file and cannot be modified via the API payload.

## License

Appicon is available under the MIT license. See the LICENSE file for more info.
