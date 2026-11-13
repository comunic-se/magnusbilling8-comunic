Provisionamento seguro de ATA
=============================

Os perfis de ATA do MagnusBilling contêm credenciais SIP, de administração web e de
usuário. O endereço MAC identifica um ATA, mas não o autentica. Por isso, a partir
da versão 8.0.0.8 do banco, o MagnusBilling 8 não entrega mais o perfil pela URL
antiga ``?mac=$MAC``.

Agora cada ATA exige um token de provisionamento aleatório próprio. O MagnusBilling
guarda só o hash SHA-256 dele. O token em texto aparece só na URL de
provisionamento, logo depois de ser criado ou trocado.

Criar ou trocar o token
-----------------------

1. Abra **Clientes > ATA Linksys** e selecione exatamente um ATA.
2. Selecione **Trocar o token de provisionamento** e confirme.
3. Copie a URL completa da janela que aparece uma única vez. Ela tem este formato::

      https://billing.example.com/mbilling/index.php/ata?mac=AABBCCDDEEFF&token=64-caracteres-hexadecimais-minusculos

4. Na interface web do ATA Linksys/Cisco, abra **Provisioning** e substitua o
   **Profile Rule** por essa URL completa.
5. Grave e sincronize o ATA. Confirme que ele baixa o perfil por HTTPS.

A configuração global **Server IP** precisa ter o nome público do servidor (e,
opcionalmente, a porta) usado pelo ATA. A troca do token falha de forma segura se
essa configuração estiver vazia ou não for um host válido.

Não é possível recuperar o token pelo MagnusBilling. Trocá-lo invalida na hora a URL
anterior. Se a janela for fechada antes de copiar a URL, troque o token de novo.

Impacto da atualização nos ATAs existentes
------------------------------------------

A migração do banco 8.0.0.8 deixa de propósito os hashes de token vazios. Os ATAs
existentes mantêm a última configuração SIP aplicada, mas a URL antiga, só com o MAC,
não consegue mais baixar um perfil novo. Cada ATA precisa ser migrado manualmente
com o procedimento de troca acima.

Planeje uma janela de manutenção e migre os aparelhos em lotes controlados:

1. Atualize o MagnusBilling e confira se a versão do banco é 8.0.0.8 ou mais nova.
2. Troque o token de um ATA.
3. Atualize o Profile Rule dele, sincronize e faça uma chamada de teste.
4. Só passe para o próximo ATA depois de conferir o anterior.

Não volte temporariamente ao provisionamento só com o MAC. Isso expõe todas as
credenciais do perfil a qualquer pessoa que adivinhe ou descubra o endereço MAC.

Segurança operacional
---------------------

* Sirva o painel de administração e o ``/mbilling/index.php/ata`` só por HTTPS, com
  certificado válido. A troca do token e o provisionamento são recusados por HTTP, e
  o Profile Rule gerado sempre usa HTTPS.
* Trate a URL completa como uma senha. Não a envie por chamados, chat, e-mail ou
  capturas de tela, a menos que esses sistemas sejam aprovados para segredos.
* Os logs de acesso HTTP costumam registrar a query string. Configure o proxy reverso
  e o servidor web para ocultar o parâmetro ``token`` ou para não registrar a query
  string na rota do ATA. Restrinja e renove os logs existentes que possam conter URLs
  de provisionamento.
* Troque o token depois de mudanças de pessoal, suspeita de vazamento, troca de
  aparelho ou registro acidental em log.
* Uma resposta HTTP 404 genérica é esperada para requisições por HTTP e para
  credenciais ausentes, malformadas, desconhecidas ou vencidas. Isso evita mandar
  credenciais sem TLS e evita revelar se um endereço MAC existe.

Retorno de emergência
---------------------

Se um ATA migrado falhar, restaure a configuração localmente nesse aparelho ou troque
o token e aplique a URL nova. Não volte ao endpoint legado só com MAC. Os backups do
banco não têm o token em texto e não recuperam uma URL de provisionamento perdida.
