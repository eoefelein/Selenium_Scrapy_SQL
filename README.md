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

## Deploy to GCP
### Build and Deploy to GCR
To select you account and project, run `gcloud init`  
Set a default region.  
To get and save your project id, run `export PROJECT=$(gcloud config get-value project)`  
To get the GCR tag, run `export GCR_TAG=gcr.io/$PROJECT/my-app`  
To submit the build to GCP Cloud Build, run `gcloud builds submit --tag $GCR_TAG`  
To see the GCR tag, run `echo $GCR_TAG`  

### Manually Deploy to GCE and Start Container option 1)
Go to "Compute Engine" in the GCP UI and select "CREATE INSTANCE".  
In the options select the checkbox "Deploy a container image to this VM instance."  
Paste in the GCR tag in the "Container Image" field.  
Click "Advanced container options".  
Add the Mapbox token as an environment variables.  
Select "Allow HTTP traffic" for a public deployment.  


### Automatically Deploy to GCE and Start Container (option 2)

Run:
```
gcloud compute instances create-with-container tiny-house \
  --machine-type e2-small \
  --container-image $GCR_TAG \
  --tags dash-server \
  --container-env-file .env

```

Run:
```
gcloud compute firewall-rules create dash-allow-http \
  --allow tcp:80 \
  --target-tags dash-server
``` 