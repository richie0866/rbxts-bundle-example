## 📦 Roblox-TS Bundle Example

An example project that bundles the Roblox-TS source into a single file and uploads it to a GitHub release.

There is a `place.project.json` file for development in Roblox Studio. Use the [Rojo VSCode extension](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo) to sync the project.

### ▶️ Run a release

You can run releases with these snippets:

```lua
-- Run the latest release
loadstring(game:HttpGetAsync("https://github.com/richie0866/rbxts-bundle-example/releases/latest/download/main.lua"))()
```

```lua
-- Run a specific release
loadstring(game:HttpGetAsync("https://github.com/richie0866/rbxts-bundle-example/releases/download/0.2.0-alpha/main.lua"))()
```

### 📌 Prerequisites

-   [PNPM](https://pnpm.io/) - A fast, disk space efficient package manager
-   [Aftman](https://github.com/LPGhatguy/aftman) - Install command-line tools and use them seamlessly

### 📦 Bundle

Running `pnpm bundle` creates the following files:

-   `dist/main.lua` - The bundled, minified source
-   `dist/main-dev.lua` - The unminified source with preserved error traceback
-   `dist/main.rbxm` - The Roblox model created by Rojo

### ⚙️ Development

```bash
# Install dependencies
pnpm install

# Install Aftman tools
aftman install

# Build the Luau source or watch for changes
pnpm build/watch

# Bundle the project to dist/main.lua and dist/main-dev.lua
pnpm bundle
```

### ⚠️ Notes

-   Roblox-TS compiles ternary operators to Luau if-then-else expressions, which may not be supported in some environments.

-   150 KB for a text box
