# tiny-house-dashboard

## Python Dev Tools Setup
To install the env, run `pipenv install --dev`  
To initialize the git hooks, run `pipenv run pre-commit install`  
If there are file that were committed before adding the git hooks, run `pipenv run pre-commit run --all-files`  
To run tests, run `pipenv run pytest --cov-config=.coveragerc --cov=resc`  