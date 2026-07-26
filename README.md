# Cucumber

A card game built with [LÖVE2D](https://love2d.org/) (LÖVE 11.x) and Lua.

## Running the game

LÖVE isn't compiled — it's a Lua runtime that loads a project directory (or a
zipped `.love` file) directly. There's nothing to build.

**Command line**, from the project root:
```
love .
```

**macOS**, without the command line installed: drag the project folder onto
`love.app`, or drag it onto a shortcut of the app.

**VS Code**: this repo already has a `.vscode/launch.json` configured for the
`lua-local` debugger extension — use the "Debug LOVE" run configuration to
launch with breakpoint support.

LÖVE finds the project by convention, not configuration: it looks for
`conf.lua` and `main.lua` at the root of whatever folder (or `.love` file)
you point it at, and calls into them by name (see "How LÖVE runs this
project" below).

To distribute the game outside of a LÖVE install, zip the project root's
contents and rename the archive's extension from `.zip` to `.love` — anyone
with LÖVE installed can then double-click it directly. Producing a
standalone `.exe`/`.app` that doesn't require LÖVE to be installed means
fusing that `.love` file with the LÖVE runtime itself; see the
[LÖVE wiki's Game Distribution page](https://love2d.org/wiki/Game_Distribution)
for the current per-OS steps.

## How LÖVE runs this project

LÖVE doesn't call into your code arbitrarily — it looks for a small, fixed
set of globally-defined functions (`love.load`, `love.update`, `love.draw`,
`love.conf`, the input callbacks, etc.) and calls them at specific points in
its own lifecycle. This project keeps that surface as thin as possible in
`main.lua`, and pushes everything else out into dedicated modules:

1. **`conf.lua`** runs first, before a window even exists. It only sets
   static window config (`t.window.title/width/height`, `t.identity` — the
   name of the save-data folder `love.filesystem` will use).
2. LÖVE opens the window, then runs **`main.lua`** top to bottom once. This
   is where the project's modules get `require`d and cached.
3. LÖVE calls **`love.load()`**, which in this project just delegates:
   sets up the window/virtual resolution (`window.lua`), preloads shared
   images (`assets.lua`), and switches to the `"Splash"` state via
   `statemanager.lua`.
4. From there it's the standard LÖVE loop: `love.update(dt)` → `love.draw()`
   every frame, plus input callbacks (`love.mousepressed`, etc.) firing as
   they happen — both forwarded through `controls.lua`.

## Project structure

```
Cucumber/
├── main.lua           -- LÖVE callbacks only; forwards to the other modules
├── conf.lua             -- love.conf(t): window title/size, save identity
├── window.lua             -- window/resolution setup (push virtual-screen scaling)
├── controls.lua             -- input callbacks -> StateManager, incl. coordinate conversion
├── statemanager.lua           -- registers/switches states; auto-discovers states/*.lua
├── assets.lua                   -- preloads shared images used across states
├── states/
│   ├── base/               -- shared classes that states extend (not switched to directly)
│   │   ├── State.lua          -- root state class: name + background
│   │   └── Menu.lua             -- adds a button list + click/hover routing
│   ├── splash.lua              -- title screen with the Start button
│   └── gameplay.lua              -- the card table
├── entities/
│   ├── Card.lua                 -- a single playing card
│   └── Deck.lua                   -- builds/shuffles/draws all 52 cards
├── ui/
│   └── button.lua                  -- reusable clickable image button
├── lib/                               -- third-party, single-file libraries
│   ├── classic.lua                     -- the Object:extend() class system everything uses
│   └── push.lua                          -- fixed virtual-resolution scaling
└── assets/                                -- images (cards, UI, backgrounds)
```

A few structural notes worth knowing before touching any of this:

- **`statemanager.lua`'s `loadAll()` auto-discovers states.** It scans the
  `states/` folder, `require`s every `.lua` file directly inside it, and
  registers each one under the name its own constructor sets — so adding a
  new screen (e.g. a pause menu) means dropping a file in `states/`, not
  editing `main.lua`. `states/base/` is skipped automatically, since it's a
  subdirectory rather than a `.lua` file at the level being scanned — that's
  also why shared/abstract classes (`State`, `Menu`) live there instead of
  next to the concrete states.
- **Every class in this project is built on `lib/classic.lua`.** The
  pattern is always `local X = Object:extend()` (or `local X = Parent:extend()`
  for a subclass), a `function X:new(...)` constructor, and `X.super` to
  reach the parent's own methods (e.g. `Splash.super.new(self, "Splash")`).
- **`push.lua`** renders the game to a fixed virtual 1080×720 canvas
  regardless of real window size, then scales it to fit. Because of that,
  raw mouse coordinates from LÖVE's input callbacks aren't usable directly —
  `controls.lua` converts them through `push:toGame()` before anything else
  sees them.
