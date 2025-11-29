# Jenkins: Installation and Usage Guide

## What is Jenkins?
Jenkins is an open-source automation server used for continuous integration and continuous delivery (CI/CD). It helps automate building, testing, and deploying software projects.

---

## 1. Installation (Recommended: Docker)

### Prerequisites
- Docker installed on your system

### Run Jenkins with Docker (Official Image)
You can start Jenkins using the official Docker image. No Dockerfile is needed unless you want custom plugins or configuration.
From the terminal, run these commands (you can also save it in a .sh file):

**To use the latest LTS with JDK 17:**
```bash
docker pull jenkins/jenkins:lts-jdk17
```

**Run Jenkins:**
```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk17
```

- Jenkins will be available at `http://localhost:8080`
- The initial admin password can be found in the container logs or in the file `/var/jenkins_home/secrets/initialAdminPassword`.

Access through this command:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## 2. Jenkinsfile Example
A Jenkinsfile defines your CI/CD pipeline. Place it in the root of your GitHub repository.

```groovy
pipeline {
  agent any
  environment {
    REGISTRY = 'registry.example.com'
    IMAGE = 'myapp'
  }
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/org/repo.git'
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t $IMAGE:$BUILD_NUMBER .'
      }
    }
    stage('Test') {
      steps {
        sh 'docker run --rm $IMAGE:$BUILD_NUMBER npm test'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push $REGISTRY/$IMAGE:$BUILD_NUMBER'
      }
    }
  }
  post {
    success {
      echo 'Success'
    }
    failure {
      echo 'Failure'
    }
    always {
      cleanWs()
    }
  }
}
```

## Comment

- in REGISTRY you need to insert the address of the Docker registry
- Image is the name of the image you need

In the stages area there are all the steps performed by the CI/CD pipeline. As you can see, all the commands are the same we would use from the terminal in case we would open a repository, build an image, test the image and push it to the external Docker registry.



## 3. How Jenkins Works
- Jenkins monitors your repository for changes (via webhooks or polling).
- When a change is detected, Jenkins executes the pipeline defined in your Jenkinsfile.
- Each stage in the pipeline runs sequentially (checkout, build, test, push, deploy).
- Results and logs are available in the Jenkins web interface.



## 4. Integrating Jenkins with GitHub

### Steps:
1. Add your repository to Jenkins (using "New Item" > "Pipeline" and configure the GitHub repo URL).
2. Add a webhook in your GitHub repository settings:
   - Go to Settings > Webhooks > Add webhook
   - Set the Payload URL to `http://<your-jenkins-server>/github-webhook/`
   - Choose "Just the push event" or others as needed
3. Make sure your Jenkins server is accessible from GitHub (public IP or use ngrok for local testing).
4. Commit and push your Jenkinsfile to the repository.
5. Jenkins will automatically trigger builds on new pushes.


## 5. Useful Links
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Docker Image](https://hub.docker.com/r/jenkins/jenkins)
- [Jenkinsfile Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)

