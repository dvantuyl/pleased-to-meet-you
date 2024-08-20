## Start Ollama server

```
OLLAMA_NUM_PARALLEL=3 ollama serve
```

## Setup Database

```
bundle exec ruby db/setup.rb
```

## Start web server

```
bundle exec falcon serve -n 3
```