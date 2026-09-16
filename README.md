# Your URLCode project

**A URL that runs your code, and a URL that redirects.** Start with two examples,
then change the YAML and function to build your own project.

## Run it

Use GitHub's **Use this template** button to create your own repository, or clone:

```sh
git clone https://github.com/jimhoyd-com/urlcode-template.git my-links
cd my-links
npm ci
npm run dev
```

Requires Node.js 22.13+ and npm; CI covers Node 22/24 on Windows, macOS and Linux.
No global install, runtime checkout, account, database or Docker required. npm
installs URLCode from an HTTPS archive of a pinned public Git commit, with
lockfile integrity verification; network access is needed during installation. The runtime has not been published to npm yet.
With Make installed, `make dev` handles installation and startup for you.

Open these URLs:

- **http://127.0.0.1:3000/hello/Ada** runs `functions/hello.mjs`, returning `{"message":"Hello, Ada!"}`.
- **http://127.0.0.1:3000/go** sends a regular redirect to example.com.

Change `urlcode.yaml` or `functions/hello.mjs`; valid edits reload automatically.
Ctrl+C stops the server. In another terminal, `npm test` checks both examples
without following redirects. Change ports with `npm run dev -- --port 3001`.

## What you own

| File | Purpose |
|---|---|
| `urlcode.yaml` | Routes, validated inputs, function arguments and response headers |
| `functions/hello.mjs` | Your request function |
| `tests/requests.json` | Local HTTP assertions you can extend |
| `package.json` / `package-lock.json` | Commands and pinned runtime dependency |
| `Makefile` | Optional shortcuts |
| `.github/workflows/test.yml` | Cross-platform install/validation/HTTP checks |

There is no runtime fork in this project. Upgrade the pinned URLCode dependency
and lockfile deliberately, test, then commit; never regenerate your application
just to upgrade the runtime. Update the schema URL comment to the same revision.
If you cloned instead of using **Use this template**, change the Git remote to your
own repository before pushing your changes.

## Commands

| npm | Make | Purpose |
|---|---|---|
| `npm run dev` | `make dev` | Local server with reload and `.env.local` loading |
| `npm run validate` | `make validate` | Validate configuration and functions |
| `npm test` | `make test` | Run local HTTP assertions |
| `npm start` | `make start` | Fixed server snapshot, no watcher or dotenv |
| `npm run doctor` | `make doctor` | Runtime/platform details |

## Grow from here

Declare incoming methods and path/query/header inputs, body size/media-type
checks, outgoing headers and native text/JSON responses in YAML. See the
[HTTP configuration guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/HTTP.md).
The runtime also supports [pages, files and downloads](https://github.com/jimhoyd-com/urlcode/blob/main/docs/ASSETS.md).
These features need no extra example clutter in your starting project.

Functions run in a sandbox with a documented text/JSON Request/Response API.
They do not have Node, filesystem or network access. No example needs secrets.
Keep any future secret values in ignored `.env.local` locally or injected by your
host; external bindings require a separate operator policy. Read the
[security model](https://github.com/jimhoyd-com/urlcode/blob/main/docs/FUNCTION-SECURITY.md).
Never commit credentials, tokens or session cookies in YAML headers.

This uses the alpha.4 local/self-hosted runtime. Read the
[operations guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/OPERATIONS.md)
before deploying. Provider adapters and URLCode Cloud remain future work.

The license is still undecided. Neither this template nor the runtime selects
license terms yet; public availability does not resolve that decision.
