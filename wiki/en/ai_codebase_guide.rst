Guia do código para IA
======================

Este guia ajuda assistentes de IA e mantenedores a navegar rápido pelo MagnusBilling 8
e a responder perguntas técnicas com evidências rastreáveis.

Objetivo
========

Responder perguntas como:

- Onde uma funcionalidade é implementada.
- Qual fluxo de execução roda para cada tipo de chamada.
- Quais tabelas/models/controllers participam de uma operação.
- Quais arquivos devem ser alterados para uma melhoria específica.

Arquitetura geral
=================

O MagnusBilling combina três camadas principais:

1. Backend Yii 1.1 (PHP)
2. Frontend de administração em ExtJS 6.2
3. Motor de chamadas via AGI do Asterisk

Fluxo simplificado:

::

    Navegador (ExtJS)
      -> index.php/<controller>/<action>
      -> Controller Yii
      -> Model (ActiveRecord)
      -> MySQL/MariaDB

    Dialplan do Asterisk
      -> resources/asterisk/mbilling.php
      -> classes *Agi.php
      -> tabelas de usuário/tarifa/tronco/CDR

Pontos de entrada reais
=======================

Backend web
-----------

- index.php: inicialização do Yii e execução da aplicação.
- protected/config/main.php: imports de models/componentes e conexão com o banco.

Frontend
--------

- app.js: cria a aplicação ExtJS (Ext.application).
- classic/src/Application.js: inicialização do MBilling.Application, conferência
  da sessão, carga das telas/stores iniciais e comportamento global de CSRF.

AGI
---

- resources/asterisk/mbilling.php: ponto de entrada do AGI; trata comandos
  especiais e detecta DID, chamadas SIP, fila, callback e o fluxo de saída padrão.

Mapa dos diretórios críticos
============================

::

    protected/
      controllers/   # endpoints HTTP (actionList/actionCreate/actionUpdate...)
      models/        # ActiveRecord das tabelas pkg_*
      components/    # BaseController, autenticação, utilitários, integrações
      config/        # main.php, permissões, cron

    app/
      store/         # camada de dados ExtJS (proxy ajax)
      model/         # definições de dados da interface
      helper/        # funções utilitárias

    classic/src/
      Application.js # inicialização da interface e orquestração de sessão/menu

    resources/asterisk/
      mbilling.php
      Magnus.php
      AuthenticateAgi.php
      CalcAgi.php
      DidAgi.php
      QueueAgi.php
      IvrAgi.php
      SipCallAgi.php
      StandardCallAgi.php
      SearchTariff.php

    script/
      install.sh     # script de instalação do servidor
      database.sql   # esquema base do banco

    comunic/, custom/  # customizações da Comunic (ver comunic/README.md)

Roteador de perguntas (manual da IA)
====================================

Use esta tabela para escolher o primeiro arquivo a inspecionar.

* Login, sessão, permissão, menu:
  comece por ``protected/controllers/AuthenticationController.php``.
  Arquivos de apoio: ``protected/components/BaseController.php`` e
  ``protected/components/Controller.php``.

* CRUD do painel (usuário, sip, tronco, tarifa, did, fila):
  comece por ``protected/controllers/<Entidade>Controller.php``.
  Arquivos de apoio: ``protected/models/<Entidade>.php`` e
  ``app/store/<Entidade>.js``.

* Chamada de saída, tarifação, timeout, escolha de tronco:
  comece por ``resources/asterisk/StandardCallAgi.php``.
  Arquivos de apoio: ``resources/asterisk/CalcAgi.php``,
  ``resources/asterisk/SearchTariff.php`` e
  ``resources/asterisk/AuthenticateAgi.php``.

* DID de entrada, fila, URA, roteamento de destino:
  comece por ``resources/asterisk/DidAgi.php``.
  Arquivos de apoio: ``resources/asterisk/IvrAgi.php``,
  ``resources/asterisk/QueueAgi.php``, os models Did/Diddestination e as tabelas
  ``pkg_did`` / ``pkg_did_destination``.

* Comandos especiais (voucher ``*120``, captura ``*7``, pausa na fila):
  comece por ``resources/asterisk/mbilling.php``.

* Configurações globais (idioma, versão, timeout, moeda):
  comece pela ``pkg_configuration``, pelo model Configuration.
  Arquivo de apoio: ``protected/components/LoadConfig.php``.

* Problema na interface depois do login/conferência de sessão:
  comece por ``classic/src/Application.js``.
  Endpoint de apoio: ``index.php/authentication/check``.

* Pagamento, compra de crédito, retorno de gateway, efeitos da recarga:
  comece por ``protected/controllers/BuyCreditController.php`` ou
  ``protected/controllers/<Gateway>Controller.php``.
  Arquivos de apoio: ``protected/models/Refill.php``,
  ``protected/models/BuyCredit.php`` e ``protected/models/Methodpay.php``.

* Instalação, atualização, migração, cron:
  comece por ``script/install.sh``, ``cron.php``,
  ``protected/config/cron.php`` e
  ``protected/commands/UpdateMysqlCommand.php``.
  Arquivos de apoio: ``protected/commands/*.php`` e ``script/database.sql``.

* Recarga recorrente, tipo de plano, Consumo por Plano (Comunic):
  comece por ``protected/commands/RecurringCreditCommand.php`` e
  ``protected/models/PlanConsumption.php``.
  Arquivos de apoio: ``protected/models/overrides/UserOR.php`` e ``comunic/README.md``.

Modelo mental frontend-backend
==============================

Padrão que se repete:

1. A Store ExtJS chama o endpoint ``index.php/<controller>/<action>``
2. O controller Yii aplica filtros/permissões
3. O model ActiveRecord cuida da persistência
4. O controller devolve JSON para a grade/formulário

Sequência de rastreamento recomendada:

- Identifique o endpoint chamado no frontend (store ou Ext.Ajax.request)
- Abra o controller correspondente em protected/controllers/
- Identifique o model usado
- Confira os campos e as regras do model
- Confirme a tabela afetada (nomes pkg_*)

Callbacks públicos são diferentes das chamadas autenticadas dos módulos ExtJS.
Controllers de integração como pagamento, SMS, WHMCS, Joomla e cadastro podem expor
ações específicas do provedor que não seguem o padrão CRUD normal de grade/formulário.

Resumo do fluxo de chamadas
===========================

Saída
-----

1. O dialplan chama o AGI em resources/asterisk/mbilling.php
2. Autenticação do usuário (AuthenticateAgi)
3. Conferência do número e das restrições
4. Busca da tarifa (SearchTariff)
5. Cálculo de timeout/custo (CalcAgi)
6. Escolha do tronco e discagem
7. Gravação do CDR e débito do crédito

DID de entrada
--------------

1. O mbilling.php detecta a chamada de DID
2. O DidAgi localiza o DID e os destinos
3. Encaminha para SIP/fila/URA/número externo
4. Atualiza o CDR de entrada e os custos relacionados

Lista de confiança para respostas da IA
=======================================

Antes de responder uma pergunta técnica, confira:

1. O arquivo de entrada correto da funcionalidade.
2. O mapeamento correto controller/model/tabela (fluxo web).
3. O mapeamento correto das classes AGI (fluxo de telefonia).
4. O comportamento conforme o perfil (administrador/revenda/cliente).
5. O impacto das configurações globais no comportamento.

Se as evidências do primeiro arquivo estiverem incompletas, siga as chamadas até
chegar a um destes pontos:

- acesso SQL/tabela
- método de model/controller com efeito colateral
- execução do AGI ou ponto de decisão do DIAL

Riscos comuns de interpretação
==============================

- Nomes de módulos parecidos podem confundir (por exemplo campaign* x callSummary*).
  Confira sempre o caminho exato do arquivo.
- O Application.js carrega muitos módulos; não assuma que um está ativo sem
  conferir o menu e as permissões.
- As conferências de sessão/segurança no BaseController::init() podem bloquear ações.
- O caminho de execução do AGI muda conforme as variáveis de canal do Asterisk.

Arquivos de referência recomendados
===================================

- ``wiki/en/ai_codebase_guide.rst``
- ``wiki/en/lifecycle.rst``
- ``wiki/en/module_overview.rst``
- ``wiki/GITHUB_WIKI_SYNC.md``

Convenções permanentes de manutenção
====================================

Documentação
------------

* ``wiki/en`` é a fonte oficial da documentação pública (traduzida para o
  português neste fork; o nome da pasta foi mantido).
* A wiki do GitHub é gerada a partir de ``wiki/en`` e não deve ser editada como uma
  fonte independente.
* Mantenha a documentação do projeto dentro de ``wiki`` e siga o fluxo de publicação
  da wiki do GitHub descrito em ``wiki/GITHUB_WIKI_SYNC.md``.
* ``ia-docs`` é material interno, voltado a máquinas, e não deve ser publicado como
  documentação de usuário.
* As mudanças de instalação e atualização do banco ficam em
  ``protected/commands/UpdateMysqlCommand.php`` (no código oficial). As mudanças de
  banco da Comunic ficam em ``protected/commands/PlanConsumptionSetupCommand.php``.

Diagnóstico de chamadas
-----------------------

* O diagnóstico precisa executar o fluxo de decisão do AGI de produção, em vez de
  reimplementar as regras de roteamento num serviço web.
* O ponto de entrada de diagnóstico suportado na CLI é
  ``php resources/asterisk/mbilling.php debug NUMERO MB_ACC CALLERID``.
* O modo debug é uma simulação (dry-run). Ele pode ler configurações e registros do
  banco, mas não pode executar ``Dial``, ``Queue``, áudios ou comandos de canal, criar
  CDRs, cobrar contas, atualizar tabelas operacionais, chamar integrações externas
  nem deixar gravações no banco confirmadas.
* A simulação precisa parar em ``Magnus::run_dial()``, antes da discagem, da criação do
  CDR ou da cobrança. Todo caminho novo do AGI usado pelo diagnóstico precisa
  preservar esse limite.
* Não pule validações que acontecem antes de uma operação de canal. Horários de URA,
  feriados, compatibilidade de áudio, opções de URA, existência e membros da fila,
  destinos de DID, grupos SIP, tarifas, ofertas e elegibilidade de troncos precisam
  ser avaliados pelos caminhos reais do AGI.
* Mídia opcional ou agentes de fila faltando podem ser avisos quando o fluxo de
  produção consegue continuar. Objetos de roteamento obrigatórios faltando ou um
  destino selecionado vazio são erros bloqueantes.
* Contas SIP de IP fixo são só por IP quando ``insecure`` contém ``invite`` ou quando
  não há senha guardada. O endpoint gerado usa ``identify_by=ip`` e não tem ``auth=``
  de entrada. Contas dinâmicas e com credenciais explícitas mantêm a autenticação por
  usuário e senha.
* A serialização do resultado do AGI precisa produzir exatamente uma linha
  ``MBILLING_RESULT``, substituir UTF-8 inválido e devolver um contrato de erro JSON
  mínimo e válido se a codificação normal falhar.
* Os detalhes técnicos expostos pelo diagnóstico web são só para administradores e
  nunca podem conter senhas SIP, credenciais de troncos, chaves de API, DSNs ou
  outros segredos.

Logs do AGI
-----------

* Use ``AGI::verboseEvent()`` para as decisões de roteamento validadas que o
  diagnóstico precisa interpretar.
* Os códigos de evento são identificadores estáveis usados por testes, traduções e
  pelo formatador web.
* Os níveis de verbose seguem a convenção do projeto:

  * nível 1: erro bloqueante;
  * nível 2: aviso ou candidato ignorado;
  * nível 3: decisão de roteamento;
  * nível 4: detalhe operacional;
  * nível 25: SQL ou rastreamento técnico profundo.

* O nível de log inicial normal do Asterisk é 5. As mensagens visíveis nos níveis
  normais precisam ser curtas, acionáveis e compreensíveis sem ler SQL.

Traduções e apresentação
------------------------

* As mensagens do backend para o usuário usam ``Yii::t('zii', 'Texto original em inglês')``.
* Acrescente cada chave nova em ``resources/locale/php/IDIOMA/zii.php`` para todos os
  idiomas suportados.
* O diagnóstico web segue o idioma escolhido na sessão ativa da interface, e não o
  idioma padrão guardado em ``pkg_configuration``.
* Preserve os termos técnicos consagrados, como ``Techprefix``; não os troque por um
  termo traduzido inventado.
* Os valores monetários mostrados pelo diagnóstico usam
  ``Yii::app()->session['currency']``.
* Os nomes dos tipos de destino de DID precisam ser iguais aos valores de
  ``classic/src/view/diddestination/Combo.js``.

Interface do diagnóstico
------------------------

* ``Check User`` fica em ``classic/src/view/sip/Form.js`` e ``Check DID`` fica em
  ``classic/src/view/did/Form.js``. Os dois usam a convenção ``extraButtons`` do
  formulário.
* As ações de diagnóstico e os detalhes técnicos estão disponíveis só para
  administradores.
* O texto do diagnóstico precisa continuar selecionável, para o administrador copiar
  o resultado inteiro ou só o trecho relevante.

Notas de manutenção
===================

Atualize este guia sempre que houver:

- um novo ponto de entrada (web ou AGI)
- uma mudança no fluxo de login/autenticação
- um novo módulo central (controller/model/classe AGI)
- uma mudança estrutural nas tabelas principais
- uma mudança no limite de segurança da simulação do diagnóstico
- uma mudança nas convenções de tradução, moeda, permissão ou documentação
