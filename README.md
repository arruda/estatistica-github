## Banco de Dados

[repos_cmt_day_maior.csv](/repos_cmt_day_maior.csv)

## Alguns dados possiveis (sem contar com os extras):
 * name
 * owner_type: (user ou organization)
 * created_at
 * updated_at
 * size (tamanho do repositorio)
 * stargazers_count (numero de pessoas que deram uma estrela no repositorio)
 * watchers_count (numero de pessoas que estão 'assinando' esse repositorio, e recebendo atualizações do que acontece nele)
 * language (linguagem principal usada no projeto)
 * has_wiki (se esse repositorio tem alguma wiki no proprio github, dai podemos tentar cruzar se os repositorios q tem wikis são mais propensos a serem famosos, já q as pessoas entendem do q ele se trata com a documentação da wiki)
 * forks_count (numero de pessoas que criaram uma copia/vertente desse projeto)
 * open_issues (numero de bugs/features, relatadas, em aberto)
 * Numero de commits por dia da semana (uma coluna para cada dia)


# gerar o BD:

Rodar:

`pip install PyGithub`

Em seguida rodar o arquivo gerar_db.py: `python gerar_db.py`

*OBS*: colocar como variavel de ambiente o usuario e password do github, para poder fazer mais requisições na API do site: `GH_U='meu_usuario' GH_P='minha_senha' python gerar_db.py`


# Sobre a API do Github

Links:

https://api.github.com/search/repositories?q=+stars:%3E=200&sort=stars&order=desc&page=1&per_page=100
https://api.github.com/search/repositories?q=+stars:%3E=200&sort=stars&order=desc&page=2&per_page=100
https://api.github.com/search/repositories?q=+stars:%3E=200&sort=stars&order=desc&page=3&per_page=100


## Como buscar + dados em cada um dos repositorios

para cada item da response das chamadas nesses links:

acessar a api: https://api.github.com/repos/:owner/:repo/stats/<dado_a_ser_buscado>

Caso queira mesmo, esses dados extras e mais elaborados estão listados aqui: https://developer.github.com/v3/repos/statistics/
