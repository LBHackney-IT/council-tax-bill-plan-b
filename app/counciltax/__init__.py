from flask import Flask
from counciltax.db import connect_db
from counciltax.queries.sql import account_number_query

def create_app(test_config=None):
    app = Flask(__name__)

    app.config.from_mapping(
        SECRET_KEY='dev',
    )

    db_cursor = connect_db()

    @app.route('/')
    def home():
        return 'Council Tax Bill Plan B app'

    @app.route('/account/<account_number>')
    def account(account_number):
        query = f"{account_number_query} '{account_number}'"

        db_cursor.execute(query)

        results = db_cursor.fetchall()
        count = db_cursor.rowcount

        return f"{count} {results[0]},"

    return app
