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
	git add .
	git commit -m "nix: automatic update"
	git stash pop

hooks:
	ln -sf ${PWD}/.github/hooks/* .git/hooks

clean:
	find -name *.qcow2 -exec rm {} \;
	find -name source -exec rm -rf {} \;
	find -name result -exec unlink {} \;
	nix-collect-garbage --delete-older-than 14d
