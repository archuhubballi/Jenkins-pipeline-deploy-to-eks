#!/usr/bin/env groovy
pipeline {
    agent any
    tools {
        terraform 'Terraform'// Ensure Terraform is configured in Jenkins
        git 'Git'
    }
        environment {
            REPO_URL = 'https://github.com/archuhubballi/Jenkins-pipeline-deploy-to-eks.git'
	        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
		    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
			}
		stages {
		    stage('Checkout') {
            steps {
                git branch: 'main', url: REPO_URL, credentialsId: 'GitHub-Creds'
            }
        }
			stage("Create EKS Cluster"){
			    steps {
			        script {
			            dir('terraform/EKS'){
			                sh "terraform init -reconfigure"
							sh "terraform validate"
							sh "terraform plan"
							sh "terraform apply -auto-approve"  
			            }
			        }
			    }
			}
			stage("Deploy to EKS") {
				steps {
				    script {
					    dir('kubernetes'){
					    sh "aws eks update-kubeconfig --name https://52FCD18AF9D0C1D2697D6A09678F8FF4.sk1.us-east-2.eks.amazonaws.com"
					    sh "kubectl config view"
					    sh "kubectl apply -f nginx-deployment.yml"
					    sh "kubectl apply -f nginx-service.yml"
					    }
				}
			}
	    }
    }
}
