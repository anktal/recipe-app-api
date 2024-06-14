# FROM python:3.11.8
# LABEL maintainer="recipeapp.com"

# ENV PYTHONUNBUFFERED 1
# COPY ./requirements.txt /tmp/requirements.txt
# COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# COPY ./app /app
# WORKDIR /app
# EXPOSE 8000

# ARG DEV=false
# RUN python -m venv /py && \
#     /py/bin/pip install --upgrade pip && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     if [ $DEV = "true"  ]; \
#         then /py/bin/pip install -r /tmp/requirements.dev.txt; \
#     fi && \
#     rm -rf /tmp && \
#     adduser \
#         --disabled password \
#         --no-create-home \
#         django-user

# ENV path='/py/bin:$PATH'
# USER django-user
FROM python:3.11.8
LABEL maintainer="recipeapp.com"

ENV PYTHONUNBUFFERED 1
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /py
RUN /py/bin/pip install --upgrade pip
RUN /py/bin/pip install -r /tmp/requirements.txt

# Install development requirements if DEV is true
RUN if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi

# Clean up
RUN rm -rf /tmp

# Add user
RUN adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"
USER django-user
