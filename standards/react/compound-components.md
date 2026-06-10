# Compound Component Pattern

Group related components that work together as compound components.

## Pattern

```typescript
// Individual component files
// ContentRoot.tsx
export function ContentRoot({children}: ContentRootProps) {
    return <div className="mx-auto max-w-7xl">{children}</div>
}

// ContentTitle.tsx
export function ContentTitle({title, subtitle}: ContentTitleProps) {
    return <div><h1>{title}</h1>{subtitle && <p>{subtitle}</p>}</div>
}

// index.ts - Compound object export
export const Content = {
    Root: ContentRoot,
    Title: ContentTitle,
    Body: ContentBody,
    Image: ContentImage,
}
```

## When to Use

Group components as compound when they:
- Work together to form a cohesive UI pattern
- Are typically used together in combination
- Share a common domain or purpose

## Usage

```typescript
import { Content } from "@features/slice/content/components/content"

<Content.Root>
    <Content.Title title="Hello" subtitle="World" />
    <Content.Body>
        <Content.Image image={img} />
        <Content.Text text={text} />
    </Content.Body>
</Content.Root>
```

## Benefits

- **Clear relationships** — Grouped components show they work together
- **Namespace organization** — Avoids naming conflicts
- **Discoverable API** — IDE autocomplete shows all related components

## Export Location

- Individual components in separate files
- Compound object exported from `index.ts`
- Object name matches the domain (e.g., `Content`, `Form`)
