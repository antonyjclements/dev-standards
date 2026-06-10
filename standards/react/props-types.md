# Props Types

Use inline types for simple components, separate types for complex ones.

## Rules

- **3+ props** — Extract to separate type named `ComponentNameProps`
- **1-2 props** — Inline type definition is acceptable
- **Always use named types** — Never use anonymous object types in exports

## Simple Components (Inline)

```typescript
export function TextInput({value, onChange}: {value: string, onChange: (value: string) => void}) {
    return <input value={value} onChange={(e) => onChange(e.target.value)} />
}
```

## Complex Components (Separate Type)

```typescript
type ButtonProps = {
    variant: "primary" | "secondary" | "donate";
    size: "small" | "medium" | "large";
    href?: string;
    onClick?: () => void;
    disabled?: boolean;
}

export function Button({variant, size, href, onClick, disabled}: ButtonProps) {
    return <a onClick={onClick} href={href}>...</a>
}
```

## Naming Convention

- Type name: `ComponentNameProps`
- Place type definition immediately before component
- Export type if used externally

## With PropsWithChildren

```typescript
type ContentRootProps = PropsWithChildren

export function ContentRoot({children}: ContentRootProps) {
    return <div>{children}</div>
}
```
