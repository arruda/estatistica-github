#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import csv

from gerar_db import get_repo_age


def get_repo_datetime(repo_row):
    year = int(repo_row[2])
    month = int(repo_row[3])
    day = int(repo_row[4])
    return datetime.datetime(year, month, day)


def copy_and_add_age(filename_old, filename_new):
    with open(filename_old, 'r') as csvfile:
        repos_csv = csv.reader(csvfile, delimiter=';')

        with open(filename_new, 'wr') as csvfile_new:
            repos_csv_new = csv.writer(csvfile_new, delimiter=';')

            i = 0
            for row in repos_csv:
                new_data = None
                # se for linha de titulo coloca titulo
                if i == 0:
                    new_data = "Age"
                else:
                    repo_date = get_repo_datetime(row)
                    new_data = get_repo_age(repo_date)

                row.append(new_data)
                repos_csv_new.writerow(row)
                i += 1


if __name__ == "__main__":
    copy_and_add_age('repos_cmt_day_maior.csv', 'repos_cmt_day_maior_age.csv')
