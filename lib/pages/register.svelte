<style>
    article {
        max-width: 30rem;
    }

    .LoginTitle, .AdditionalOptions {
        text-align: center;
    }

</style>

<script>
    import Layout from "$lib/components/Layout.svelte";
    import {getContext} from "svelte";
    import Form from "$frizzante/components/Form.svelte";
    import Center from "$lib/components/Center.svelte";

    const path = getContext("path")
</script>

<Layout title="Register">
    <Center>
        <article>
            <h1 class="LoginTitle">Register</h1>
            <Form>
                <input type="email" name="id" placeholder="Email" aria-label="Email">
                <input type="text" name="displayName" placeholder="Display Name" aria-label="DisplayName">
                <input type="password" name="password" placeholder="Password" aria-label="Password">
                <button type="submit">Continue</button>
                <p class="AdditionalOptions">
                    or <a href={path("login")}>login</a>
                </p>
            </Form>
        </article>
    </Center>
</Layout>