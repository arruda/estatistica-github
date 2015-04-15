## Banco de Dados

[repos_cmt_day_maior.cvs](/repos_cmt_day_maior.cvs)

##Links:

https://api.github.com/search/repositories?q=+stars:%3E=200&sort=stars&order=desc&page=1&per_page=100
https://api.github.com/search/repositories?q=+stars:%3E=200&sort=stars&order=desc&page=2&per_page=100
https://api.github.com/search/repositories?q=+stars:%3E=200&sort=stars&order=desc&page=3&per_page=100


## buscar mais dados de cada um desses 300 reposos:

para cada item da response das chamadas nesses links:

acessar a api: https://api.github.com/repos/:owner/:repo/stats/<dado_a_ser_buscado>


*detalhe*: 5 requests per minute.
então tem que fazer um "timer" para pegar os dados extras de cada repositorio a cada 12 segundos, o que deve levar 1 hora.

E como para garantir deve ser executado 2x (eles dizem que na primeira vez q vc pede esses dados eles deixam computando e na segunda vez vc pega a 'resposta'), logo demora *2 horas para pegar esses dados extras*.

Caso queira mesmo, esses dados extras e mais elaborados estão listados aqui: https://developer.github.com/v3/repos/statistics/

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



Só isso já é o suficiente para ter um BD, 300 linhas, 10 variaveis umas que provavelmente tem ligação umas com as outras (como watchers/forks/stars) outras que provavelmente não (size e created_at por exemplo).


# gerar o BD:

Rodar:

`pip install PyGithub`

Em seguida rodar o arquivo gerar_db.py: `python gerar_db.py`
