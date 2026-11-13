Diagnóstico de chamadas
=======================

As ferramentas de diagnóstico de chamadas permitem ao administrador conferir o
roteamento de saída de uma conta SIP e o roteamento de entrada de um DID sem fazer
uma chamada real. As duas ações ficam na barra de ferramentas do formulário de cada
módulo, pela convenção ``extraButtons``.

Acesso
------

Esta função está disponível só para administradores. O MagnusBilling esconde as
ações de diagnóstico dos outros usuários, e o backend recusa pedidos diretos feitos
sem uma sessão de administrador.

A atualização do banco de ``8.0.0.4`` para ``8.0.0.5`` em
``protected/commands/UpdateMysqlCommand.php`` cria o módulo oculto
``callDiagnostic`` e dá permissão de leitura ao grupo de administradores padrão. Não
é preciso rodar um script SQL separado.

A atualização do banco de ``8.0.0.5`` para ``8.0.0.6`` normaliza as contas de IP fixo
sem senha e gera de novo a configuração PJSIP dos usuários. As contas configuradas
para autenticar só por IP usam ``identify/match`` com ``identify_by=ip`` e não
recebem associação ``auth=`` de entrada. Não é preciso editar manualmente o arquivo
PJSIP gerado.

A atualização do sistema de ``8.0.0.6`` para ``8.0.0.7`` acrescenta
``noload => res_pjsip_endpoint_identifier_anonymous.so`` ao ``modules.conf`` do
Asterisk. Isso impede que um INVITE não identificado chegue ao AGI de tarifação por
um canal ``PJSIP/anonymous-*``. Reinicie o Asterisk depois da atualização, num
horário controlado, para ativar a mudança de módulo.

Check User
----------

#. Abra **Usuários > Usuários SIP**.
#. Selecione exatamente uma conta SIP.
#. Clique em **Check User**.
#. Informe o número de destino.
#. Clique em **Rodar diagnóstico**.

O CallerID vem preenchido da conta SIP selecionada e pode ser mudado antes de rodar
o diagnóstico. A conferência sempre usa a data e a hora atuais.

O resultado é produzido pelo mesmo código de roteamento do AGI usado numa chamada
real. O AGI roda num contexto protegido de simulação (dry-run) e segue a
normalização do número, as restrições, a portabilidade, a tarifa, o crédito, o grupo
de troncos e a escolha do tronco. Ele para ao entrar em ``Magnus::run_dial()`` e não
faz a chamada.

Toda a atividade no banco feita durante a avaliação da rota fica dentro de uma
transação, desfeita antes de o resultado ser devolvido. Comandos do Asterisk como
``Dial``, ``Queue``, reprodução de áudio e operações de canal são ignorados no modo de
simulação e nunca são enviados ao Asterisk.

Quando uma tarifa é escolhida, o resultado identifica o plano, a tarifa por minuto,
a taxa de conexão, o bloco inicial e o bloco de cobrança. Se um pacote de oferta se
aplicar, o preço aparece como zero e o pacote é identificado. O resultado também
identifica a autenticação ou a escolha de plano por Techprefix, o número
normalizado, o grupo de troncos, o tronco escolhido e o número que seria enviado ao
tronco.

Check REGISTER
--------------

O botão **Check REGISTER** aparece ao lado de **Rodar diagnóstico** na janela Check
User. Ele lê um trecho recente e limitado do ``/var/log/asterisk/messages`` e
relaciona a conta SIP selecionada ao último evento REGISTER e ao IP de origem. O
resultado diferencia credenciais inválidas, endpoint não carregado, endereço recusado
pelas regras de acesso, o desafio normal de autenticação e uma atualização de
contato bem-sucedida.

Para cada IP de origem encontrado, o diagnóstico confere os bloqueios ativos na
``pkg_firewall`` (incluindo faixas CIDR IPv4) e o status atual das jails do Fail2Ban.
Ele nunca remove um bloqueio. Confirme que o endereço pertence ao cliente antes de
usar as ferramentas normais de administração do firewall para desbloqueá-lo.

O serviço web precisa de permissão de leitura no log de mensagens do Asterisk. A
conferência do Fail2Ban em tempo real usa os comandos somente leitura
``fail2ban-client status`` e ``fail2ban-client status JAIL``, com tempo limite curto.
Se alguma das fontes não puder ser lida, essa conferência é marcada como
inconclusiva, em vez de adivinhar a causa. Linhas brutas do log, senhas e dados de
autenticação não são devolvidos ao navegador.

A mesma conferência sob demanda lê só as seções da conta selecionada em
``/etc/asterisk/pjsip_magnus_user.conf``. Ela valida os objetos AOR, endpoint, auth e
identify gerados contra a conta no banco, incluindo contexto, ``aors``,
``identify_by``, usuário de autenticação, presença de senha, ``max_contacts`` e
codecs. Os valores de senha são substituídos antes de montar qualquer resultado. Ela
também consulta o endpoint e o AOR carregados no momento no Asterisk, para diferenciar
um reload pendente de um erro de geração e informar se existe um contato agora.

Depois da primeira análise do REGISTER, **Capturar pacotes SIP** inicia o processo
SipTrace existente para a conta selecionada e para a porta UDP configurada no
``pjsip.conf``. Depois da confirmação, o administrador tem 120 segundos para pedir ao
cliente que registre o aparelho. A janela acompanha a captura e explica a troca de
REGISTER ao vivo: nenhum pacote chegou ao servidor, desafio 401 sem resposta, pedido
autenticado recusado, endpoint não encontrado, proibido, intervalo curto demais, sem
resposta do Asterisk ou 200 OK com sucesso.

A análise da captura começa na posição do arquivo gravada para aquele pedido e
relaciona os pacotes pelo Call-ID. A identidade do endpoint é comparada exatamente
nos cabeçalhos SIP, então uma ocorrência textual do ngrep para ``test12323`` nunca é
atribuída a ``test1``. Nomes parecidos aparecem explicitamente como um usuário
diferente. Os valores de Authorization e da resposta digest nunca são devolvidos ao
navegador.

Check DID
---------

#. Abra **DIDs**.
#. Selecione exatamente um DID.
#. Clique em **Check DID**.
#. Se quiser, informe o CallerID de origem.
#. Clique em **Rodar diagnóstico**.

O número do DID selecionado é passado ao mesmo ponto de entrada ``mbilling.php`` usado
pelo Asterisk. Por isso, a normalização do DID, o tratamento de números especiais e
a prioridade dos destinos sempre seguem o código AGI instalado. Mudanças nas regras
de roteamento em ``resources/asterisk`` passam a valer automaticamente nos próximos
diagnósticos.

O diagnóstico de DID identifica o tipo de destino configurado com os mesmos nomes do
formulário de destino. Conforme a rota escolhida, ele valida as expressões de
bloqueio e os preços do DID, os usuários vinculados, as contas SIP e os grupos SIP,
os horários, feriados, opções e compatibilidade de áudio das URAs, a existência e os
membros das filas, os destinos com vários IPs e as demais condições alcançadas pelo
fluxo do AGI de produção. A falta de dados de roteamento obrigatórios é bloqueante. A
falta de um áudio opcional da URA ou uma fila sem agentes aparece como aviso quando a
rota de produção ainda consegue continuar.

Lendo o resultado
-----------------

Cada etapa é marcada como aprovada, aviso, falha ou inconclusiva. O diagnóstico para
no primeiro erro bloqueante e traz uma ação recomendada. O texto mostrado pode ser
selecionado e copiado, inclusive só um trecho de uma mensagem.

As mensagens seguem o idioma escolhido na sessão ativa do MagnusBilling. Os valores
monetários usam a moeda da sessão. Os detalhes técnicos estão disponíveis só para
administradores e são formatados para leitura, sem expor credenciais.

Se o próprio processo AGI isolado falhar, o resultado identifica a falha antes de
mostrar qualquer resumo da rota. O administrador vê um código de falha estável, uma
explicação em linguagem simples, a ação recomendada, o código de saída do processo,
erros de leitura do JSON, conferências de permissão e a saída limitada do processo.
Detalhes vazios da rota não são mostrados quando o roteamento nem chegou a ser
avaliado.

O ID do diagnóstico é registrado em log junto com a falha classificada e metadados
seguros da execução. O administrador pode mandar o ID com a evidência técnica
selecionável para o suporte, sem precisar de acesso direto ao servidor.

Logs do AGI
-----------

As decisões de roteamento usam mensagens estáveis neste formato::

    [MBilling][Component][EVENT_CODE] Human-readable message | key=value

As novas mensagens operacionais seguem a faixa de verbosidade do AGI do Asterisk:

* nível 1: erro de validação bloqueante;
* nível 2: aviso ou candidato de rota ignorado;
* nível 3: decisão de roteamento;
* nível 4: contexto útil do processamento.

O nível de verbosidade padrão 5 do Asterisk mostra todos os eventos operacionais.
Consultas ao banco e dumps internos continuam no nível 25 e só aparecem quando a
depuração estendida é ativada explicitamente. A interface de diagnóstico usa o código
de evento estável e o contexto estruturado, em vez de interpretar frases livres do log.

Notas de segurança e implementação
----------------------------------

Os endpoints de diagnóstico aceitam só requisições ``POST``, aplicam um limite de
frequência por sessão e devolvem JSON. As informações detalhadas de roteamento só
aparecem dentro de uma sessão autenticada de administrador. O serviço web inicia o
processo AGI com argumentos validados, tempo limite de execução e limite de tamanho
da saída. Todas as mensagens do backend para o usuário usam ``Yii::t('zii', ...)``, e
as chaves de tradução ficam em ``resources/locale/php/IDIOMA/zii.php``.

O AGI emite exatamente uma linha começando com ``MBILLING_RESULT``. A serialização do
resultado substitui com segurança o UTF-8 inválido e, se a codificação JSON ainda
falhar, devolve um contrato de erro mínimo e válido. O leitor web registra evidências
limitadas e sem credenciais para conteúdos malformados, incluindo o tamanho em bytes,
o erro do JSON, a detecção de bytes inválidos, a saída extra e a etapa de montagem.

Os principais arquivos da implementação são:

* ``protected/components/CallDiagnosticService.php``;
* ``protected/components/SipRegisterDiagnosticService.php``;
* ``protected/controllers/CallDiagnosticController.php``;
* ``classic/src/view/callDiagnostic/Window.js``;
* ``classic/src/view/sip/Form.js``;
* ``classic/src/view/did/Form.js``;
* ``resources/asterisk/mbilling.php`` e as classes ``*Agi.php`` alcançadas pela rota de
  produção.
