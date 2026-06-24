# Sync call while async is running might cause freeze on wasm

There is a deadlock when calling a `#[fr(sync)]` function that mutates data while an async call is running. This happens only on wasm. I am not sure if this should be considered a bug or a limitation of wasm. If this cannot be fixed, I suggest updating the documentation.

## How to reproduce 

I have setup a [minimal project](https://github.com/Julien5/frb-sync-async-wasm/) to reproduce the freeze.

Version: 
- flutter_rust_bridge_codegen 2.12.0
- flutter 3.44.1

### Build 

Run:
```
./scripts/build-web.sh
```
- unpack /tmp/webapp.tgz and start the webserver to serve `<path>/app/build/web/`

### Reproduce 

- Open Firefox (tested with firefox 152.0).
- Click on `realAsyncConst` button, which calls:
```
    pub async fn realAsyncConst(&self) {
        log::trace!("[1]");
        sleep(std::time::Duration::from_millis(1000)).await;
        log::trace!("[2]");
    }
```
- and quickly after on the `realSyncMut` button, which calls
```
    #[frb(sync)]
    pub fn realSyncMut(&mut self) -> String {
        self.count = 1;
        format!("count={}", self.count)
    }
```
The application freezes. 
  
Other button combinations do not freeze the application.

With firefox, the application freezes. With chrome, the application does not freeze, it reports the `OnAtomics.wait cannot be called in this context` error.

## Hypothesis

After reading [this](https://github.com/fzyzcjy/flutter_rust_bridge/issues/1910) and [this](https://github.com/fzyzcjy/flutter_rust_bridge/issues/1917) related issues, I am not sure if this should be considered a bug or a limitation of wasm. I suggest updating the [documentation](https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/wasm-limitations) accordingly, like:

    Calling a sync function while an async function is running might cause a deadlock. 
    To prevent this, avoid synchronous functions on `&mut` with `#[frb(sync)]`. 
    Use the frb async default instead, even when the body is non-async, for example:
    ```
     pub async fn pseudoSyncMut(&mut self) -> String {
		 // write data 
         self.count = 1;
         format!("count={}", self.count)
     }
    ```	
    On the dart side, the caller might have to `await` the result.
