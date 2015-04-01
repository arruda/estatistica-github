#!/usr/bin/env python
# -*- coding: utf-8 -*-
import csv

from github import Github


def write_repo_row(repos_csv, repo):
    """
    escreve os dados do repositorio atual,
    no csv carregado em memoria,
    numa nova linha
    """

    repos_csv.writerow(
        [
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
    )
    return repos_csv


def save_repos_to_csv(repos, filename="repos.csv"):
    """
    salva uma lista de repos num arquivo csv no diretorio atual
    """

    with open(filename, 'wb') as csvfile:
        repos_csv = csv.writer(csvfile, delimiter=';')

        # coloca ja os titulos das colunas
        repos_csv.writerow(
            [
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
        )

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

    save_repos_to_csv(repos, filename="repos.csv")


if __name__ == "__main__":

    get_and_save_repos_to_csv_file()
