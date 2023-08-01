mod build_matrix;
mod generate;

use std::ops::Deref;

use async_trait::async_trait;
use clap::Parser;
use eyre::Result;
use once_cell::sync::Lazy;
use tracing_subscriber::prelude::*;

#[derive(Debug, Parser)]
enum Args {
    BuildMatrix(build_matrix::BuildMatrixArgs),
    GenFlake(generate::GenFlakeArgs),
}

#[async_trait]
trait CliCommand {
    async fn run(&self) -> Result<()>;
}

#[async_trait]
impl CliCommand for Args {
    async fn run(&self) -> Result<()> {
        match self {
            Args::BuildMatrix(args) => args.run().await,
            Args::GenFlake(args) => args.run().await,
        }
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let layer_filter = tracing_subscriber::EnvFilter::from_default_env();

    let layer_fmt = tracing_subscriber::fmt::layer()
        .with_writer(std::io::stderr)
        // .without_time()
        .with_line_number(true)
        .compact();

    tracing_subscriber::registry()
        .with(layer_filter)
        .with(layer_fmt)
        .init();

    Args::parse().run().await
}
