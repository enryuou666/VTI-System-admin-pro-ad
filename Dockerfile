# ---- Stage 1: cai thu vien ----
FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

# ---- Stage 2: image chay that, nho gon ----
FROM python:3.12-slim
RUN useradd -r -u 1001 app
WORKDIR /app
COPY --from=build /install /usr/local
COPY app/ .
USER app
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 CMD python -c "import urllib.request;urllib.request.urlopen('http://localhost:8080/health')"
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]