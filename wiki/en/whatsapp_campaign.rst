.. _whatsapp-campaign:

Campanhas no WhatsApp
=====================

Este guia explica como ligar o MagnusBilling à WhatsApp Business Platform oficial da Meta, enviar modelos aprovados a partir de uma campanha e receber respostas por um webhook.

.. important::

   O MagnusBilling não é um provedor de mensagens do WhatsApp e não entrega mensagens. Ele só integra a sua instalação do MagnusBilling com a WhatsApp Business Cloud API oficial da Meta. Quem processa a entrega é a Meta, que aplica as próprias regras de aprovação, preço, qualidade, limite de mensagens e fiscalização.

Responsabilidade e uso aceitável
--------------------------------

A pessoa ou organização dona e operadora das contas da Meta e do MagnusBilling é a única responsável por:

* obter o consentimento válido (opt-in) dos destinatários antes de enviar uma mensagem;
* guardar as provas do consentimento e oferecer uma forma clara de descadastro;
* escolher os destinatários, o conteúdo, os modelos, os idiomas, as datas, os horários e a frequência de envio;
* cumprir a WhatsApp Business Messaging Policy, os WhatsApp Business Terms, as regras de comércio, os requisitos de privacidade e proteção de dados (como a LGPD), as regras de telecomunicações, as regras de defesa do consumidor e todas as leis aplicáveis nas jurisdições de quem envia e de quem recebe;
* todas as taxas da Meta, impostos, verificação da conta, formas de pagamento, classificação de qualidade, limites de mensagens, decisões sobre modelos, bloqueios, suspensões e outras restrições;
* proteger os tokens de acesso, os segredos do app, os dados pessoais e o acesso ao servidor MagnusBilling.

Não use campanhas para mensagens não solicitadas, listas compradas sem consentimento válido, enganação, assédio, conteúdo ilegal ou produtos e serviços proibidos/restritos. Uma requisição à API aceita tecnicamente não comprova que a mensagem é lícita, está em conformidade, foi aceita ou foi entregue.

A Meta pode mudar suas interfaces, preços, limites e políticas a qualquer momento. Leia sempre as versões atuais da `WhatsApp Business Messaging Policy <https://business.whatsapp.com/policy>`_, dos `WhatsApp Business Terms <https://www.whatsapp.com/legal/business-terms/>`_, das `orientações sobre opt-in <https://developers.facebook.com/docs/whatsapp/overview/getting-opt-in>`_ e dos `preços da plataforma <https://business.whatsapp.com/products/platform-pricing>`_ antes de usar uma campanha. Essas regras oficiais prevalecem sobre este guia.

Requisitos
----------

Antes de começar, confirme que você tem:

* o MagnusBilling 8 atualizado até a versão de banco 8.0.0.4;
* uma URL HTTPS pública com certificado válido, se for receber respostas;
* uma conta de desenvolvedor da Meta e um portfólio empresarial na Meta;
* um app empresarial com o produto WhatsApp;
* uma WhatsApp Business Account (WABA) e um número de telefone aceito pela Meta;
* um modelo de mensagem aprovado;
* números de destinatários com opt-in válido, gravados no formato internacional com código do país;
* um usuário ativo no MagnusBilling com crédito e uma agenda com números ativos.

O painel da Meta muda de vez em quando. Se algum nome estiver diferente, siga o `guia inicial da Cloud API <https://developers.facebook.com/docs/whatsapp/cloud-api/get-started>`_ atual.

1. Crie o app na Meta e a conta do WhatsApp
-------------------------------------------

#. Entre em `Meta for Developers <https://developers.facebook.com/>`_ e abra **My Apps**.
#. Crie um app para uso empresarial e associe-o ao portfólio empresarial correto.
#. Acrescente o produto **WhatsApp** ao app.
#. Abra a área de configuração da API do WhatsApp.
#. Selecione ou crie a WhatsApp Business Account.
#. Acrescente o número remetente e conclua as etapas de verificação e de nome de exibição pedidas pela Meta.
#. Acrescente uma forma de pagamento válida quando a Meta exigir para uso em produção.
#. Anote o **Phone Number ID** e o **WhatsApp Business Account ID**. Hoje o envio pelo MagnusBilling precisa do Phone Number ID; o ID da WABA continua útil para a administração na Meta.

Um número de teste e um token temporário da Meta podem ser usados na configuração inicial, mas não são credenciais adequadas para produção.

2. Crie um token de acesso de produção
--------------------------------------

Use as Configurações do Negócio da Meta para criar ou escolher um usuário do sistema para a integração. Atribua a esse usuário do sistema o app e os ativos do WhatsApp necessários e gere um token de acesso de produção com as permissões exigidas pela Cloud API atual, normalmente incluindo:

* ``whatsapp_business_messaging``;
* ``whatsapp_business_management``.

Copie o token uma única vez e guarde-o com segurança. Nunca o coloque em capturas de tela, chamados, mensagens de chat, controle de versão ou documentação pública. Use as permissões mínimas necessárias, restrinja o acesso administrativo e troque o token na hora se ele puder ter vazado. A Meta controla a validade do token e pode revogá-lo.

3. Configure o MagnusBilling
----------------------------

Rode a atualização do banco do MagnusBilling antes de configurar a integração. Em **Configurações > Configuração**, preencha:

``WhatsApp Phone Number ID``
   O Phone Number ID mostrado na configuração da API do WhatsApp na Meta.

``WhatsApp Access Token``
   O token de produção criado para a integração. Não use um token temporário de teste em produção.

``WhatsApp API Version``
   A versão da Graph API usada pelo MagnusBilling. Mantenha o padrão instalado, a menos que a integração esteja sendo atualizada e validada para outra versão.

``WhatsApp API Timeout``
   Tempo máximo, em segundos, de uma requisição à API.

O token é sensível. Limite o acesso ao menu Configuração e aos backups do servidor que contêm o banco.

4. Crie e aprove um modelo
--------------------------

#. Abra o WhatsApp Manager nas ferramentas empresariais da Meta.
#. Crie um modelo de mensagem com a categoria, o nome, o idioma, o corpo e os exemplos exigidos.
#. Envie para a Meta e espere o status ficar aprovado antes de ativar a campanha.
#. Copie o nome do modelo e o código do idioma exatamente como a Meta mostra. São valores da integração que diferenciam maiúsculas de minúsculas.

Leia as `diretrizes de modelos de mensagem <https://developers.facebook.com/docs/whatsapp/message-templates/guidelines>`_ e o `guia de envio de modelos <https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-message-templates>`_ atuais da Meta. A Meta pode recusar, pausar ou desativar um modelo por causa do conteúdo, do retorno dos usuários ou do cumprimento das políticas.

.. warning::

   A integração atual de campanhas do MagnusBilling envia só o nome e o idioma do modelo. Ela não envia componentes de cabeçalho, corpo, botões ou variáveis. Use um modelo que não exija parâmetros. Um modelo com marcadores como ``{{1}}`` não vai funcionar até o suporte a componentes ser implementado.

5. Prepare a agenda
-------------------

#. Abra **Torpedo de voz > Agendas** e crie ou escolha uma agenda do usuário da campanha.
#. Importe os destinatários no formato internacional: código do país, DDD e número. Recomenda-se usar só dígitos.
#. Confirme que os números estão com status ativo e que todos os destinatários deram opt-in válido para o WhatsApp.
#. Retire, antes de cada campanha, os destinatários descadastrados, inválidos, bloqueados ou que por outro motivo não podem receber.

O fato de um número ter conta no WhatsApp não é consentimento para receber mensagens de marketing ou automáticas.

6. Crie a campanha de WhatsApp
------------------------------

#. Abra **Torpedo de voz > Campanhas** e crie uma campanha.
#. Selecione o usuário dono da agenda e com crédito disponível.
#. Em **Tipo**, escolha **WhatsApp**.
#. Informe um nome e configure a data de início, a data de término, os dias da semana, a hora de início diária e a hora de término diária.
#. Em **Frequência**, coloque o número máximo de contatos que o MagnusBilling deve tentar por minuto. Os limites de vazão e de mensagens da própria Meta continuam valendo.
#. Selecione uma ou mais agendas.
#. Na aba **Mensagens**, preencha **Nome do modelo do WhatsApp** e **Idioma do modelo do WhatsApp** exatamente como aprovados pela Meta.
#. Ative **Restringir números** se a lista local de números restritos precisar ser aplicada.
#. Salve a campanha com status ativo.

O processo de campanhas do WhatsApp roda a cada minuto. Ele escolhe os números ativos das agendas que estão dentro do horário da campanha. Uma aceitação pela Cloud API é registrada no histórico de mensagens com o ID da mensagem na Meta. Aceitação não é o mesmo que entrega final.

7. Receba respostas
-------------------

As respostas exigem um webhook HTTPS público.

#. Em **Configurações > Configuração**, crie um valor aleatório forte para **WhatsApp Webhook Verify Token**. É um segredo escolhido por você; não é o token de acesso.
#. Copie o **App Secret** do app da Meta para **WhatsApp App Secret**.
#. Na configuração de webhook do WhatsApp no app da Meta, use esta URL de callback, trocando o host e o diretório de instalação conforme for preciso::

      https://SEU_HOST/mbilling/index.php/whatsappWebhook/index

#. Informe o mesmo verify token configurado no MagnusBilling.
#. Conclua a verificação do webhook na Meta.
#. Assine o webhook da WhatsApp Business Account no campo ``messages``. Siga o `guia de configuração de webhooks <https://developers.facebook.com/docs/whatsapp/cloud-api/guides/set-up-webhooks>`_ atual da Meta.

As requisições recebidas só são aceitas quando o ``X-Hub-Signature-256`` confere com o App Secret configurado. As mensagens recebidas ficam em **Torpedo de voz > Mensagens recebidas**, com canal ``whatsapp`` e status **Recebida**.

O MagnusBilling associa a resposta ao envio de WhatsApp mais recente registrado para aquele número. Para envios mais antigos, ele também tenta localizar o número numa agenda de campanha de WhatsApp. Uma resposta que não pode ser associada a um usuário do MagnusBilling é registrada no log do servidor e não aparece no menu.

Lista de conferência operacional
--------------------------------

Antes de ativar uma campanha, confirme tudo isto:

* a versão do banco é pelo menos 8.0.0.4;
* o Phone Number ID e o token de acesso de produção são da mesma configuração na Meta;
* o modelo está aprovado, ativo, sem parâmetros e com o mesmo nome e idioma configurados;
* o dono da campanha tem crédito;
* a campanha está ativa e dentro da janela de data, dia da semana e horário;
* as agendas têm números ativos, no formato certo e com opt-in;
* a frequência é compatível com os limites da Meta e com a taxa de envio desejada;
* o processo do cron de campanhas está rodando;
* a qualidade da conta, os limites de mensagens, a cobrança e o status do número estão saudáveis no WhatsApp Manager;
* as listas de números restritos e de descadastro estão atualizadas.

Problemas comuns
----------------

Nenhuma mensagem é enviada
   Confira o token, o Phone Number ID, o nome/idioma do modelo aprovado, o crédito do usuário, o horário da campanha, os números ativos nas agendas, o processo do cron, a cobrança na Meta, a classificação de qualidade, os limites de mensagens e as restrições da conta.

A Meta informa que faltam parâmetros do modelo
   O modelo escolhido exige componentes ou variáveis. Use um modelo aprovado sem parâmetros com a integração atual.

A API aceita a mensagem, mas o destinatário não recebe
   Aceitação pela API não é entrega. Confira o status e o diagnóstico da mensagem na Meta, a elegibilidade do destinatário, o opt-in, a qualidade, os limites, o status do modelo e o número de destino.

As respostas não aparecem
   Confirme a disponibilidade do HTTPS, a verificação do webhook, a assinatura do campo ``messages``, o App Secret, o cabeçalho de assinatura e se o número que respondeu existe num envio de WhatsApp registrado ou numa agenda de campanha.

A integração para de repente
   Confira se a Meta revogou o token, mudou as permissões dos ativos, desativou o modelo, restringiu a conta ou o número, mudou algum requisito da API ou aposentou a versão da Graph API configurada.

Sem garantia de entrega
-----------------------

O MagnusBilling não controla a rede, as aprovações, a entrega, os preços, os aparelhos dos destinatários, os bloqueios, os sistemas de qualidade nem as decisões de fiscalização da Meta. A integração não garante aceitação, entrega, leitura, respostas, serviço ininterrupto nem a continuidade de qualquer recurso da Meta. O usuário assume toda a responsabilidade e o risco da configuração e do uso das campanhas no WhatsApp. Este guia é uma informação operacional e não é aconselhamento jurídico.
