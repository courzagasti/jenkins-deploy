pipeline {
  agent any

  environment {
    TF_VAR_subscription_id = credentials('azuresubscription_id')
    AZURE_CLIENT_ID        = credentials('azureclient_id')
    AZURE_CLIENT_SECRET    = credentials('azureclient_secret')
    AZURE_TENANT_ID        = credentials('azuretenant_id')
    ACR_NAME               = 'acrtfexample'
    IMAGE_NAME             = 'myapp'
    IMAGE_TAG              = 'latest'
    RESOURCE_GROUP         = 'rg-containerapp'
  }

  stages {
    stage('Terraform Init & ACR Deployment') {
      steps {
        dir('terraform/infra') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Login to Azure & ACR') {
      steps {
        sh '''
        source /opt/azenv/bin/activate
        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
        az acr login --name $ACR_NAME
        '''
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        dir('docker') {
          sh '''
          source /opt/azenv/bin/activate
          ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer -o tsv)
          docker build -t $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG .
          docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy Container App') {
      steps {
        dir('terraform/app') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}