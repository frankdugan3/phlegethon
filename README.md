# Phlegethon

> ️⚠️ THIS LIBRARY IS HIGHLY EXPERIMENTAL!!

The right API is still being discovered, balance of explicit/implicit configuration, etc.

> 🔥🔥🔥 THERE WILL BE BREAKING CHANGES!! 🔥🔥🔥

This is the time to get it right: Refactor and break the API for a polished UX.

## Goals

- Component tooling
  - Configurable prop defaults with dead-simple override merging
  - Smart `Tailwind` class merging
  - Drop-in replacements for `core_components.ex` generated by `Phoenix`
  - Smart components for Ash
- Declarative UI extension for Ash resources
- Maximal flexibility
  - Application defaults through presets & custom overrides
  - Bespoke configuration _in_ resources
  - Components allow overriding defaults through props
- **_Clean_**, standards-compliant HTML markup
  - Avoid senseless `div`s
  - Use the right tag(s) for the job
- Progressive enhancement
  - Don't _require_ JS (where possible)
  - Use JS to _enhance_ UX (where sensible)
  - No external JS dependencies
  - Should be able to bundle with ESBuild (no Node/NPM).
- Accessible
- Responsive
- Built-in `i18n` via `gettext` (internationalization)

## Development

As long as Elixir is already installed:

```sh
git clone git@github.com:frankdugan3/phlegethon.git
cd phlegethon
mix setup
iex -S mix phx.server
```

Be sure to check out the generated docs:

```sh
mix docs -f html --open
```

If you want to help, here's what you can PR no questions asked:

- [Open issues on Github](https://github.com/frankdugan3/phlegethon/issues)
- Things marked with `TODO:` in the codebase itself
- Fixes to obvious bugs/flaws
- Improvements to sloppy/redundant code
- Improvements to macros/compilers/generators/patchers
- Documentation improvements/more examples
- More tests/coverage, especially for components
- Getting `mix check` to pass 100%

Also open to more component ideas. Since it's easy to make your own components, there's little risk to writing your own then tossing the idea here to see if we want to pull it in officially. There is an issue template for component proposals.

## Installation (In _Your_ App)

See the [Get Started](documentation/tutorials/get-started.md) guide for installation instructions.

## Prior Art

- [petal](https://petal.build/): Petal is an established project with a robust set of components, and served as a substantial inspiration for this project.
- [Surface UI](https://surface-ui.org/): Surface changed the game for LiveView. Many of its improvements have made it upstream, with the exceptions of special handling of classes and code patching tooling. Phlegethon has already tackled classes, and there are plans to do the same for code patching. [#4](https://github.com/frankdugan3/phlegethon/issues/4)
- [AshAuthenticationPhoenix](https://github.com/team-alembic/ash_authentication_phoenix): The component override system is pretty awesome, and directly inspired Phlegethon's override system.
