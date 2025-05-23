import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

let sourcemap: false | "inline" = false;

if ("1" === (process.env.DEV ?? "")) {
  sourcemap = "inline";
}

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    svelte({
      compilerOptions: {
        css: "injected",
      },
    }),
  ],
  resolve: {
    alias: {
      $frizzante: "./.frizzante/vite-project/lib",
      $lib: "./lib",
    },
  },
  build: {
    sourcemap,
    rollupOptions: {
      input: {
        index: "./.frizzante/vite-project/index.html",
      },
    },
  },
});
