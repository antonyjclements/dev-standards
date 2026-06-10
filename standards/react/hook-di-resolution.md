# DI Resolution in Hooks

Hooks that need dependency injection services use `DependencyInjection.createInstance()` for API access.

## Pattern

```typescript
import { DependencyInjection, ApiConfigSymbol, type ApiConfigType } from "@centrepointmedia/synorahooks";

export function usePage<T extends Page>(type: T["_type"], uid: string) {
    const getPage = useApi<{uid: string}, Extract<Page, {_type: T["_type"]}>>({
        fn: async (props) => {
            const config = await DependencyInjection.createInstance<ApiConfigType>(ApiConfigSymbol);
            return props.client.get<Extract<Page, {_type: T["_type"]}>>(`${config.endpoint}/page?uid=${uid}&type=${type}`);
        },
        cacheKey: ['page', uid],
    })

    return getPage;
}
```

## For Registry Access

Use `SynDiContainer.resolve()` for synchronous registry access:

```typescript
import { SynDiContainer } from "@centrepointmedia/synora-ts";
import { SliceRendererRegistrySymbol } from "@foundation/slice/types";

export function useSliceRegistry() {
    const sliceRegistry = SynDiContainer.resolve<SliceRenderRegistry>(SliceRendererRegistrySymbol);
    return sliceRegistry;
}
```

## Rules

- **API access** — Use `DependencyInjection.createInstance()` for async config resolution
- **Registry access** — Use `SynDiContainer.resolve()` for sync registry resolution
- **Inside async functions** — DI resolution happens inside the `fn` callback for `useApi`

## Not This

```typescript
// ❌ Don't resolve outside async context for API config
export function usePage() {
    const config = DependencyInjection.createInstance<ApiConfigType>(ApiConfigSymbol); // Wrong
    // ...
}

// ✅ Resolve inside async function
export function usePage() {
    const getPage = useApi({
        fn: async (props) => {
            const config = await DependencyInjection.createInstance<ApiConfigType>(ApiConfigSymbol);
            // ...
        }
    })
}
```
