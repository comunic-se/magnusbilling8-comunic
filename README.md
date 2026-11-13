# MagnusBilling 8 — Comunic

> [!NOTE]
> **Fork com customizações da Comunic** (tipo de plano, valor recorrente, Relatório de
> Recarga / Consumo por Plano e recarga mensal automática). Instalação do zero, importação
> do banco de produção e atualização: **[comunic/README.md](comunic/README.md)**.
>
> ```bash
> git clone git@github.com:comunic-se/magnusbilling8-comunic.git /opt/mb8-comunic
> cd /opt/mb8-comunic && bash comunic/instalar.sh --fuso America/Sao_Paulo
> ```


Plataforma de código aberto de tarifação, roteamento e gestão para provedores de VoIP,
call shops e serviços de telefonia.

O MagnusBilling 8 reúne um painel web de administração, um motor de tarifação e a
integração com o Asterisk. As instalações novas usam **Asterisk 20** e **PJSIP**.

> [!IMPORTANT]
> O MagnusBilling 8 deve ser instalado num servidor limpo e dedicado. A migração a
> partir do MagnusBilling 7 é feita lado a lado, em outro servidor, e não como
> atualização no mesmo servidor.

## O que o MagnusBilling oferece

- tarifação de clientes pré-pagos e pós-pagos;
- tarifas, planos de tarifas, troncos, provedores e roteamento de chamadas;
- contas SIP/PJSIP, DIDs, URAs, filas, callbacks e cartões telefônicos;
- registros de chamadas (CDR), relatórios, faturas, recargas e vouchers;
- campanhas, operação de call shop e administração de revendas;
- integrações com pagamentos, mensagens e sistemas externos;
- uma API web e processamento agendado em segundo plano.

Os módulos disponíveis dependem da instalação, da configuração e das extensões
licenciadas.

## Plataformas suportadas

O instalador reconhece hoje:

- Debian 11, 12 e 13;
- Ubuntu LTS 22.04, 24.04 e 26.04.

O ambiente inclui PHP, MariaDB, Apache, Asterisk 20, PJSIP, Fail2ban e a configuração
do firewall do servidor. Recomenda-se fortemente uma máquina virtual ou um servidor
dedicado recém-criado.

## Instalação

Conecte-se ao servidor novo como `root` e rode:

```bash
curl -O https://raw.githubusercontent.com/magnussolution/magnusbilling/source/script/install.sh
bash install.sh
```

O servidor pode reiniciar ao final da instalação. Abra `http://IP_DO_SERVIDOR` e entre
com as credenciais iniciais mostradas pelo instalador. Uma instalação nova padrão
começa com:

```text
Usuário: root
Senha: magnus
```

Troque essa senha imediatamente e limite o acesso ao painel e ao SSH a redes
confiáveis.

Para os passos de validação e a solução de problemas, leia o
[guia de instalação](wiki/en/get_started/quick_install.rst).

## Migração a partir do MagnusBilling 7

Não instale a versão 8 por cima de um servidor com a versão 7. Prepare um servidor
novo suportado, faça backups verificados, migre o banco de dados e revise cada tronco
e cada endpoint depois da conversão de `chan_sip` para PJSIP.

Siga o
[guia completo de migração do MagnusBilling 7 para o 8](wiki/en/get_started/migrate_from_mb7.rst)
e leia o [ciclo de vida das versões](wiki/en/lifecycle.rst) antes de agendar a parada
da produção.

## Arquitetura

```text
Navegador / clientes da API
        |
Apache + PHP
        |
Aplicação web Yii 1 ------ MariaDB
        |                     |
        +---- AMI / AGI ------+
                 |
          Asterisk 20 / PJSIP
                 |
       operadoras e aparelhos SIP
```

A interface de administração é feita em Ext JS 6. O backend em PHP usa Yii 1, lê a
conexão com o banco em `/etc/asterisk/res_config_mysql.conf` e se comunica com o
Asterisk por AMI, AGI e arquivos de configuração gerados.

Veja [ARCHITECTURE.md](ARCHITECTURE.md) para os limites entre os componentes e os
principais pontos de entrada.

## Mapa do repositório

| Caminho | Finalidade |
| --- | --- |
| `app/`, `classic/`, `modern/` | aplicação Ext JS, telas e temas |
| `protected/controllers/` | controllers HTTP e da API |
| `protected/models/` | models Yii e persistência do domínio |
| `protected/components/` | serviços de tarifação, telefonia, integrações e compartilhados |
| `protected/commands/` | comandos de console agendados e administrativos |
| `resources/asterisk/` | AGI e integração com o Asterisk |
| `resources/locale/` | traduções da interface |
| `script/` | instalador, esquema do banco, migração e configuração do sistema |
| `protected/tests/` | suítes de testes em PHP |
| `wiki/` | fonte da documentação do projeto e da wiki do GitHub |
| `comunic/`, `custom/` | customizações da Comunic (ver [comunic/README.md](comunic/README.md)) |

## Desenvolvimento

É uma aplicação de nível de sistema: para funcionar por completo depende de Asterisk,
MariaDB, Apache e da configuração do Linux. Use um ambiente de desenvolvimento
isolado; nunca teste mudanças no instalador ou na telefonia num servidor de produção.

A aplicação Ext JS é compilada com o Sencha Cmd 6.2:

```bash
sencha app build development
sencha app build production
```

Os testes unitários em PHP usam PHPUnit. Com o PHPUnit disponível, rode uma suíte
individual a partir da raiz do repositório, por exemplo:

```bash
phpunit protected/tests/unit/PjsipIpAuthenticationProbeTest.php
```

Os arquivos de teste em `protected/tests/` também incluem suítes de regressão
executáveis e focadas. Rode os testes relacionados ao código que você alterar e
descreva no pull request as verificações que dependem do ambiente.

A preparação do ambiente de quem contribui, os padrões e a lista de conferência do
pull request estão em [CONTRIBUTING.md](CONTRIBUTING.md).

## Documentação

- [Definição do projeto e roadmap](PROJECT.md)
- [Arquitetura](ARCHITECTURE.md)
- [Wiki de usuários e administradores](wiki/en/index.rst)
- [Novidades do MB8](wiki/en/whats_new_mb8.rst)
- [Suporte](SUPPORT.md)
- [Política de segurança](SECURITY.md)
- [Histórico de mudanças](CHANGELOG.md)
- [Customizações da Comunic](comunic/README.md)

## Comunidade e suporte

Use as [GitHub Issues](https://github.com/magnussolution/magnusbilling/issues) do
projeto oficial para erros reproduzíveis e propostas de funcionalidades. Use os canais
listados em [SUPPORT.md](SUPPORT.md) para dúvidas de instalação e configuração.

Siga o [Código de Conduta](CODE_OF_CONDUCT.md). Vulnerabilidades de segurança devem
ser comunicadas em particular, como descrito em [SECURITY.md](SECURITY.md), e não numa
issue pública.

## Como contribuir

Contribuições são bem-vindas. Antes de abrir um pull request:

1. leia o [CONTRIBUTING.md](CONTRIBUTING.md);
2. procure issues e pull requests já existentes;
3. mantenha as mudanças focadas e inclua testes ou um procedimento de verificação;
4. atualize a documentação quando o comportamento visível ao usuário mudar.

## Licença

O MagnusBilling é distribuído sob a
[GNU Lesser General Public License v3.0](LICENSE).

## Mantenedor e agradecimentos

O MagnusBilling foi criado por
[Adilson Magnus](https://github.com/magnussolution) / MagnusSolution.
Veja os
[colaboradores](https://github.com/magnussolution/magnusbilling/contributors)
do repositório para conhecer todos que ajudaram a melhorar o projeto.
