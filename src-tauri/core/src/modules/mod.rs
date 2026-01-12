pub mod account;
pub mod config;
pub mod db;
pub mod i18n;
pub mod logger;
pub mod migration;
pub mod oauth;
pub mod process;
pub mod proxy;
pub mod proxy_db;
pub mod quota;

use crate::models;

// 重新导出常用函数到 modules 命名空间顶级，方便外部调用
pub use account::*;
pub use config::*;
#[allow(unused_imports)]
pub use logger::*;
#[allow(unused_imports)]
pub use quota::*;

pub async fn fetch_quota(
    access_token: &str,
    email: &str,
) -> crate::error::AppResult<(models::QuotaData, Option<String>)> {
    quota::fetch_quota(access_token, email).await
}
