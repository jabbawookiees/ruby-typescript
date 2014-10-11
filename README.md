Ruby TypeScript
=================

This is a wrapper that uses the [TypeScript](https://github.com/Microsoft/TypeScript) developed by Microsoft.

That is, it runs TypeScript as a separate process to compile things.

## Dependencies

You must have TypeScript installed (i.e. you can run the command `tsc`).

Alternatively, you can set the `TYPESCRIPT_SOURCE_PATH` environment variable to the location
of the tsc script (e.g. `~/.npm/typescript/1.1.0-1/package/bin/tsc`) and it'll use that through node.
