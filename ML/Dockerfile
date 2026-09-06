# Use official stable Python 3.12 Bookworm slim image
FROM python:3.12-slim-bookworm

# Copy high-performance uv binary directly from official Astral image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH=/app \
    PORT=8000 \
    HF_HOME=/root/.cache/huggingface \
    TORCH_HOME=/root/.cache/torch \
    UV_SYSTEM_PYTHON=1

# Set working directory
WORKDIR /app

# Install minimal required system dependencies (OpenCV libs + curl for healthcheck)
RUN apt-get update && apt-get install -y --no-install-recommends \
    -o Acquire::Retries=5 \
    -o Acquire::http::No-Cache=true \
    libgl1 \
    libglib2.0-0 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create cache and runtime directories
RUN mkdir -p /app/public /app/artifacts /app/temp /root/.cache/huggingface /root/.cache/torch

# Copy dependency specifications first to leverage Docker layer caching
COPY pyproject.toml requirements.txt ./

# Install Python dependencies via uv with unsafe-best-match to resolve PyTorch CPU extra-index
RUN uv pip install --system --index-strategy unsafe-best-match -r requirements.txt

# Copy backend source code and model artifacts
COPY . .

# Expose server port
EXPOSE 8000

# Container healthcheck (allow 30s start period for initial model weight verification)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Command to launch the backend FastAPI app via Uvicorn
CMD ["python", "main.py"]

