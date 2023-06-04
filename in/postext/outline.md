# Postext
## Requirement Levels
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).
## Pronounciation
"Postext" is a combination of the words "post" and "text", so it's pronounced "pohs-text".
## Definitions
- `EOL` is defined as either **CR** (`0x0D`) or **CRLF** (`0x0D 0x0A`). It is RECCOMENDED you keep to either one of the two forms throughout the written document.
## Design Rules
1. Whatever works best for the other LMLs, we adopt.
2. Unix philosophy is king, postext's one thing well is HTML rendering.
3. We need enough syntax to be hackable without changing the internals.
4. Inline style elements must always be two identical characters together; it's the only way to be sure.
## Features
### Inline
- **Bold**: two (2) `*` (`0x2A`) enclosing text. Converts to `<strong>[...]</strong>`
- **Italic**: two (2) `/` (`0x2F`) enclosing text. Converts to `<em>[...]</em>`
- **Underline**: two (2) `_` enclosing text. Converts to `<span style="text-decoration:underline">[...]</span>`
- **Superscript**: two (2) `^` () enclosing text. Converts to `<sup>[...]</sup>`.
