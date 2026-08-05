FROM python:3-alpine

WORKDIR /docs

COPY . .
RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]