#!/bin/bash -e
data()
{
cat <<__DATA__
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
