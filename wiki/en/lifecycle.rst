Ciclo de vida das versões do MagnusBilling
==========================================

Versão atual
------------

O MagnusBilling 8 é a versão em desenvolvimento ativo. Funcionalidades novas são
desenvolvidas só para a versão 8.

O MagnusBilling 8 usa Asterisk 20 e PJSIP. O caminho de instalação suportado é um
servidor novo com instalação mínima do Debian. O suporte ao Ubuntu está planejado,
mas não deve ser considerado suportado até ser anunciado explicitamente e coberto
pelos testes do instalador e das versões.

MagnusBilling 7
---------------

O MagnusBilling 7 entrou em modo de manutenção em 18 de julho de 2026.

* Nenhuma funcionalidade nova é acrescentada ao MagnusBilling 7.
* Correções críticas de erros, de segurança e de compatibilidade são feitas até
  31 de dezembro de 2026.
* A manutenção regular termina em 1º de janeiro de 2027.
* As instalações existentes podem continuar funcionando depois dessa data, mas não
  terão mais manutenção regular.

O MagnusBilling 7 usa Asterisk 13 e ``chan_sip``. Migrar para o MagnusBilling 8
exige um servidor Debian novo, Asterisk 20, PJSIP e a migração do banco. Atualizar
o sistema operacional ou a aplicação no mesmo servidor não é suportado.

CentOS 7
--------

O CentOS Linux 7 chegou ao fim da vida em 30 de junho de 2024. As instalações do
MagnusBilling 7 que ainda rodam no CentOS 7 são consideradas sem suporte e devem
ser migradas para um servidor Debian novo.

Não tente atualizar o CentOS 7 no mesmo servidor como parte da migração do
MagnusBilling. Preserve o servidor antigo para poder voltar, instale o MagnusBilling 8
num servidor Debian novo, restaure um dump completo do banco e rode o migrador de
banco do MagnusBilling 8.

Resumo de compatibilidade
-------------------------

* **MagnusBilling 7 / Debian 11 ou 12 / Asterisk 13 / chan_sip:** manutenção até
  31 de dezembro de 2026.
* **MagnusBilling 7 legado / CentOS 7 / Asterisk 13 / chan_sip:** sem suporte;
  migre para um servidor Debian novo.
* **MagnusBilling 8 / Debian ou Ubuntu / Asterisk 20 / PJSIP:** desenvolvimento ativo.

Veja :doc:`Migração a partir do MagnusBilling 7 <get_started/migrate_from_mb7>` para o
procedimento de migração suportado.
