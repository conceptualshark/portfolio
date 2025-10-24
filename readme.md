# Resume and Portfolio
[![build-and-publish](https://github.com/conceptualshark/conceptualshark.github.io/actions/workflows/publish.yml/badge.svg)](https://github.com/conceptualshark/conceptualshark.github.io/actions/workflows/publish.yml) [![pages-build-deployment](https://github.com/conceptualshark/conceptualshark.github.io/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/conceptualshark/conceptualshark.github.io/actions/workflows/pages/pages-build-deployment) ![Built with Markdown](https://img.shields.io/badge/Markdown-blue) [![Built with Material for MkDocs](https://img.shields.io/badge/Material_for_MkDocs-526CFE?style=for-the-badge&logo=MaterialForMkDocs&logoColor=white)](https://squidfunk.github.io/mkdocs-material/)

## :zap: About
I am a technical writer and editor with a background in software engineering and project management. This repository serves as a home for my portfolio and resume, and can be viewed live at [https://cisaac-portfolio.vercel.app/](https://cisaac-portfolio.vercel.app/). 

This project is built using [Material for Mkdocs](https://squidfunk.github.io/mkdocs-material/), a static site generator. Pages are written in Markdown, customized using the Mkdocs configuration file and CSS overrides, and published using [Vercel](https://vercel.com//).

## :rocket: Deployment

### Requirements
- [Docker](https://www.docker.com/) (20.10.11+)

### Clone and deploy
This project is dockerized for local testing. To deploy this project on your own, first clone the repository:
```
git clone https://github.com/conceptualshark/portfolio.git
```
Ensure Docker is running. From the root directory of the cloned project, run the following command:

```
docker compose up
```

The included Docker Compose file will install all the project requirements, and serve the site at [localhost:8000](localhost:8000). 

## :books: Learn More
Find out more about my work on [LinkedIn](https://www.linkedin.com/in/cole-isaac/).

To build a similar site of your own, check out the [Mkdocs guides](https://squidfunk.github.io/mkdocs-material/getting-started/), or learn how to get started with [Vercel](https://vercel.com/docs/getting-started-with-vercel).
