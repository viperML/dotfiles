.PHONY: readme

readme:
	sed -i "/<!--BEGIN-->/,/<!--END-->/d" ./README.md
	echo -e "<!--BEGIN-->" >> ./README.md
	echo -e "\`\`\`json" >> ./README.md
	nix flake show --json | jq -r ".packages" >> ./README.md
	echo -e "\`\`\`" >> ./README.md
	echo -e "<!--END-->" >> ./README.md
