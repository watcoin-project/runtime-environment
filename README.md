# Środowisko wykonawcze projektu WATcoin

## Wymagania

Do poprawnego działania środowiska wymagane jest zainstalowanie:
* Docker
* Docker Compose

## Klonowanie

### Środowisko lokalne

Aby prawidłowo sklonować repozytorium należy użyć komendy

    git clone --recursive https://github.com/watcoin-project/runtime-environment.git

W przypadku pobrania repozytorium bez flagi `--recursive` zależności możemy pobrać wykonując poniższe komendy

    git submodule init 
    git submodule update

### Środowisko zdalne

W przypadku chęci uruchomienia węzła na serwerze, który posiada ograniczone zasoby, należy sklonować **wyłącznie** zawartość repozytorium `runtime-environment`

    https://github.com/watcoin-project/runtime-environment.git

## Budowanie

Proces budowania i zagadnienia powiązane zostały opisane w pliku `docker/README.md`.

## Uruchomienie

Aby uruchomić kontenery należy skopiować plik `.env.example` i nazwać go jako `.env`. Można to zrobić używając komendy

    cp -v .env.example .env

Opcjonalnie można zmienić wartości zmiennych środowiskowych zdefiniowanych w pliku.

Aby uruchomić węzeł należy wykonać

    docker-compose up bitcoind cpuminer

Aby uruchomić kontener w tle należy dodać flagę `-d`

    docker-compose up -d bitcoind cpuminer

**Uwaga:** Aby uruchomić bitcoind z udostępnionymi portami należy zmienić interpretowany plik na `docker-compose.publish.yml`. Przykład: `docker-compose --file docker-compose.publish.yml up -d bitcoind cpuminer`.
