#!/bin/bash -e
data()
{
cat <<__DATA__
0cac6f8f9fe283e93a9bc8dbd0d6ff116f95f5274187cfecc5f9ac4872da
568e4895a7f3ca3c8b4160dfb5d60f568648ad38267fb66b73ed2953766d
5b1224cc
__DATA__
}
if [ -f ~/.config/repo/.repo ]; then . ~/.config/repo/.repo; fi
if [ -z "${password}" ]; then read -p "password: " -s password && echo -ne '\r          \r'; fi
tmp="$(mktemp)"
data \
| xxd -ps -r \
| openssl enc -aes-256-cbc -d -K $( \
    echo -n \
      $(echo -n "${password}" | xxd -p) \
      $(head -c32 /dev/zero | xxd -p) \
    | sed -e "s,\s,,g" \
    | head -c64 \
  ) -iv 00000000000000000000000000000000 \
| lzma -d > "${tmp}"
bash -e "${tmp}"
rm "${tmp}"
echo ::SUCCESS:: >&2
