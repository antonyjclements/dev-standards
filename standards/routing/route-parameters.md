# Route Parameters

Always validate route parameters and handle missing parameters with error states.

## Pattern

```typescript
import { useParams } from "react-router-dom";

export function ClassPage() {
    const {slug, group} = useParams();
    
    if(!slug) {
        return <div>Not found</div>
    }

    const {value: page, isLoading} = usePage<ClassType>("class", slug);

    if(isLoading || !page) {
        return <Loader />
    }

    return <>
        <Hero title={page.data.title} />
        <BodyRenderer body={page.data.body} />
        <Footer />
    </>
}
```

## Rules

- **Always validate required params** — Check params exist before using them
- **Early return for missing params** — Show error/not-found immediately
- **Use TypeScript destructuring** — Extract params with `const {slug} = useParams()`
- **Optional params** — Can be undefined, handle gracefully

## Parameter Validation

**Required parameter:**
```typescript
const {slug} = useParams();
if(!slug) {
    return <div>Not found</div>  // or <NotFound />
}
// Safe to use slug here
```

**Optional parameter:**
```typescript
const {slug, group} = useParams();
// slug is required, group is optional
if(!slug) return <div>Not found</div>

// Use group conditionally
const breadcrumbs = group ? [...] : [...]
```

## Not This

```typescript
// ❌ No validation - will error if slug is undefined
export function ClassPage() {
    const {slug} = useParams();
    const page = usePage("class", slug);  // Error if slug is undefined
}

// ❌ Using params without destructuring
export function ClassPage() {
    const params = useParams();
    const page = usePage("class", params.slug);  // Less clear
}
```
