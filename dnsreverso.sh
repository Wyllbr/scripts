#/bin/bash

for i in {0..255}; do
  ip="200.129.163.$i"
  echo "🔍 Verificando PTR de $ip"
  dig -x $ip +short
done
