# tiny-house-dashboard

## Python Dev Tools Setup
To install the env, run `pipenv install --dev`  
To initialize the git hooks, run `pipenv run pre-commit install`  
If there are file that were committed before adding the git hooks, run `pipenv run pre-commit run --all-files`  
To run tests, run `pipenv run pytest --cov-config=.coveragerc --cov=resc`  

## Start the App Locally
Copy `demo.env` to `.env`: `cp demo.env .env`  
Change `MAPBOX_TOKEN` in `.env` to your Mapbox Token  
Run the app locally in dev mode with `pipenv run python app/app.py`  