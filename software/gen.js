var url = $('.page-title-box .page-title-right .dropdown-menu a:nth-child(2)')[0].href
var cfg_content = await fetch(url).then(r => r.text())
var conf = cfg_content.match(/\[Proxy\]\s+DIRECT = direct\s+([\s\S]+)\s+\[Proxy Group\]\s+Proxy =/i)[1]
var lines = conf.split('\n').map(line => line.split(','))
var psds = Object.values(lines
    .map(l => ({name: l[0].split(' = ')[0].split('-').pop().match(/\D+/)[0], addr: l[1].trim() + ':' + l[2], encrypt_method: l[3], password: l[4]}))
    .reduce((sum, it) => {sum[it.addr] = it; return sum;}, {}))
var store = {}
psds = psds.map(psd => ({ ...psd, name: psd.name + (store[psd.name] = (store[psd.name] || 0) + 1) }))
var s = (n) => Array(n).fill(' ').join('')
var script_content = psds.map(psd => `${s(4)}${psd.name})\n${s(8)}server="${psd.addr}"\n${s(8)}encrypt_method="${psd.encrypt_method}"\n${s(8)}password="${psd.password}"\n${s(8)};;`).join('\n')
var script =
`#!/bin/bash
location=$(echo "$1" | tr '[:lower:]' '[:upper:]')

local_addr="0.0.0.0:22112"

case $location in
${script_content}
    *)
        echo "invalid argument $location, the argument must be one of ${psds.map(psd => psd.name).join(', ')}"
        exit 1
        ;;
esac

sslocal -b $local_addr --protocol http -s $server -m $encrypt_method -k $password
`;

var input = document.createElement("textarea");
input.value = script;
document.body.appendChild(input);
input.select();
document.execCommand("Copy");
console.log(script);
document.body.removeChild(input);
