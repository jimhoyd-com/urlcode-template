# Your URLCode project

**A URL that runs your code, and a URL that redirects.** Start with two examples,
then change the YAML and function to build your own project.

There is one starter, containing both examples. If URLCode is already installed,
`urlcode init ../gitroll-link` creates the same route examples; no `--template`
choice is needed. This repository adds a pinned runtime dependency and npm workflow.

## YAML and AI authoring references

Use the [YAML cookbook](https://github.com/jimhoyd-com/urlcode/blob/main/docs/YAML-GUIDE.md)
and [field reference](https://github.com/jimhoyd-com/urlcode/blob/main/docs/YAML-REFERENCE.md)
for complete configuration examples. Give your AI assistant the
[authoring guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/AI-AUTHORING.md)
and the schema matching your pinned runtime. Future runtime upgrades may change
main-branch docs, so check your installed version before copying new fields.
Operators should read [capacity](https://github.com/jimhoyd-com/urlcode/blob/main/docs/CAPACITY.md)
and [DDoS/recovery](https://github.com/jimhoyd-com/urlcode/blob/main/docs/RESILIENCE.md).

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
| `middleware/headers.mjs` | Reusable before/after logic around the function |
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

## Organization and readability practices

Keep this starter small, then group related routes/code by feature as it grows.
Use descriptive names, focused middleware, explicit imports/includes and HTTP
assertions. Keep secrets and operator settings separate from route behavior.
See [best practices with complete layout examples](https://github.com/jimhoyd-com/urlcode/blob/main/docs/BEST-PRACTICES.md)
for readable YAML, reusable helpers, test organization and safe refactoring.

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

## Route matching and new links

`/hello/{name}` captures one nonempty segment: `/hello/Ada` matches, but
`/hello/Ada/team` does not. Parameters are not greedy; regex routing is not
supported. Exact routes win before parameter routes, then static mounts.
`dev` automatically swaps validated snapshots after YAML edits; production
`serve` uses a fixed snapshot. See [matching and dynamic links](https://github.com/jimhoyd-com/urlcode/blob/main/docs/ROUTING.md)
for wildcard limits and precedence. Optional [stored links](https://github.com/jimhoyd-com/urlcode/blob/main/docs/DYNAMIC-LINKS.md)
now support live creation/update/deletion without reloading YAML.

## Middleware

The function route declares `middleware: [{source: middleware/headers.mjs}]`.
That module wraps the handler and adds `x-example-middleware: active`:

```js
export default async function headers(request, context, next) {
  const response = await next();
  response.headers.set('x-example-middleware', 'active');
  return response;
}
```

Reuse middleware on other routes, return a response early, or share request-local
values through `context.state`. Every chain shares the function sandbox and one
deadline. The regular redirect keeps its native fast path without middleware.
See [middleware semantics](https://github.com/jimhoyd-com/urlcode/blob/main/docs/MIDDLEWARE.md)
for ordering, native body limits, binding policy and explicit test requirements.

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

## Optional live short links

The starter's two examples still work without a database. When your application
needs visitors to create short links, add a native `link` route and explicitly
bind an external SQLite store. Your trusted backend can call a separate,
token-protected management API; never put that token in browser code. Committed
record changes become visible without restarting the public server. See the
[complete setup and API](https://github.com/jimhoyd-com/urlcode/blob/main/docs/DYNAMIC-LINKS.md).
The first adapter supports one host, including multiple local processes.

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

This pins the hardened alpha.8 local/self-hosted runtime. Review the
[release-readiness gates](https://github.com/jimhoyd-com/urlcode/blob/fba7a65450e02e59ab5a3b515da80c2472559186/docs/RELEASE-READINESS.md) before deployment. Read the
[operations guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/OPERATIONS.md)
before deploying. Provider adapters and URLCode Cloud remain future work.

The license is still undecided. Neither this template nor the runtime selects
license terms yet; public availability does not resolve that decision.

## YAML-first scaffolding

After adding references in YAML, run `npm run scaffold -- --dry-run` to preview
missing files, then `npm run scaffold` to create them. Existing files stay intact.
Function/middleware placeholders return 501 until implemented; binary assets and
external bindings are reported for you to supply.
[Full guide](https://github.com/jimhoyd-com/urlcode/blob/fba7a65450e02e59ab5a3b515da80c2472559186/docs/SCAFFOLDING.md).

## Live-link opt-in

The entry `urlcode.yaml` explicitly sets `dynamicLinks: false`. Change it to true
before adding live `link` handlers and supply the operator store binding. Included
route files cannot override this setting. Regular parameterized redirects,
functions and middleware do not require it. `npm run routes` reports the setting.

Live-link deployment supports separate bounded reader/writer pools through
operator CLI options. SQLite remains single-host and requires a patched SQLite
build bundled with Node; check `npm run doctor`.
[Pool sizing and consistency](https://github.com/jimhoyd-com/urlcode/blob/fba7a65450e02e59ab5a3b515da80c2472559186/docs/DYNAMIC-LINKS.md#separate-reader-and-writer-pools).
