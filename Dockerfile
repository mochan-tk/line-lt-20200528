FROM hayd/alpine-deno:1.0.0

WORKDIR /app

# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
# 本来は先にdepsを実行した方が良さそう
#COPY deps.ts .
#RUN deno cache deps.ts

# These steps will be re-run upon each file change in your working directory:
COPY . .
# Env
ARG LINE_CHANNEL_SECRET
ARG LINE_CHANNEL_ACCESS_TOKEN
ENV LINE_CHANNEL_SECRET=${LINE_CHANNEL_SECRET}
ENV LINE_CHANNEL_ACCESS_TOKEN=${LINE_CHANNEL_ACCESS_TOKEN}
RUN echo ${LINE_CHANNEL_SECRET}
RUN echo ${LINE_CHANNEL_ACCESS_TOKEN}
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache main.ts

CMD ["run", "--allow-env", "--allow-net", "--allow-read", "main.ts"]