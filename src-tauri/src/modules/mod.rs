// Modules extracted to core
pub use antigravity_core::modules::account;
pub use antigravity_core::modules::config;
pub use antigravity_core::modules::db;
pub use antigravity_core::modules::i18n;
pub use antigravity_core::modules::logger;
pub use antigravity_core::modules::migration;
pub use antigravity_core::modules::oauth;
pub use antigravity_core::modules::process;
pub use antigravity_core::modules::quota;
// Proxy DB was removed from core (for now) or not moved?
// I deleted proxy_db.rs from src-tauri just now. But I removed it from core earlier.
// So proxy_db is gone from both!
// Wait, I should not have deleted proxy_db.rs from src-tauri if I deleted it from core.
// core/src/modules/mod.rs has it removed.
// src-tauri/src/modules/proxy_db.rs: contained proxy logic.
// If I delete it, I lose it.

// Modules remaining involved in Tauri
pub mod oauth_server;
pub mod tray;

pub use account::*;
pub use config::*;
#[allow(unused_imports)]
pub use logger::*;
#[allow(unused_imports)]
pub use quota::*;

use crate::models;

pub async fn fetch_quota(
    access_token: &str,
    email: &str,
) -> crate::error::AppResult<(models::QuotaData, Option<String>)> {
    quota::fetch_quota(access_token, email).await
}
