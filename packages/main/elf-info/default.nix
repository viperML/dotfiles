{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
,
}:

rustPlatform.buildRustPackage rec {
  pname = "elf-info";
  version = "unstable-2024-02-25";

  src = fetchFromGitHub {
    owner = "viperML";
    repo = "elf-info";
    rev = "2ed911f450cc0e9ca1ac4d2e9bdc8b3dfda39313";
    hash = "sha256-e1OtegMb+wnmS34/9v/4JTa2joM19r8EUaorUKXwUQw=";
  };

  cargoHash = "sha256-cEWfJ49KCH2sLHVRtWi8nW/i7b/TBD3TWm4eVPja9XU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    mkdir completions
    $out/bin/elf --completion bash > completions/elf.bash
    $out/bin/elf --completion zsh  > completions/elf.zsh
    $out/bin/elf --completion fish > completions/elf.fish

    installShellCompletion completions/*
  '';

  meta = with lib; {
    description = "Inspect and dissect an ELF file with pretty formatting";
    homepage = "https://github.com/viperML/elf-info";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "elf-info";
  };
}
