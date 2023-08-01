use std::{collections::HashMap, path::PathBuf};

use async_trait::async_trait;
use clap::Args;
use eyre::Result;
use handlebars::Handlebars;
use serde::Deserialize;
use tracing::{debug, info};

use crate::CliCommand;

#[derive(Debug, Args)]
pub(crate) struct GenFlakeArgs {
    #[arg(long, short)]
    template: PathBuf,
    #[arg(long, short)]
    nv_generated: PathBuf,
}

#[non_exhaustive]
#[derive(Debug, Deserialize)]
struct NvOutput {
    version: String,
}

#[async_trait]
impl CliCommand for GenFlakeArgs {
    async fn run(&self) -> Result<()> {
        info!(?self);

        let raw = std::fs::read_to_string(&self.template)?
            .lines()
            .filter(|line| !line.split_whitespace().any(|elem| elem.starts_with('#')))
            .fold(None, |acc: Option<String>, next| {
                let mut acc = match acc {
                    None => String::new(),
                    Some(mut s) => {
                        s.push('\n');
                        s
                    }
                };
                acc.push_str(next);
                Some(acc)
            })
            .unwrap();

        info!(%raw);

        let nv = {
            let file = std::fs::File::open(&self.nv_generated)?;
            let nv_raw: HashMap<String, NvOutput> = serde_json::from_reader(file)?;
            nv_raw
                .into_iter()
                .map(|(name, value)| (name, value.version))
                .collect::<HashMap<_, _>>()
        };

        debug!(?nv);

        let mut handlebars = Handlebars::new();
        handlebars.set_strict_mode(true);
        let render = handlebars.render_template(&raw, &nv)?;

        print!("{render}");

        Ok(())
    }
}
