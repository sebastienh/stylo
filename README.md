# Stylo

Stylo is a macOS writing and document-editing application. This repository is
a clean monorepo snapshot of the app, shared frameworks, export plugins,
resources, and documentation.

## Repository Layout

- `Stylo/` - main macOS application target, app resources, documentation, and tests
- `WriterCommon/` - shared application/editor logic
- `Common/` - low-level shared utilities
- `Web/` - DOM, CSS, and HTML-related model/rendering code
- `Markdown/` - Markdown parsing and rendering code
- `StyloCoreMac/` - macOS UI/editor support framework
- `HtmlExportPlugin/`, `MarkdownExportPlugin/`, `PdfExportPlugin/`, `TextExportPlugin/`, `WordExportPlugin/`, `StyloAudioPlugin/`, `StyleEditorPlugin/`, `TagsPlugin/` - app plugins
- `Libraries/` - vendored dependencies and support libraries that are still required by the Xcode workspace
- `Resources/`, `design/`, `google-fonts/` - shared assets used by the projects

## Building

1. Open `Writer.xcworkspace` in Xcode.
2. Select the main `Stylo` scheme.
3. Build with `Product > Build`.

The current snapshot has iCloud capabilities disabled so contributors can build
without needing an iCloud-enabled Apple Developer Program profile. For local
development, each contributor may still need to select their own signing team
or choose a local macOS signing configuration in Xcode.

## Dependencies

The project currently uses a mix of workspace projects, vendored code, and
package dependencies, including:

- Stencil
- PathKit
- Spectre
- SwiftProtobuf
- PromiseKit

The monorepo intentionally keeps the existing project layout to avoid breaking
old Xcode relative paths. Dependency cleanup can be done later in smaller,
verifiable steps.

## License

Stylo is available under the MIT License. See `LICENSE`.
