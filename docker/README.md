# Obrazy Docker dla WATcoin

## Budowanie

### Qt

Klient z graficznym interfejsem. Aby zbudować należy uruchomić skrypt `bin/docker-build-qt.sh`.

### bitcoind

Daemon pełniący funkcję węzła. Aby zbudować należy uruchomić skrypt `bin/docker-build-bitcoind.sh`.

### cpuminer

Program _"kopiący"_ kryptowalutę. Aby zbudować należy uruchomić skrypt `bin/docker-build-cpuminer.sh`.

### Uwagi

Po zbudowaniu nowej wersji zalecam wykonanie `docker image prune -f` aby usunąć zbędne warstwy, które mogą zajmować sporo miejsca.

W celu zbudowania wszystkich obrazów możemy wykonać komendę `docker-compose build`.

W przypadku budowania obrazów samodzielnie (za pomocą komendy `docker-compose build ...`) należy pamiętać, aby wpierw zbudować obraz `watcoin:argon2`, który jest wymagany przez pozostałe obrazy.

## Uruchamianie

Uruchamiać kontenery można za pomocą skryptów `bin/docker-run-*.sh`.

Aby uruchomić bitcoind oraz cpuminer w tle należy użyć komendy `docker-compose up -d bitcoind cpuminer`.

Jeśli chcemy aby porty z kontenera dostępne były z zewnątrz należy dodać flagę `-p 8686:8686` gdzie `8686` to wartość zmiennej `BITCOIN_PORT`.

**Uwaga:** Uruchomienie cpuminer automatycznie uruchamia bitcoind!

## Zmienne środowiskowe

* `BITCOIN_PORT` - port na którym nasłuchuje bitcoind;
* `BITCOIN_RPC_PORT` - port na którym nasłuchuje bitcoind lub qt;
* `BITCOIN_RPC_USER` (opcjonalne) - nazwa użytkownika RPC;
* `BITCOIN_RPC_PASSWORD` (opcjonalne) - hasło użytkownika RPC;
* `BITCOIN_RPC_DEPRECATED` - opcja ustawienia opcji `generate` aby możliwe było generowanie nowych bloków za pomocą komendy `bitcoin-cli generate N`;
* `BITCOIN_DATA_DIR` - lokalizacja plików blockchaina;
* `BITCOIN_SERVER` - klient Qt może nasłuchiwać komunikatów RPC gdy opcja ustawiona jest na `1`;
* `BITCOIN_NETWORK` - wybór sieci pomiędzy `mainnet`, `testnet` a `regtest` (domyślnie `mainnet`);
* `BITCOIN_CONNECT` - lista hostów z którymi daemon ma próbować się połączyć w notacji `ADRES:PORT`, kolejne hosty oddzielone spacjami;
* `BITCOIN_ADD_NODE` - lista hostów z którymi daemon ma próbować się połączyć i wymieniać informacje na temat innych hostów w notacji `ADRES:PORT`, kolejne hosty oddzielone spacjami;
* `BITCOIN_ENABLE_DNS` - możliwość wykorzystania domen w zmiennych `BITCOIN_CONNECT` i `BITCOIN_ADD_NODE` gdy opcja ustawiona jest na `1`;
* `BITCOIN_URL` - adres URL dla minera w notacji `ADRES:PORT`.

Zmienne środowiskowe przechowywane są w pliku `.env`. Ważne aby wcześniej skopiować dostępny plik `.env.example` i zapisać jako `.env` ustawiając jednocześnie domyślne zmienne środowiske. Można to zrobić komendą `cp -v .env.example .env`. Plik jest wpisany w `.gitignore` więc jego modyfikacja nie zostanie odnotowana w _commitach_.

## Kopiowanie

Aby skopiować obraz na serwer zewnętrzny można użyć skryptu `bin/copy-docker-image-to-remote.sh`, przykładowo:

    bin/copy-docker-image-to-remote.sh my-remote-host watcoin:bitcoind

**Uwaga:** Zalecane skonfigurowanie pliku `~/.ssh/config`, ponieważ skrypt wielokrotnie nawiązuje połączenie SSH.

## Odnośniki

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Compose command-line reference](https://docs.docker.com/compose/reference/)
* [Compose file reference](https://docs.docker.com/compose/compose-file/)
* [SSH config file](https://www.ssh.com/ssh/config/)
