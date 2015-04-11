#!/usr/bin/env python
# -*- coding: utf-8 -*-
import time
import csv

from github import Github

DAYS_WEEKS = (
    'Dom',
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sab'
)


def get_commits_per_day_of_week(repo):
    """
    retorna numero de commits por cada dia da semana (0, 6)
    do repo em questão.
    ex:
    [1, 2, 4, 0, 9, 3, 10]
    seria 1 commit no domingo, 2 na segunda, 4 na terça...

    OBS: se retornar None é por que deve ser esperado mais tempo
    para pegar os dados (no minimo o tempo necessário para evitar)
    o tempo maximo de acesso a api do github. (12 secs)
    """

    punch_card = repo.get_stats_punch_card()
    if punch_card is None:
        return

    cmts_total = []
    for day in xrange(0, 7):
        num_cmts_day = 0
        for hour in xrange(0, 24):
            num_cmts_day += punch_card.get(day, hour)
        cmts_total.append(num_cmts_day)

    return cmts_total


def get_and_wait_for_commits_per_day_of_week(repo, secs=12):
    """
    Chama a função `get_commits_per_day_of_week` mas
    envolvendo a função garantindo que fique tentando
    pegar o resultado a cada 12 secs até ter algo.
    """
    commits_per_day_of_week = None
    while(commits_per_day_of_week is None):
        print "getting commits for %s" % repo.name
        commits_per_day_of_week = get_commits_per_day_of_week(repo)
        if commits_per_day_of_week is None:
            print "no result yet, waiting %d secs" % secs
            time.sleep(secs)

    return commits_per_day_of_week


def get_total_commits_from_weekly_total(commits_per_day_of_week):
    """
    Retorna o total de commits de um repositorio, a partir
    do numero de commits por dia da semana do mesmo
    """
    total = 0
    for cmts in commits_per_day_of_week:
        total += cmts

    return total


def write_repo_row(repos_csv, repo):
    """
    escreve os dados do repositorio atual,
    no csv carregado em memoria,
    numa nova linha
    """
    row_data = [
        repo.name,  # Nome do repositorio
        repo.owner.type,  # User ou Organization
        repo.created_at,  # Data em que foi criado
        repo.updated_at,  # Ultima data em que foi atualizado
        repo.size,  # Tamanho do repositorio
        repo.stargazers_count,  # Numero de Estrelas
        repo.watchers_count,  # Numero de pessoas seguindo atualizações
        repo.language,  # Linguagem principal
        repo.has_wiki,  # Tem wiki?
        repo.forks,  # Quantas vertentes (forks) foram criadas
        repo.open_issues_count  # Numero de Bugs/melhorias relatadas, em aberto
    ]


    commits_per_day_of_week = get_and_wait_for_commits_per_day_of_week(repo)

    # coloca os dados do num commits por dia da semana na linha atual
    row_data.extend(get_commits_per_day_of_week(repo))

    # coloca numero de commits totais
    row_data.append(
        get_total_commits_from_weekly_total(commits_per_day_of_week)
    )

    # escreve a linha
    repos_csv.writerow(row_data)
    return repos_csv


def save_repos_to_csv(repos, filename="repos.csv"):
    """
    salva uma lista de repos num arquivo csv no diretorio atual
    """

    with open(filename, 'wb') as csvfile:
        repos_csv = csv.writer(csvfile, delimiter=';')

        row_data = [
            'Name',  # Nome do repositorio
            'Owner Type',  # User ou Organization
            'Created at',  # Data em que foi criado
            'Last Updated at',  # Ultima data em que foi atualizado
            'Size',  # Tamanho do repositorio
            'Stars',  # Numero de Estrelas
            'Watchers',  # Numero de pessoas seguindo atualizações
            'Language',  # Linguagem principal
            'Has Wiki',  # Tem wiki?
            'Forks',  # Quantas vertentes (forks) foram criadas
            'Open Issues'  # Numero de Bugs/melhorias relatadas, em aberto
        ]
        # coloca os dias da semana na ordem que devem ser escritos
        # na seguinte forma ex: "Num. Cmts. Dom"
        row_data.extend(["Num. Cmts. %s" % day for day in DAYS_WEEKS])

        # Numero total de Commits
        row_data.append('Total Commits')

        # coloca ja os titulos das colunas
        repos_csv.writerow(row_data)

        # para cada repositorio escreve os dados na proxima linha
        for repo in repos:
            repos_csv = write_repo_row(repos_csv, repo)


def get_repos():
    """
    pega do github os dados dos repositorios
    """

    repos = []
    g = Github(per_page=100)  # defini que o num resultados p/ pagina é 100
    search = g.search_repositories(query="stars:>=200", sort="stars", order="desc")

    # pega as 3 paginas, isso é: os 300 primeiros
    for i in xrange(0, 3):
        page = search.get_page(0)
        # coloca os resultados da pagina na lista de repositorios
        repos.extend(page)

    return repos


def get_and_save_repos_to_csv_file():
    "fetch the repos and save them to a csv file"
    repos = get_repos()

    save_repos_to_csv(repos, filename="repos_cmt_day_.csv")


if __name__ == "__main__":

    get_and_save_repos_to_csv_file()
