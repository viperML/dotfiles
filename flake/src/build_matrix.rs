use std::{collections::HashMap, path::PathBuf};

use async_trait::async_trait;
use clap::Args;
use eyre::{ContextCompat, Result};
use futures::{stream::FuturesUnordered, StreamExt, TryFutureExt};
use regex::Regex;
use tracing::info;

use crate::CliCommand;

#[derive(Debug, Args)]
pub(crate) struct BuildMatrixArgs {
    #[arg(long, env = "PWD")]
    flake: PathBuf,
    #[arg(long, default_value = "x86_64-linux")]
    system: String,
}

type OutputMap = HashMap<String, String>;

const CACHES: &[&str] = &[
    // -
    "https://viperml.cachix.org",
    "https://cache.nixos.org",
];

#[async_trait]
impl CliCommand for BuildMatrixArgs {
    async fn run(&self) -> Result<()> {
        info!(?self);

        let output = std::process::Command::new("nix")
            .arg("eval")
            .arg(format!(
                "{}#checks.{}",
                self.flake.to_string_lossy(),
                self.system
            ))
            .arg("--apply")
            .arg("builtins.mapAttrs (_: value: value.outPath)")
            .arg("--json")
            .output()?;

        let parsed: OutputMap = serde_json::from_slice(&output.stdout)?;
        info!(?parsed);

        let futs = parsed.into_iter().map(|(name, path)| async move {
            let hash = async { extract_hash(&path).wrap_err("Couldn't get a hash") };

            hash.and_then(|hash| async {
                let queries = CACHES.iter().map(|host| query_hash(hash, host));

                futures::future::try_join_all(queries.into_iter())
                    .await
                    .map(|v| v.into_iter().any(|ok| ok))
            })
            .await
            .map(|res| (name, res))
        });

        let mut stream = futs.collect::<FuturesUnordered<_>>();
        let mut outputs = Vec::new();

        while let Some(result) = stream.next().await {
            let (name, ok) = result?;
            info!(?name, ?ok);
            if !ok {
                outputs.push(name);
            }
        }

        let json = serde_json::to_string(&outputs)?;
        info!(%json);

        println!("flake_outputs={}", json);

        Ok(())
    }
}

async fn query_hash(hash: &str, host: &str) -> Result<bool> {
    let url = format!("{}/{}.narinfo", host, hash);
    let response = reqwest::get(url).await?;

    match response.status().as_u16() {
        404 => Ok(false),
        200 => Ok(true),
        _ => Err(eyre::eyre!("Bad response").wrap_err(response.status())),
    }
}

fn extract_hash(path: &str) -> Option<&str> {
    let re = Regex::new(r"/nix/store/([a-zA-Z0-9]+)-").unwrap();
    let (_, [hash]) = re.captures_iter(path).next()?.extract();
    Some(hash)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_extract_hash() {
        assert_eq!(
            Some("d8brwi1ki4y017hw9x5zvzwi48dlmlbi"),
            extract_hash(
                "/nix/store/d8brwi1ki4y017hw9x5zvzwi48dlmlbi-nix-index-0.1.6+db=2023-07-09"
            )
        );
        assert_eq!(
            Some("q6r9kwmidiy6wx1w1nf3ff0q40sfq4dg"),
            extract_hash("/nix/store/q6r9kwmidiy6wx1w1nf3ff0q40sfq4dg-nix-2.15.1")
        );
    }
}
