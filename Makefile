run:
	rye run uvicorn main:app --reload  --port=7070

connect:
	ngrok http 7070 --region jp

docker-run:
	docker run -it --rm -p 7070:7070 \
	--name kmu-line-bot \
	-v $(PWD)/data:/bot/data \
	kmu-line-bot \
	/bin/bash -c "source ~/.bashrc && rye run uvicorn main:app --reload --host=0.0.0.0 --port=7070"

docker-run-d:
	docker run -d --rm -p 7070:7070 \
	--name kmu-line-bot \
	-v $(PWD)/data:/bot/data \
	kmu-line-bot \
	/bin/bash -c "source ~/.bashrc && rye run uvicorn main:app --reload --host=0.0.0.0 --port=7070"


build:
	docker build . -t kmu-line-bot