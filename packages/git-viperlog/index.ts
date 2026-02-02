import { spawn } from "node:child_process";

console.log("Hello world");

interface GitInfo {
  commit: string;
  unique_commit: string;
  author_email: string;
  author_name: string;
  date: string;
  short_message: string;
}

async function runGit(): Promise<GitInfo[]> {
  const format = {
    commit: "%H",
    unique_commit: "%h",
    author_email: "%ae",
    author_name: "%an",
    date: "%cI",
    short_message: "%s"
  } satisfies GitInfo;

  const args = [
    "log",
    `--pretty=format:${JSON.stringify(format)},`,
    "-n",
    "10",
    "--abbrev-commit",
    "--abbrev=auto",
  ];
  console.log(args);

  let stdout = "";

  const child = spawn("git", args, {
    stdio: "pipe",
  });

  child.stdout.on("data", (data) => {
    stdout += data.toString();
  });

  return new Promise((resolve) => {
    child.on("close", () => {
      stdout = `[${stdout.replace(/,$/, "")}]`;
      const parsed = JSON.parse(stdout);
      resolve(parsed as GitInfo[]);
    });
  });
}

const parsed = await runGit();

for (const info of parsed) {
  process.stdout.write(`◆  ${info.commit} ${info.author_name}\n`)
  process.stdout.write(`│  ${info.short_message}\n`)

}
