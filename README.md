# Your URLCode project

**A URL that runs your code, and a URL that redirects.** Start with two examples,
then change the YAML and function to build your own project.

There is one starter, containing both examples. If URLCode is already installed,
`urlcode init ../gitroll-link` creates the same route examples; no `--template`
choice is needed. This repository adds a pinned runtime dependency and npm workflow.

## YAML and AI authoring references

This project carries two Claude agent skills at `.claude/skills/`:
`urlcode-authoring` (writing and editing `urlcode.yaml`, functions and
middleware) and `urlcode-operations` (deployment, verifying a live
deployment, capacity, resilience and the management API). A Claude session
opened in this project loads them automatically for a matching task, no
setup needed. Both point at the docs shipped in
`node_modules/@jimhoyd/urlcode/` rather than restating the contract, so
they always match your pinned runtime version, not `main`.

This template also includes `.mcp.json`, which registers the project's
read-only local `urlcode mcp` server for Claude Code and Codex. It lets an
agent inspect this project's routes and validate its changes without guessing.
Keep that local server registered. [URLCode AI](https://urlcode.ai/) is an
optional hosted companion for shared skills and LLM tooling; it never replaces
the local project server. Its machine-readable entry point is
[`https://urlcode.ai/llms.txt`](https://urlcode.ai/llms.txt). If you configure
its authenticated remote MCP, store its bearer token in your MCP client's
secret facility, never in this project.

Use the [YAML cookbook](https://github.com/jimhoyd-com/urlcode/blob/main/docs/YAML-GUIDE.md)
and [field reference](https://github.com/jimhoyd-com/urlcode/blob/main/docs/YAML-REFERENCE.md)
for complete configuration examples. Without the bundled skills, give your AI
assistant the [authoring guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/AI-AUTHORING.md)
and the schema matching your pinned runtime. Future runtime upgrades may change
main-branch docs, so check your installed version before copying new fields.
Operators should read [capacity](https://github.com/jimhoyd-com/urlcode/blob/main/docs/CAPACITY.md)
and [DDoS/recovery](https://github.com/jimhoyd-com/urlcode/blob/main/docs/RESILIENCE.md).

For optional shared skills and hosted LLM tooling, use
[URLCode AI](https://urlcode.ai/). Its remote MCP augments the local,
project-aware `urlcode mcp` server rather than replacing it; keep its bearer
token in your MCP client's secret facility, never in this repository.

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
installs the pinned `@jimhoyd/urlcode` version from the npm registry, with
lockfile integrity verification; network access is needed during installation.
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
for wildcard limits and precedence.

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
values through `context.state`. Under the pinned `0.5.0` runtime
middleware runs trusted and in-process by default, exactly as functions do: a
chain shares one deadline, but not a sandbox unless the route opts in with
`sandbox: true`. The regular redirect keeps its native fast path without
middleware.
See [middleware semantics for this pin](https://github.com/jimhoyd-com/urlcode/blob/v0.5.0/docs/MIDDLEWARE.md)
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

## Short links are not a built-in

The starter's two examples still work without a database. The runtime itself no
longer carries a native `link` handler: `0.4.0-alpha.2` removed it, along with
the top-level `dynamicLinks` switch, in favour of a mount-based extension. That
extension has since been retired and unpublished, so no supported package
provides stored short links today — an application that needs them owns that
storage itself. Nothing in this template depends on them, so there is no opt-in
to set; regular parameterized redirects, functions and middleware never required
them. Store sizing, bounded reader/writer pools and the single-host SQLite
caveat belong to whatever store such an application brings itself: read that
store's own guidance, and check `npm run doctor` for the patched SQLite build
Node needs.

## Grow from here

Declare incoming methods and path/query/header inputs, body size/media-type
checks, outgoing headers and native text/JSON responses in YAML. See the
[HTTP configuration guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/HTTP.md).
The runtime also supports [pages, files and downloads](https://github.com/jimhoyd-com/urlcode/blob/main/docs/ASSETS.md).
These features need no extra example clutter in your starting project.

In the `0.5.0` runtime this template pins, `function` and `middleware`
routes run **trusted and unsandboxed** in the host process, with full Node,
filesystem and network access, exactly like any other project code
([decision record](https://github.com/jimhoyd-com/urlcode/blob/main/docs/SPIKE-DEFAULT-TRUST-MODEL.md)).
Sandboxing is an explicit per-route opt-in: add `sandbox: true` to a route and
it gets the documented text/JSON Request/Response API with no Node, filesystem
or network access, which is what every runtime before `0.4.0-alpha.2` gave
every such route unconditionally.

Treat a `function` or `middleware` route as ordinary trusted code you are
responsible for reviewing. "Trusted" describes the authorship of the code, not
the request. Add `sandbox: true` when a route runs code you have not reviewed or
that came from a third party, when it holds a secret whose blast radius matters,
or when the logic is complex enough that limiting a bug's reach is the margin
you want. The price is real: a sandboxed route gives up `fetch`, Node builtins,
the filesystem and npm, and occupies worker-pool capacity, so do not add it
reflexively. Request data — path, query, headers, cookies, body, webhooks — is
untrusted on **both** paths and must always be validated; `sandbox: true` is
neither input validation nor authentication. The example routes in this template
are trusted deliberately and need no secrets.
Keep any future secret values in ignored `.env.local` locally or injected by your
host; external bindings require a separate operator policy. Read the
[security model for this pin](https://github.com/jimhoyd-com/urlcode/blob/v0.5.0/docs/FUNCTION-SECURITY.md).
Never commit credentials, tokens or session cookies in YAML headers.

This template pins the `0.5.0` published local/self-hosted runtime. Review the
[release-readiness gates](https://github.com/jimhoyd-com/urlcode/blob/v0.5.0/docs/RELEASE-READINESS.md) before deployment. Read the
[operations guide](https://github.com/jimhoyd-com/urlcode/blob/main/docs/OPERATIONS.md)
before deploying. Provider adapters and URLCode Cloud remain future work.

Both this template and the pinned runtime are Apache-2.0 licensed; see each
repository's `LICENSE` file.

## YAML-first scaffolding

After adding references in YAML, run `npm run scaffold -- --dry-run` to preview
missing files, then `npm run scaffold` to create them. Existing files stay intact.
Function/middleware placeholders return 501 until implemented; binary assets and
external bindings are reported for you to supply.
[Full guide](https://github.com/jimhoyd-com/urlcode/blob/v0.5.0/docs/SCAFFOLDING.md).

## Security notes for the pinned runtime

The pinned runtime includes security fixes for failed log collectors, management
HTTP admission/timeouts, and metadata-only development watching. Review the
[security audit and remaining gates](https://github.com/jimhoyd-com/urlcode/blob/v0.5.0/docs/SECURITY-AUDIT.md) before production use.

The pinned runtime includes bounded configuration loading, loopback-only management,
scoped/expiring/revocable operator credentials and atomic mutation audits. Read the
[management security guide](https://github.com/jimhoyd-com/urlcode/blob/v0.5.0/docs/MANAGEMENT-SECURITY.md)
before operating the management endpoint. Independent assessment and deployment acceptance remain open.
