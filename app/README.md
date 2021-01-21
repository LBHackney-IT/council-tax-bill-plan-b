# Council Tax Plan B application

This is a simple Flask application to prepare and create data files for printing Hackney Council Tax.

## Running the app

### Requirements

- [Python3](https://www.python.org/)
- [Pip](https://pypi.org/project/pip/)

### Recommendations

- **Respect EditorConfig**. We have an editor config file to maintain some code style and consistency. Your editor may use this file by default, or you may need an extensions, for example [this extension for VSCode](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig).

## Database connection

1. Copy the [.env.sample](.env.sample) file to `.env`
2. Following the SSH tunnel instructions in the [main README.md](../README.md) open the SSH tunnel and add the DB credentials to your `.env`. Remember, never commit you `.env` file.

## Running the application

1. Change into the `app` directory
```sh
cd app
```

2. Create a virtualenv for the app
```sh
python3 -m venv venv
```

3. Activate the virtualenv
```sh
. venv/bin/activate
```

4. Install Flask and dependencies
```sh
pip install -r requirements.txt
```

5. Run the local server:
```sh
flask run
```

App should be visible at [http://127.0.0.1:5000/](http://127.0.0.1:5000/).

## Production notes

This app is initially a proof of concept that we can generate the data to send a number of council tax bills until Hackney systems are restored.

The http server, the psycopg2-binary python package are hardly production ready, so it would need some work if we're to use this application in anger on AWS or make it widely available.
