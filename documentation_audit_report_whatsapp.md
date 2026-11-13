# Auditoria da documentação de campanhas no WhatsApp

Data: 2026-07-13

## Escopo

Documentação para usuários sobre a configuração e a operação de campanhas no WhatsApp no MagnusBilling 8, incluindo credenciais da Meta, modelos, execução de campanhas, respostas recebidas, condições da plataforma e limites de responsabilidade.

## Situação atual

- As fontes permanentes da ajuda de campo são `resources/help/help_en.js` e `resources/help/help_pt_BR.js`.
- A página de campos de campanha gerada existe em `wiki/en/modules/campaign/campaign.rst`.
- A ajuda de campanha existente descreve só Voz e SMS. Ela não descreve o tipo de campanha WhatsApp nem os campos de modelo.
- A wiki não tinha um guia completo para criar o app na Meta, obter credenciais da Cloud API, configurar o webhook, usar modelos aprovados, criar campanhas, receber respostas e entender a responsabilidade operacional.
- O `wiki/generate.php` ainda contém caminhos absolutos e configurações de banco específicos do MBilling_7, então não é seguro rodá-lo sem mudanças a partir deste checkout do MBilling_8.

## Mudanças necessárias na documentação

1. Acrescentar ajuda permanente em inglês e em português do Brasil para o tipo de campanha WhatsApp, o nome do modelo e o idioma do modelo.
2. Acrescentar um guia completo e independente de campanha WhatsApp em inglês e em português do Brasil.
3. Ligar os dois guias a partir dos índices correspondentes da wiki.
4. Deixar claro que o MagnusBilling apenas se integra à WhatsApp Business Platform da Meta e não é o remetente nem o provedor das mensagens.
5. Deixar claro que o usuário é responsável pela aprovação da conta na Meta, pelo consentimento dos destinatários, pelos modelos, pelo conteúdo, pelo público, pelo cumprimento da lei, pelas cobranças, pela classificação de qualidade, pelos bloqueios e pelas restrições da conta.
6. Citar os recursos oficiais da Meta para os detalhes de configuração e de política que podem mudar com o tempo.

## Forma de validação

- Não rodar o gerador legado até que os caminhos fixos do MBilling_7 sejam migrados.
- Validar localmente as referências e a estrutura do RST.
- Validar localmente a sintaxe dos arquivos de ajuda em JavaScript.
- Não usar credenciais reais nem contatar a Meta durante a validação da documentação.
