use antigravity_core::models::config::AppConfig;
use antigravity_core::modules::logger;
use antigravity_core::modules::proxy::server::AxumServer;
use antigravity_core::modules::proxy::TokenManager;
use std::sync::Arc;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. Initialize Logger
    logger::init_logger();
    tracing::info!("Starting Antigravity Server...");

    // 2. Load Configuration
    // For now, we load from default path or env?
    // Let's assume standard config path for now.
    // Core config module should handle loading.
    // But AppConfig::load might depend on Tauri context in old code?
    // Let's check config.rs.

    // Assuming AppConfig can be loaded without Tauri:
    let config = antigravity_core::modules::config::load_app_config().unwrap_or_else(|e| {
        tracing::warn!("Failed to load config, using default: {}", e);
        AppConfig::default()
    });

    let proxy_config = config.proxy.clone();

    // 3. Initialize Token Manager
    let data_dir = antigravity_core::modules::account::get_data_dir().unwrap();
    let token_manager = Arc::new(TokenManager::new(data_dir.clone()));

    // 4. Initialize Monitor
    let monitor = Arc::new(antigravity_core::modules::proxy::monitor::ProxyMonitor::new(1000));
    monitor.set_enabled(true);

    // 5. Start Server
    let host = "0.0.0.0".to_string(); // Listen on all interfaces
    let port = 3000; // Default port

    tracing::info!("Listening on {}:{}", host, port);

    let (server, handle) = AxumServer::start(
        host,
        port,
        token_manager,
        config.proxy.custom_mapping.clone(),
        300,
        config.proxy.upstream_proxy.clone(),
        antigravity_core::modules::proxy::ProxySecurityConfig::from_proxy_config(&config.proxy),
        config.proxy.zai.clone(),
        monitor,
        config.proxy.experimental.clone(),
    )
    .await?;

    // Wait for shutdown signal (Ctrl+C)
    tokio::signal::ctrl_c().await?;
    tracing::info!("Shutting down...");
    server.stop();
    handle.await?;

    Ok(())
}
