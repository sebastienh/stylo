# Contributing

Thanks for your interest in Stylo.

## Development Setup

Use the Xcode workspace:

```bash
open Writer.xcworkspace
```

Build the `Stylo` scheme before opening a pull request.

## Guidelines

- Keep changes scoped to one feature or fix.
- Do not commit local Xcode user data, build products, signing certificates, or provisioning profiles.
- Preserve the existing Xcode project layout unless the change is specifically about project organization.
- Include a short explanation of behavior changes in pull requests.

## Signing

Do not commit personal signing material. If Xcode asks for a signing team,
select your own Apple account locally.
