# Hook Return Patterns

Data-fetching hooks return consistent object shapes with `value`, `isLoading`, and `error`.

## Data-Fetching Hooks

```typescript
export function usePage<T extends Page>(type: T["_type"], uid: string) {
    const getPage = useApi<{uid: string}, Extract<Page, {_type: T["_type"]}>>({
        fn: async (props) => { ... },
        cacheKey: ['page', uid],
    })

    return {
        value: getPage.value,
        isLoading: getPage.isLoading,
        error: getPage.error
    };
}
```

## Utility Hooks

Return objects or primitives based on what the hook provides:

```typescript
// Object return
export function useCss() {
    const colorMode = useColorMode();
    return {
        colorMode,
        bg: colorMode === "dark" ? "bg-gray-900" : "bg-gray-200",
        text: colorMode === "dark" ? "text-gray-50" : "text-gray-900",
    }
}

// Primitive return
export function useColorMode(): "dark" | "light" {
    return useSyncExternalStore(subscribe, getSnapshot, () => "light");
}
```

## Rules

- **Data-fetching hooks** — Return `{value, isLoading, error}`
- **Utility hooks** — Return objects or primitives as appropriate
- **Consistent naming** — Use `value` for data, `isLoading` for loading state, `error` for errors

## Usage

```typescript
function MyComponent() {
    const {value: page, isLoading, error} = usePage("faculty", "faculty");
    
    if (isLoading) return <Loader />;
    if (error) return <Error message={error.message} />;
    return <div>{page.title}</div>;
}
```
