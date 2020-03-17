# Lunarbox
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Tool to help begginers learn functional programming

## Contributing

Fork this repo, write some code and submit a pull request.

## Tehnologies:

This project is mostly made in the [puresciprt](https://www.purescript.org) programming language using [haolgen](https://github.com/purescript-halogen/purescript-halogen) for web rendering.

For installing dependencies this project uses:

- [pnpm](https://pnpm.js.org) for the js dependencies
- [spago](https://github.com/purescript/spago) for the purescript dependencies

For the compilation this project uses [parcel](https://parceljs.org) to bundle the js, [scss](https://sass-lang.com) and the assets and [spago](https://github.com/purescript/spago) to compile the purescript.

## Installing locally

### Installing the dependencies

Clone this repo. Install the dependencies with:

```sh
pnpm install
```

> Note: this project uses [pnpm](https://pnpm.js.org), pull requests using npm or yarn will be ignored

> Note: You also need to have purescript installed, in the future I might add purescript as a dev dependency, but I'm not sure if that would break anything.

### Running the dev server:

To start the dev server use the `dev` command:

```sh
pnpm run dev
```

> Note: the first build might take a long time, this is caused by the fact spago will have to install all it's dependencies

## Strucure & architecture

TODO

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/Mateiadrielrafael"><img src="https://avatars0.githubusercontent.com/u/39400800?v=4" width="100px;" alt=""/><br /><sub><b>Matei Adriel</b></sub></a><br /><a href="https://github.com/Mateiadrielrafael/lunarbox/commits?author=Mateiadrielrafael" title="Code">💻</a> <a href="#design-Mateiadrielrafael" title="Design">🎨</a> <a href="#infra-Mateiadrielrafael" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="http://xwafl.github.io/portfolio"><img src="https://avatars2.githubusercontent.com/u/35458851?v=4" width="100px;" alt=""/><br /><sub><b>xWafl</b></sub></a><br /><a href="#design-xWafl" title="Design">🎨</a> <a href="#ideas-xWafl" title="Ideas, Planning, & Feedback">🤔</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!