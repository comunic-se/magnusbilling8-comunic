.. _asterisk-directmedia:

Directmedia
===========

No Asterisk, a sinalização SIP para estabelecer uma chamada sempre passa pelo
servidor Asterisk. Depois que a chamada é estabelecida, o áudio RTP pode continuar
passando pelo Asterisk ou ir direto entre as pontas da chamada.

As duas opções têm vantagens e desvantagens.

* Quando o RTP vai direto entre as pontas, o Asterisk não precisa processar esse
  tráfego de áudio. Isso pode reduzir a carga do servidor quando há muitas chamadas
  simultâneas.

* Quando o RTP vai direto entre as pontas, o Asterisk não consegue detectar códigos
  de função digitados durante a chamada. Funções que dependem de DTMF ou de códigos
  discados, como transferências, desvios, não perturbe e controle de gravação,
  podem não funcionar como esperado.

Por isso, se transferências ou outras funções que dependem de códigos digitados
durante a chamada precisarem funcionar, o tráfego de voz precisa passar pelo
Asterisk.

Esse comportamento é controlado pela opção ``directmedia`` da configuração SIP. Com
``directmedia=yes``, o RTP pode ir direto entre as pontas. Com ``directmedia=no``, o
RTP continua passando pelo Asterisk.

No MagnusBilling, esta opção é importante ao analisar chamadas online, re-invites,
IPs de áudio, gravação de chamadas, transferências e outras funções que dependem de
o Asterisk ficar no caminho da mídia.
