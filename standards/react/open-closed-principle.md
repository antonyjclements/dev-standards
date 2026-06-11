# Open-Closed Principle

Extend behavior by adding new code, not by modifying existing code. Discriminated unions and factory functions are the mechanism.

## Pattern

```typescript
// ✅ A registry of renderers — adding a block type is a new file + one entry
type ContentBlock =
  | { kind: "text"; body: string }
  | { kind: "image"; src: string; alt: string }
  | { kind: "video"; url: string }

const renderers: { [K in ContentBlock["kind"]]: (block: Extract<ContentBlock, { kind: K }>) => ReactNode } = {
  text: (b) => <TextBlock body={b.body} />,
  image: (b) => <ImageBlock src={b.src} alt={b.alt} />,
  video: (b) => <VideoBlock url={b.url} />,
}
```

Adding `"quote"` means: add the union member, add `QuoteBlock`, add one registry entry. The compiler points at every place that needs the addition; no existing logic is edited.

## Rules

- **New variant = new code + registration**, not edits scattered through existing conditionals.
- **Discriminated unions + exhaustive handling** make the compiler enforce completeness.
- **Factory functions** keep construction extensible the same way (see `typescript/factories`).

## Not This

```typescript
// ❌ Every new block type means editing this function — and every one like it
function renderBlock(block) {
  if (block.type === "text") { ... }
  else if (block.type === "image") { ... }
  // 4 more else-ifs, growing forever, in 3 different files
}
```
