# Stylo

Stylo is a macOS writing and document-editing application built around Markdown,
CSS-driven text styling, document packages, export plugins, and optional audio
tools. It is an open-source snapshot of a mature Xcode codebase that includes
the main app, shared editor frameworks, plugin projects, resources, fonts, and
the bundled help documentation.

The app edits Markdown using a native `.stylo` document format. A `.stylo`
document is a package directory presented by macOS as a single file, so the
document can carry source text, style information, and related resources
together.

## Features

- Markdown editing based on CommonMark, with GitHub-style tables and
  strikethrough support.
- CSS-based editor styles, including light and dark appearances.
- Multiple editor panels for working across several files in one document.
- Tags and Markdown attributes for marking, highlighting, and navigating text.
- Audio recording and playback tools associated with individual text files.
- Export support for plain text, Markdown, HTML, Word, and PDF.
- Bundled user help generated from the documentation in
  `Stylo/Documentation/documentation-en.stylo`.

## Documentation

The GitHub wiki contains the user and contributor documentation:

https://github.com/sebastienh/stylo/wiki

The source help files live in `Stylo/Documentation/documentation-en.stylo`.
Those files are also used by the app's bundled help system.

## Building

1. Clone the repository.
2. Open `Writer.xcworkspace` in Xcode.
3. Let Xcode resolve Swift package dependencies.
4. Select the app or help scheme you want to build.
5. Build with `Product > Build`.

The current snapshot has iCloud capabilities disabled so contributors can build
without an iCloud-enabled Apple Developer Program profile. You may still need to
select your own signing team or local macOS signing configuration in Xcode.

The public workspace currently shares these schemes:

- `Nodio`
- `NodioHelp`
- `StyloHelp`
- framework and test schemes for supporting projects

Some local Xcode installations may also show additional user schemes. The
repository is intentionally conservative about Xcode project changes because
many paths come from the original multi-project workspace.

## Repository Layout

- `Stylo/` - main macOS application sources, app resources, tests, and help docs
- `WriterCommon/` - shared document and editor logic
- `StyloCoreMac/` - macOS UI and editor support framework
- `Common/` - shared lower-level utilities and model helpers
- `Markdown/` - Markdown parsing, rendering, and tests
- `Web/` - DOM, CSS, HTML, and rendering support
- `HtmlExportPlugin/`, `MarkdownExportPlugin/`, `PdfExportPlugin/`,
  `TextExportPlugin/`, `WordExportPlugin/` - export plugin projects
- `StyloAudioPlugin/`, `StyleEditorPlugin/`, `TagsPlugin/` - editor tool plugins
- `Resources/`, `design/`, `google-fonts/` - assets used by the app and docs

Prebuilt plugin bundles, local private design sources, and old vendored
libraries are not required in the public source tree.

## Dependencies

Swift package dependencies are pinned in
`Writer.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

- Stencil
- PathKit
- Spectre
- SwiftProtobuf
- PromiseKit

## Current Project Notes

This repository is a source snapshot prepared for open-source collaboration.
The current focus is to keep the app buildable while gradually cleaning old
workspace assumptions, generated files, and documentation structure.

Known areas for future cleanup:

- Share or recreate any missing public app schemes needed by fresh clones.
- Separate generated documentation from source documentation where practical.
- Continue reducing large historical assets when they are not required to build.
- Replace legacy workspace references only through Xcode-managed project edits.

## Contributing

See `CONTRIBUTING.md` for development setup and contribution guidelines.

## License

Stylo is available under the MIT License. See `LICENSE`.
