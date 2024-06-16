 pipeline {

    agent { label 'maven-agent'}
    
	 environment { 
	 AWS_DEFAULT_REGION=eu-north-1
	 AWS_SECRET_ACCESS_KEY=mmwzD50FkyNL3yST5hpQZ5bXAokdJeop3ZCz2+74
	 AWS_ACCESS_KEY_ID=AKIA4VWKTBIC3RYNBG5Z
   }



        stage('Terraform init') {

            steps {

                sh 'terraform init'

            }

        }

        stage('Terraform apply') {

            steps {

                sh 'terraform apply --auto-approve'

            }

        }

}
