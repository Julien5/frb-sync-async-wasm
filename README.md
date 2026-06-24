# frb-sync-async-wasm

## Summary

On wasm, i get a deadlock when calling a **&mut self** `#[fr(sync)]` function while an async call is running. This happens only on wasm. I am not sure if this can be considered a bug. I suspect it is rather a limitation of wasm and suggest add this to the [documentation](https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/wasm-limitations).

## How to reproduce 

- build with:
```
./scripts/build-web.sh
```
- untar /tmp/webapp.tgz and start the webserver to serve `.../app/build/web/`
- click on realAsyncConst and then quickly on realSyncMut 
  => freeze.
- all other button combinations do not freeze the application.


