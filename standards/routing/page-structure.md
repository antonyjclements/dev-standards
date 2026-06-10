# Page Component Structure

All page components follow a consistent structure: data fetching, loading state, then Hero + BodyRenderer + Footer.

## Pattern

```typescript
import { usePage } from "@features/pages";
import { Hero } from "@foundation/ui/hero";
import { BodyRenderer } from "@features/body/components/BodyRenderer";
import { Footer } from "@foundation/ui/footer";
import { Loader } from "@foundation/ui";

export function HomePage() {  
    const {value: page, isLoading} = usePage('page', 'home')

    if(isLoading || !page) {
        return <Loader />
    }

    return <>
        <Hero title={page.data.title} subtitle={page.data.subtitle} />
        <BodyRenderer body={page.data.body ?? []} />
        <Footer />
    </>
}
```

## Required Structure

1. **Data fetching** — Use `usePage()` hook at component top
2. **Loading state** — Check `isLoading` and `!page`, return `<Loader />`
3. **Hero section** — Page title and subtitle
4. **Body content** — `<BodyRenderer>` for Prismic slices/content
5. **Footer** — Always include `<Footer />` at bottom

## Rules

- **Always show Loader** — During loading state, display `<Loader />`
- **No early returns after loading** — Once loaded, render full structure
- **Hero + BodyRenderer + Footer** — Required for all pages

## Not This

```typescript
// ❌ Missing loading state
export function HomePage() {
    const {value: page} = usePage('page', 'home')
    return <div>{page?.data.title}</div>  // Will error if page is undefined
}

// ❌ Missing Footer
export function HomePage() {
    return <>
        <Hero title="..." />
        <BodyRenderer body={[]} />
        {/* Missing Footer */}
    </>
}
```
