<script lang="ts">
    import { setContext } from "svelte"
    import { views } from "$lib/exports/client.ts"
    import ClientViewLoader from "$lib/utilities/frz/components/ClientViewLoader.svelte"
    import type { View } from "$lib/utilities/frz/types.ts"
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-expect-error
    const components = views as Record<string, Component>
    let { name, data, renderMode } = $props() as View<Record<string,unknown>>
    const view = $state({ name, data, renderMode })
    setContext("view", view)
</script>

{#each Object.keys(components) as key (key)}
    {#if key === view.name}
        <ClientViewLoader from={components[key]} properties={view.data}/>
    {/if}
{/each}
