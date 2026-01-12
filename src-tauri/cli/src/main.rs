use antigravity_core::models::TokenData;
use antigravity_core::modules::{account, quota};
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "antigravity")]
#[command(about = "Command line interface for Antigravity Tools", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// List all managed accounts
    List,

    /// Switch to a specific account by ID or Email
    Switch {
        /// Account ID or exact Email address
        id_or_email: String,
    },

    /// Check quota for the current account
    Quota,

    /// Add a new account manually
    Add {
        /// Refresh Token
        refresh_token: String,
        /// Access Token
        access_token: String,
        /// Email address
        email: String,
    },
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize logging (simple console output for CLI)
    // We can use a simpler subscriber here or just println! for CLI output

    let cli = Cli::parse();

    match &cli.command {
        Commands::List => {
            let accounts = account::list_accounts()?;
            println!("{:<36} | {:<30} | {:<20}", "ID", "Email", "Name");
            println!("{}", "-".repeat(90));

            let current = account::get_current_account_id()?;

            for acc in accounts {
                let prefix = if Some(&acc.id) == current.as_ref() {
                    "*"
                } else {
                    " "
                };
                let name = acc.name.unwrap_or_default();
                println!(
                    "{} {:<36} | {:<30} | {:<20}",
                    prefix, acc.id, acc.email, name
                );
            }
        }
        Commands::Switch { id_or_email } => {
            // Find ID if email provided
            let accounts = account::list_accounts()?;
            let target_id = if let Some(acc) = accounts
                .iter()
                .find(|a| &a.id == id_or_email || &a.email == id_or_email)
            {
                &acc.id
            } else {
                eprintln!("Account not found: {}", id_or_email);
                std::process::exit(1);
            };

            println!("Switching to account {}...", target_id);
            match account::switch_account(target_id).await {
                Ok(_) => println!("Successfully switched account."),
                Err(e) => {
                    eprintln!("Failed to switch account: {}", e);
                    std::process::exit(1);
                }
            }
        }
        Commands::Quota => {
            if let Some(mut acc) = account::get_current_account()? {
                println!("Checking quota for {}...", acc.email);
                match account::fetch_quota_with_retry(&mut acc).await {
                    Ok(quota) => {
                        println!("Quota Status:");
                        if let Some(tier) = &quota.subscription_tier {
                            println!("Subscription: {}", tier);
                        }
                        if quota.is_forbidden {
                            println!("Status: Forbidden!");
                        }
                        println!("Models:");
                        for model in &quota.models {
                            println!(
                                "  - {}: {}% (Reset: {})",
                                model.name, model.percentage, model.reset_time
                            );
                        }
                    }
                    Err(e) => eprintln!("Failed to fetch quota: {}", e),
                }
            } else {
                eprintln!("No active account selected.");
            }
        }
        Commands::Add {
            refresh_token,
            access_token,
            email,
        } => {
            let token = TokenData::new(
                access_token.clone(),
                refresh_token.clone(),
                3600, // Default expiry
                Some(email.clone()),
                None,
                None,
            );

            match account::add_account(email.clone(), None, token) {
                Ok(acc) => println!("Account added successfully: {} ({})", acc.email, acc.id),
                Err(e) => eprintln!("Failed to add account: {}", e),
            }
        }
    }

    Ok(())
}
