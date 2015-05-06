build:
	docker build -t ianblenke/wsman .

run:
	docker run -ti --rm ianblenke/wsman --help
