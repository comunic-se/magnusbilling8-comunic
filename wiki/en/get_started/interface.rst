#########
Interface
#########
A interface do MagnusBilling é feita em ExtJS e tem um menu lateral com todos os módulos listados, com os respectivos submódulos.
Uma área principal, onde todos os módulos abrem, com abas ativas e inativas.
Um menu suspenso com as opções de idioma, troca de senha, sobre e sair.


Painel de monitoramento
^^^^^^^^^^^^^^^^^^^^^^^

Na página principal há alguns gráficos e informações sobre o servidor. Esta barra só aparece na aba Início (barra de status do servidor).

	*  Modelo do processador;
	*  Uso atual do processador;
	*  Uso médio do processador;
	*  Memória total do servidor;
	*  Memória em uso;
	*  Gráfico de uso de upload e download do link;
	*  Tempo em que o servidor está online;
	*  Usuários ativos;
	*  Pico de chamadas simultâneas e de CPS (chamadas por segundo);
	*  Lucro do mês;
	*  Recargas feitas no mês;
	*  Gráfico de chamadas simultâneas, com a opção de mostrar a última hora, 6 horas, 12 horas, 1 dia, 2 dias, 3 dias ou 1 semana;
	*  Gráfico dos 3 troncos mais usados.

.. image:: ../img/dashboard.png
        :scale: 85%


Barra de botões
^^^^^^^^^^^^^^^

O MagnusBilling é um sistema modular: cada menu ou submenu corresponde a um módulo. Todos os módulos têm a mesma estrutura.
Cada módulo tem uma barra de ferramentas com estes botões:

Barra de botões dos módulos

- Botão Adicionar.
	Acrescenta um registro novo ao módulo.

- Botão Editar.
	Edita um registro; basta clicar em cima de um registro para o formulário de edição abrir.

- Botão Apagar.
	Selecione um ou mais registros e clique em Apagar; será pedida uma confirmação e, confirmada, os registros são apagados. O botão Apagar tem uma opção chamada Todos, que aparece ao clicar na seta ao lado do botão; ela apaga todos os registros
	listados no módulo. É muito útil para apagar uma grande quantidade de dados.
	**OBS.**: o banco de dados do MagnusBilling usa InnoDB com chaves estrangeiras, que ligam os dados entre si; por isso não é possível apagar dados que já estão ligados a outros. Ex.: não é possível apagar um cliente que já fez uma compra. É preciso apagar antes todos os registros ligados a esse cliente para conseguir apagá-lo.

- Botão Atualização em lote.
	Este botão é fundamental para a eficiência no uso do sistema. Como o nome diz, serve para atualizar uma grande quantidade de registros ao mesmo tempo, facilitando uma tarefa que seria impossível de fazer manualmente em módulos com muitos registros, como o de tarifas, que passa fácil dos 100 mil registros. O uso é simples: filtre os registros que quer atualizar e clique em Atualização em lote; abre um formulário com todos os campos em branco. Altere só os campos que quer atualizar, deixe os demais em branco e clique em Salvar. O processo pode levar alguns segundos e atualiza todos os registros.
	O botão Atualização em lote tem uma opção chamada Selecionados, que aparece ao clicar na seta ao lado do botão; ela atualiza só os registros selecionados.


- Botão Imprimir (CSV).
	Gera um arquivo para Excel, em formato CSV, com os registros selecionados.

- Botão Imprimir (PDF).
	Gera um arquivo PDF com os registros selecionados.

- Botão Limpar filtros.
	Limpa os filtros usados.

.. image:: ../img/buttons.png
        :scale: 85%


Colunas
^^^^^^^

Cada coluna do MagnusBilling tem várias opções, muito úteis para um bom uso do sistema.

Para ver essas opções, coloque o ponteiro do mouse em cima da coluna desejada e clique na seta.

- Ordem crescente e decrescente.
	Ordena os registros da coluna selecionada de forma crescente ou decrescente. Também dá para usar clicando em cima da coluna.

- Colunas.
	Permite mostrar ou ocultar colunas, muito útil para mostrar só os dados necessários. Exemplo: gerar uma tabela de preços para mandar a um cliente só com o nome do destino e o preço de venda.

- Agrupar por esta coluna.
	Agrupa os registros por esta coluna. É muito útil no módulo Chamadas online, onde permite agrupar as chamadas por cliente e ver separadamente as chamadas de um cliente ou de qualquer outra coluna.

- Mostrar em grupos.
	Esta opção desativa a opção anterior.

- Filtro.
	Esta opção também é fundamental, por isso tem uma explicação própria abaixo.

.. image:: ../img/colluns.png
        :scale: 85%


Sistema de filtros
^^^^^^^^^^^^^^^^^^

O MagnusBilling tem um sistema de filtros poderoso para achar os registros desejados em cada módulo.

Para usar, coloque o ponteiro do mouse em cima da coluna em que quer pesquisar, clique na seta e deslize até Filtro; abre um submenu com as opções da coluna. Continue deslizando o mouse até o campo, digite o valor que quer pesquisar e tecle Enter.
OBS.: o sistema de filtros diferencia maiúsculas de minúsculas.

Há filtros diferentes conforme o tipo da coluna:


- Filtro de texto.

	Procura nas colunas de texto valores que começam com, terminam com, contêm ou são iguais a um texto. Por exemplo, se você procurar nomes que começam com "Pedro", são listados todos os clientes com Pedro no começo do nome.

.. image:: ../img/filter_text.png
        :scale: 85%

- Filtro de números inteiros.

	Aparece nas colunas numéricas, como a coluna de crédito do cliente.

.. image:: ../img/filter_int.png
        :scale: 85%


- Filtro por datas.

	Aparece nas colunas com datas e é muito útil nos relatórios.

.. image:: ../img/filter_date.png
        :scale: 85%


- Filtro de lista (combo).

	Usado quando há relação entre módulos.

.. image:: ../img/filter_combo.png
        :scale: 85%


Para desfazer um filtro, desmarque-o no menu de filtro. Para limpar todos os filtros aplicados num módulo, clique no botão Limpar filtros.
