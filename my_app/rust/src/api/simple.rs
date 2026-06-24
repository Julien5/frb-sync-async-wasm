#![allow(non_snake_case)]
#[cfg(not(target_arch = "wasm32"))]
use tokio::time::sleep;
#[cfg(target_arch = "wasm32")]
use wasmtimer::tokio::sleep;

use flutter_rust_bridge::frb;

#[frb(opaque)]
pub struct Bridge {
    count: i32,
}

impl Bridge {
    #[frb(sync)]
    pub fn make() -> Bridge {
        Bridge { count: 0 }
    }

    pub async fn realAsyncConst(&self) {
        log::trace!("[1]");
        sleep(std::time::Duration::from_millis(1000)).await;
        log::trace!("[2]");
    }

    pub async fn pseudoSyncMut(&mut self) -> String {
        self.count = 1;
        format!("count={}", self.count)
    }

    #[frb(sync)]
    pub fn realSyncMut(&mut self) -> String {
        self.count = 1;
        format!("count={}", self.count)
    }

    #[frb(sync)]
    pub fn realSyncConst(&self) -> String {
        format!("{}", "hi from rust")
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
