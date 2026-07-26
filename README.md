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
   name of the save-data folder `love.filesystem` will use). This is the one
   file LÖVE requires to sit at the project root — it's loaded by a
   hardcoded path before `main.lua` even runs, not via `require()`, so
   unlike every other module in this project it can't be relocated.
2. LÖVE opens the window, then runs **`main.lua`** top to bottom once. This
   is where the project's modules get `require`d and cached.
3. LÖVE calls **`love.load()`**, which in this project just delegates:
   sets up the window/virtual resolution (`core/window.lua`), preloads
   shared images (`core/assets.lua`), and switches to the `"Splash"` state
   via `core/statemanager.lua`.
4. From there it's the standard LÖVE loop: `love.update(dt)` → `love.draw()`
   every frame, plus input callbacks (`love.mousepressed`, etc.) firing as
   they happen — both forwarded through `core/controls.lua`.

## Project structure

```
Cucumber/
├── main.lua                    -- LÖVE callbacks only; forwards to the other modules
├── conf.lua                    -- love.conf(t): window title/size, save identity (must stay at root)
├── core/                       -- engine glue: no gameplay logic lives here
│   ├── window.lua              -- window/resolution setup (push virtual-screen scaling)
│   ├── controls.lua            -- input callbacks -> StateManager, incl. coordinate conversion
│   ├── statemanager.lua        -- registers/switches states; auto-discovers states/*.lua
│   └── assets.lua              -- preloads the images shared between states (title, start button)
├── states/                     -- one file per screen; each returns a class
│   ├── base/                   -- shared classes that states extend (not switched to directly)
│   │   ├── State.lua           -- root state class: stores name + background
│   │   └── Menu.lua            -- adds a button list + click/hover routing
│   ├── splash.lua              -- title screen with the Start button
│   └── gameplay.lua            -- the card table; owns a Deck
├── entities/                   -- game objects
│   ├── Card.lua                -- a single playing card: front/back art, flip, hit-test
│   └── Deck.lua                -- builds/shuffles all 52 cards; drag + double-click-to-flip
├── ui/
│   └── button.lua              -- reusable clickable image button
├── lib/                        -- third-party, single-file libraries (vendored)
│   ├── classic.lua             -- the Object:extend() class system everything uses
│   └── push.lua                -- fixed virtual-resolution scaling
├── assets/
│   ├── title.png               -- splash-screen logo
│   ├── GreenFeltBackground.png -- card-table background
│   ├── cards/PNG/              -- CardsLarge/ (52 faces) + CardsBack/ (backs, per color)
│   └── UI/                     -- Kenney UI pack: PNG/<Color>/Default/ buttons, Font/ TTFs
├── .vscode/launch.json         -- "Debug LOVE" config for the lua-local extension
└── .gitignore
```

A few structural notes worth knowing before touching any of this:

- **`core/` holds the project's engine-glue modules** — window setup,
  input routing, state registry, shared asset preloading. None of it is
  gameplay; it's the plumbing `main.lua` used to do inline before getting
  split out. `conf.lua` is the one exception that stays at the root instead
  of joining them, for the hard technical reason above (LÖVE won't find it
  anywhere else).
- **Asset loading is split between `core/assets.lua` and the objects
  themselves.** `assets.load()` only preloads what more than one state needs
  (currently the title image and the start-button sprite, both used by
  `states/splash.lua`). Everything else is loaded by whoever owns it —
  `states/gameplay.lua` builds its background image in its constructor, and
  each `Card` calls `love.graphics.newImage` for its own front and back.
- **`assets/` is mostly untouched third-party art.** `cards/` and `UI/` are
  drop-in Kenney packs, kept in their original folder layout (including
  `License.txt`) so they can be re-downloaded and replaced wholesale; code
  reaches into them by path, e.g.
  `assets/cards/PNG/CardsLarge/card_hearts_A.png`. Only `title.png` and
  `GreenFeltBackground.png` are project-specific and sit at the top level.
- **`.vscode/` and `.sfdx/` are both gitignored.** `.vscode/launch.json`
  exists locally and is what the "Debug LOVE" configuration above refers to,
  but it isn't tracked — a fresh clone won't have it. `.sfdx/` is leftover
  Salesforce CLI tooling with nothing to do with this game; ignore it.
- **`core/statemanager.lua`'s `loadAll()` auto-discovers states.** It scans
  the `states/` folder, `require`s every `.lua` file directly inside it, and
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
  `core/controls.lua` converts them through `push:toGame()` before anything
  else sees them.

## Current state of the game

There are no rules implemented yet — "Cucumber" is so far a card *table*, not
a card game. What works today:

- **Splash** draws the title over a white background with a single START
  button that switches to `Gameplay`.
- **Gameplay** builds a shuffled 52-card deck stacked in the middle of the
  screen. Drag a card with the left mouse button to move it (grabbing also
  raises it to the top of the draw order); double-click a card to flip it
  face up or face down.

Two loose ends to know about if you pick this up:

- `states/base/State.lua` stores a `background` image, and
  `states/gameplay.lua` passes `GreenFeltBackground.png` into it, but nothing
  ever draws that field — so the felt never actually appears on screen.
- `entities/Deck.lua` seeds `math.randomseed` from `os.time()` plus the bytes
  of the literal string `"username"`, which is a placeholder rather than a
  real per-player value.
