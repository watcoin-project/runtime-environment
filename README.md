# Środowisko wykonawcze projektu WATcoin

## Wymagania

Do poprawnego działania środowiska wymagane jest zainstalowanie:
* Docker
* Docker Compose

## Klonowanie

Aby prawidłowo sklonować repozytorium należy użyć komendy `git clone --recursive https://github.com/watcoin-project/runtime-environment.git`.

Jeśli jednak pobierzemy repozytorium przy pomocy komendy `git clone https://github.com/watcoin-project/runtime-environment.git` należy wykonać następujące komendy aby pobrać wszystkie zależności:

    git submodule init 
    git submodule update

## Budowanie

Proces budowania i zagadnienia powiązane zostały opisane w pliku `docker/README.md`.

## Uruchomienie

Aby uruchomić kontenery należy skopiować plik `.env.example` i nazwać go jako `.env` (można to zrobić używając komendy `cp -v .env.example .env`).

Opcjonalnie można zmienić wartości zmiennych środowiskowych zdefiniowanych w pliku.

Aby uruchomić węzeł należy wykonać `docker-compose up bitcoind cpuminer`. Dodanie flagi `-d` uruchamia kontenery w tle.

**Uwaga:** Aby uruchomić bitcoind z udostępnionymi portami należy zmienić interpretowany plik na `docker-compose.publish.yml`. Przykład: `docker-compose --file docker-compose.publish.yml up -d bitcoind cpuminer`.
