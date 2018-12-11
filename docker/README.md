# Obrazy Docker dla WATcoin

## Budowanie

### Qt

Klient z graficznym interfejsem. Budowanie za pomocą `docker-compose build qt` lub `bin/docker-build-qt.sh`.

### bitcoind

Daemon działający w tle uruchamiany na serwerze. Budowanie za pomocą `docker-compose build bitcoind` lub `bin/docker-build-bitcoind.sh`.

### cpuminer

Program _"kopiący"_ kryptowalutę. Budowanie za pomocą `docker-compose build cpuminer` lub `bin/docker-build-cpuminer.sh`.

### Uwagi

Po zbudowaniu nowej wersji zalecam wykonanie `docker image prune -f` aby usunąć zbędne warstwy, które mogą zajmować sporo miejsca.

W celu zbudowania wszystkich obrazów możemy wykonać komendę `docker-compose build`.

## Uruchamianie

Uruchamiać kontenery można za pomocą skryptów `bin/docker-run-*.sh`.

Aby uruchomić bitcoind oraz cpuminer w tle należy użyć komendy `docker-compose up -d bitcoind cpuminer`.

**Uwaga:** Uruchomienie cpuminer automatycznie uruchamia bitcoind!

## Zmienne środowiskowe

* `BITCOIN_PORT` - port na którym nasłuchuje bitcoind;
* `BITCOIN_RPC_PORT` - port na którym nasłuchuje bitcoind lub qt;
* `BITCOIN_RPC_USER` (opcjonalne) - nazwa użytkownika RPC;
* `BITCOIN_RPC_PASSWORD` (opcjonalne) - hasło użytkownika RPC;
* `BITCOIN_RPC_DEPRECATED` - opcja ustawienia opcji `generate` aby możliwe było generowanie nowych bloków za pomocą komendy `bitcoin-cli generate N`;
* `BITCOIN_DATA_DIR` - lokalizacja plików blockchaina;
* `BITCOIN_SERVER` - klient Qt może nasłuchiwać komunikatów RPC gdy opcja ustawiona jest na `1`;
* `BITCOIN_NETWORK` - wybór sieci pomiędzy `main`, `test` a `regtest` (domyślnie `main`);
* `BITCOIN_CONNECT` - lista hostów z którymi daemon ma próbować się połączyć w notacji `ADRES:PORT`, kolejne hosty oddzielone spacjami;
* `BITCOIN_ADD_NODE` - lista hostów z którymi daemon ma próbować się połączyć i wymieniać informacje na temat innych hostów w notacji `ADRES:PORT`, kolejne hosty oddzielone spacjami;
* `BITCOIN_ENABLE_DNS` - możliwość wykorzystania domen w zmiennych `BITCOIN_CONNECT` i `BITCOIN_ADD_NODE` gdy opcja ustawiona jest na `1`;
* `BITCOIN_URL` - adres URL dla minera w notacji `ADRES:PORT`.

Zmienne środowiskowe przechowywane są w pliku `.env`. Ważne aby wcześniej skopiować dostępny plik `.env.example` i zapisać jako `.env` ustawiając jednocześnie domyślne zmienne środowiske. Można to zrobić komendą `cp -v .env.example .env`. Plik jest wpisany w `.gitignore` więc jego modyfikacja nie zostanie odnotowana w _commitach_.

## Odnośniki

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Compose command-line reference](https://docs.docker.com/compose/reference/)
* [Compose file reference](https://docs.docker.com/compose/compose-file/)
