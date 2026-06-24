# frb-sync-async-wasm


## Summary

On wasm, i get a deadlock when calling a **&mut self** `#[fr(sync)]` function while an async call is running. This happens only on wasm. 

## How to reproduce 

- version
```
flutter_rust_bridge_codegen 2.12.0
```

This repos is setup using
```
flutter_rust_bridge_codegen create my_app
```

- build with:
```
./scripts/build-web.sh
```
- untar /tmp/webapp.tgz and start the webserver to serve `<path>/app/build/web/`
- open firefox, click on `realAsyncConst`, which calls:
```
    pub async fn realAsyncConst(&self) {
        log::trace!("[1]");
        sleep(std::time::Duration::from_millis(1000)).await;
        log::trace!("[2]");
    }
```
- and then quickly on `realSyncMut`, which calls
```
    #[frb(sync)]
    pub fn realSyncMut(&mut self) -> String {
        self.count = 1;
        format!("count={}", self.count)
    }
```

The application is frozen.
  
All other button combinations do not freeze the application.

## Hypothesis

After reading [this](https://github.com/fzyzcjy/flutter_rust_bridge/issues/1910) and [this](https://github.com/fzyzcjy/flutter_rust_bridge/issues/1917) related issues, I am not sure if this can be considered a bug. I suspect it is rather a limitation of wasm and suggest updating the [documentation](https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/wasm-limitations) accordingly, like:

> If you use async function on wasm, avoid defining synchronous functions with `#[frb(sync)]`, since it might deadlock if started while an async function is running. Use the frb async default:
> ```
>     pub async fn pseudoSyncMut(&mut self) -> String {
>         self.count = 1;
>         format!("count={}", self.count)
>     }
> ```	
> On the dart side, the caller must `await` the result.

	
