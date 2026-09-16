# Your URLCode project

**A URL that runs your code, and a URL that redirects.** Start with two examples,
then change the YAML and function to build your own project.

## Run it

Use GitHub's **Use this template** button to create your own repository, or clone:

```sh
git clone https://github.com/jimhoyd-com/urlcode-template.git gitroll-link
cd gitroll-link
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

Change a file under `routes/` or `functions/hello.mjs`; valid edits reload automatically.
`urlcode.yaml` selects which route files to load.
Ctrl+C stops the server. In another terminal, `npm test` checks both examples
without following redirects. Change ports with `npm run dev -- --port 3001`.

## What you own

| File | Purpose |
|---|---|
| `urlcode.yaml` | Entry point listing the route files to load |
| `routes/functions.yaml` | Function example, inputs, arguments and response headers |
| `routes/marketing/links.yaml` | Regular redirect example in a nested folder |
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

## Organize routes your way

This starter demonstrates multiple files without adding more routes:

```text
urlcode.yaml
routes/
  functions.yaml
  marketing/
    links.yaml
functions/
  hello.mjs
```

The entry point loads explicit project-relative files:

```yaml
version: "1"
includes:
  - routes/functions.yaml
  - routes/marketing/links.yaml
routes: {}
```

Each included file has its own `version: "1"` and `routes` mapping. Folder names
are your choice: organize by feature, team, campaign, customer or any layout that
helps you. Folders do not add URL prefixes. You can rename/move these YAML files
and update the include list, or put both routes directly in `urlcode.yaml` and
remove `includes`. You can also mix inline routes with included files.

Paths such as `source: functions/hello.mjs` always resolve from the project root,
not from the YAML file's folder. Duplicate route paths fail validation rather than
overriding each other. Includes are explicit files, not folder scans/globs; all
includes belong in the entry point (nested includes are not supported).
`npm run routes`, `npm test` and `npm run audit` operate on the combined project;
the expected count stays **2**. More examples are in the
[organization guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/ORGANIZATION.md).

## Method defaults

Omit `methods` for ordinary links: **GET and HEAD are allowed by default**.
Declare methods only when a route needs something different:

```yaml
routes:
  /go:
    redirect:
      url: https://example.com
  /submit:
    methods: [POST]
    function:
      source: functions/submit.mjs
```

Create `functions/submit.mjs` before adding that route. Use uppercase HTTP method
names. An explicit list replaces the defaults: `[POST]` allows only POST;
`[GET, HEAD, POST]` allows all three. Other methods receive 405 with an Allow header.
Redirects default to status 302, and responses default to `Cache-Control: no-store`,
so the starter omits those declarations too.

## Are my links ready?

```sh
npm run routes
npm test
npm run audit
npm run benchmark -- --requests 1000 --concurrency 2
```

`routes` lists route counts, handlers, methods and active/disabled/expired state.
`test` checks your explicit expected responses. `audit` adds automatic native
checks and verifies every active route/method has a passing example. This starter
expects **exactly 2 configured routes**; update `--expect-routes` in package.json
intentionally when your app grows. Missing tests, failed responses or a wrong
count fail the command and CI. Add business assertions in `tests/requests.json`: status-only successes do not
count toward coverage without a body or header assertion.

`benchmark` measures local GET/HEAD response latency, throughput, errors and
completed request counts; it does not follow external redirects. Add
`--max-p95-ms 50` when you have chosen a measured latency budget. A default run
is not a production capacity guarantee. Make equivalents: `make routes`,
`make audit`, `make benchmark ARGS='--requests 1000 --concurrency 2'`.

See the [readiness checklist](https://github.com/jimhoyd-com/urlcode/blob/main/docs/READINESS.md)
for invalid-input, HEAD/cache/range, expiry, reload, security, load, deployment
and rollback checks. Remote destination health, DNS/TLS and sustained soak
checks remain separate work; a local passing audit is not production certification.

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

This uses the alpha.5 local/self-hosted runtime. Read the
[operations guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/OPERATIONS.md)
before deploying. Provider adapters and URLCode Cloud remain future work.

The license is still undecided. Neither this template nor the runtime selects
license terms yet; public availability does not resolve that decision.
