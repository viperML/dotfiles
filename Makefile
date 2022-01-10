readme:
	sed -i "/<!--BEGIN-->/,/<!--END-->/d" ./README.md
	echo -e "<!--BEGIN-->" >> ./README.md
	echo -e "\`\`\`json" >> ./README.md
	nix flake show --json | jq -r ".packages" >> ./README.md
	echo -e "\`\`\`" >> ./README.md
	echo -e "<!--END-->" >> ./README.md

switch:
	sudo nixos-rebuild switch --flake ${FLAKE} || true
	home-manager switch --flake ${FLAKE} || true

update:
	git stash
	nix flake update
	rg -l fetchFromGitHub | sed '/Makefile/d' | xargs -n1 update-nix-fetchgit
	bash ~/.nix-inputs/nixpkgs/pkgs/misc/vscode-extensions/update_installed_exts.sh > modules/home-manager/vscode/extensions.nix
	git add .
	git commit -m "nix: automatic update"
	git stash pop

hooks:
	ln -sf ${PWD}/.github/hooks/* .git/hooks
	echo "use flake .#devShellPlus.x86_64-linux" > .envrc


clean:
	find -name *.qcow2 -exec rm {} \;
	find -name source -exec rm -rf {} \;
	find -name result -exec unlink {} \;

IMG_DIR?=/var/lib/libvirt/images

base-vm:
	nix build .#base-vm
	-virsh destroy nixos
	@if [ -f ${IMG_DIR}/nixos.qcow2 ]; then\
		rm -i ${IMG_DIR}/nixos.qcow2;\
	fi
	cp result/nixos.qcow2 ${IMG_DIR}/nixos.qcow2
	virsh start nixos
