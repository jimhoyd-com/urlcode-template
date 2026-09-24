# Your URLCode project

This is a bare, agent-ready URLCode scaffold. It starts with no routes so your
application's YAML and tests describe only the behavior you intend to ship. It
does not create routes, functions, or middleware; its single fixture only
checks the default 404 response.

## Start here

Use GitHub's **Use this template** button to create your own repository, or
clone it locally:

```sh
git clone https://github.com/jimhoyd-com/urlcode-template.git my-links
cd my-links
npm ci
npm run dev
```

`npm ci` installs the pinned URLCode runtime; run it before using the npm
commands, Make shortcuts, or the local MCP server. Restart your coding client
after installation if it reported the MCP server as unavailable.

In another terminal, run:

```sh
npm test
npm run validate
npm run routes
npm run audit
```

The initial `/missing` fixture is only a 404 smoke check. With no active routes,
`npm run audit` intentionally reports `no-active-routes` and exits nonzero. The
included GitHub workflow permits only that initial audit result. After adding
your first route, add its request fixture, update the route count deliberately,
and remove the empty-project exception from the workflow.

## Build your application

Start with the local MCP `get_context` tool (or `npm exec -- urlcode context
--project . --budget 500`), then add the smallest declarative route or custom
code the task requires. Add a fixture alongside each route, including its
active methods and `HEAD` behavior where applicable. Assert meaningful output
with `expectBody` or `expectHeaders`, not only a status code.

`urlcode.yaml` is the project entry point. Add route files to its `includes`
list only when you need them; source paths always resolve from the project root.
The installed runtime owns routing, validation, middleware wiring, policies,
static serving, and authentication. Keep secrets out of the repository and
request named bindings from the operator when code needs them.

## Commands

| npm | Make | Purpose |
|---|---|---|
| `npm run dev` | `make dev` | Local server with reload and `.env.local` loading |
| `npm start` | `make serve` | Fixed server snapshot, without local dotenv |
| `npm run validate` | `make validate` | Validate YAML and local bindings |
| `npm test` | `make test` | Run HTTP assertions |
| `npm run routes` | `make routes` | List effective routes |
| `npm run audit` | `make audit` | Check route coverage and readiness |
| `npm run doctor` | `make doctor` | Show runtime and platform details |

The Make shortcuts use the project-local runtime after `npm ci`; set `URLCODE`
only when you intentionally need another runtime executable. The expected audit
count lives in `package.json`; update it when you add or remove routes.

## AI authoring

`.mcp.json` registers the read-only, local `urlcode mcp` server for Codex and
Claude Code. It is project-aware and should remain registered. URLCode AI is an
optional hosted companion for shared skills and LLM tooling; it augments rather
than replaces the local MCP server. Store any hosted-service token only in your
MCP client's secret facility, never in this project.

The bundled `.claude/skills/` and [AGENTS.md](AGENTS.md) describe the matching
authoring and operations workflow. They use the installed runtime rather than
main-branch documentation, so their contract stays aligned with the pinned
version.

## Deployment and security

This repository contains no runtime fork, account configuration, or provider
credentials. Upgrade the pinned runtime and lockfile deliberately, validate,
then commit. Before deployment, read URLCode's
[security guidance](https://github.com/jimhoyd-com/urlcode/blob/main/docs/FUNCTION-SECURITY.md)
and [readiness checklist](https://github.com/jimhoyd-com/urlcode/blob/main/docs/READINESS.md).
