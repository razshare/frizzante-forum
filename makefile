###### Composites ######
test: update check package
	CGO_ENABLED=1 go test ./...

build: update check package
	CGO_ENABLED=1 go build -o bin/app .

dev: configure-air update check retouch
	DEV=1 CGO_ENABLED=1 ./bin/air \
	--build.cmd "go build -o bin/app ." \
	--build.bin "bin/app" \
	--build.exclude_dir "app/dist,app/node_modules,bin,archive,sessions,tmp,.git,.github" \
	--build.exclude_regex "_test.go" \
	--build.include_ext "go" \
	--build.log "go-build-errors.log" & \
	make package-watch & \
	wait

check: update
	cd app && \
	../bin/bun x eslint . && \
	../bin/bun x svelte-check --tsconfig ./tsconfig.json

package-watch: update
	cd app && \
	../bin/bun x vite build --logLevel info --ssr lib/utilities/frz/scripts/server.ts --outDir dist --watch & \
	cd app && \
	../bin/bun x vite build --logLevel info --outDir dist/client --watch & \
	wait

package: update
	cd app && \
	../bin/bun x vite build --logLevel info --ssr lib/utilities/frz/scripts/server.ts --outDir dist --emptyOutDir && \
	../bin/bun x vite build --logLevel info --outDir dist/client --emptyOutDir && \
	node_modules/.bin/esbuild dist/server.js --bundle --outfile=dist/server.js --format=cjs --allow-overwrite

update: configure-bun
	go mod tidy
	cd app && \
	../bin/bun update

format: configure-bun
	cd app && \
	../bin/bun x prettier --write .

generate: configure-frizzante
	# Generate frizzante utilities...
	rm app/lib/utilities/frz -fr
	./bin/frizzante -generate -utilities -out="app/lib/utilities/frz"

clean: retouch
	go clean
	rm bin -fr
	mkdir bin -p
	rm app/node_modules -fr

###### Primitives ######

retouch:
	rm app/dist -fr
	mkdir app/dist -p
	touch app/dist/.gitkeep
	touch app/dist/server.js

hooks:
	printf "#!/usr/bin/env bash\n" > .git/hooks/pre-commit
	printf "make test" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

configure-bun:
	# Check requirements...
	command -v unzip >/dev/null || error 'unzip is required to install and configure dependencies'
	command -v curl >/dev/null || error 'curl is required to install and configure dependencies'
	# Make bin...
	mkdir bin -p
	# Get bun...
	which bin/bun || (curl -fsSL https://github.com/oven-sh/bun/releases/download/bun-v1.2.16/bun-linux-x64.zip -o bin/bun.zip && \
	unzip -j bin/bun.zip -d bin && rm bin/bun.zip -f)
	chmod +x bin/bun

configure-frizzante:
	# Check requirements...
	command -v unzip >/dev/null || error 'unzip is required to install and configure dependencies'
	command -v curl >/dev/null || error 'curl is required to install and configure dependencies'
	# Make bin...
	mkdir bin -p
	# Get frizzante...
	which bin/frizzante || (curl -fsSL https://github.com/razshare/frizzante/releases/download/v1.2.5/frizzante-amd64.zip -o bin/frizzante.zip && \
	unzip -j bin/frizzante.zip -d bin && rm bin/frizzante.zip -f)
	chmod +x bin/frizzante

configure-air:
	# Check requirements...
	command -v unzip >/dev/null || error 'unzip is required to install and configure dependencies'
	command -v curl >/dev/null || error 'curl is required to install and configure dependencies'
	# Make bin...
	mkdir bin -p
	# Get air...
	which bin/air || (curl -fsSL https://github.com/air-verse/air/releases/download/v1.62.0/air_1.62.0_linux_amd64 -o bin/air)
	chmod +x bin/air

configure-sqlc:
	# Check requirements...
	command -v unzip >/dev/null || error 'unzip is required to install and configure dependencies'
	command -v curl >/dev/null || error 'curl is required to install and configure dependencies'
	# Get sqlc...
	which bin/sqlc || (curl -fsSL https://github.com/sqlc-dev/sqlc/releases/download/v1.29.0/sqlc_1.29.0_linux_amd64.zip -o bin/sqlc.zip && \
	unzip -j bin/sqlc.zip -d bin && rm bin/sqlc.zip -f)
	chmod +x bin/sqlc

configure: configure-bun configure-air configure-frizzante configure-sqlc

