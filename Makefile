HERDSMAN_VERSION=v0.40.3
VERSION=1.36.1

deps:
	mkdir -p deps && cd deps && git clone git@github.com:Koenkk/zigbee-herdsman.git
	cd deps/zigbee-herdsman && git co $(HERDSMAN_VERSION)
	cd deps/zigbee-herdsman && git apply ../../herdsman.patch

build:
	cd deps/zigbee-herdsman && npm ci && npm run build
	npm ci
	npm run build
	docker buildx build --build-arg COMMIT=$(git rev-parse --short HEAD) --platform linux/amd64 -f docker/Dockerfile --provenance=false -t docker.f-ko.eu/zigbee2mqtt:$(VERSION) .

push:
	docker push docker.f-ko.eu/zigbee2mqtt:$(VERSION) 

clean:
	rm -rf deps
