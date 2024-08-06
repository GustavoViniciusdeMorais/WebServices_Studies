## Jenkins Pipeline Tutorial

### Prerequisites
- Jenkins installed and running
- Basic understanding of Jenkins and its UI
- A GitHub repository for source code

### Step 2: Create a New Jenkins Job

1. **New Item**: From the Jenkins dashboard, click on "New Item".
2. **Enter Job Name**: Enter a name for your job.
3. **Select Pipeline**: Choose "Pipeline" and click "OK".

### Step 3: Configure the Pipeline

1. **Pipeline Configuration**: In the job configuration page, scroll down to the "Pipeline" section.
2. **Definition**: Select "Pipeline script from SCM".
3. **SCM**: Choose "Git".
4. **Repository URL**: Enter the URL of your GitHub repository.
5. **Branch Specifier**: Set the branch you want to use, typically `*/main` or `*/master`.

### Step 4: Create a Jenkinsfile in Your Repository

1. **Jenkinsfile**: In the root of your GitHub repository, create a file named `Jenkinsfile`.
2. **Define Pipeline**: Add the following basic pipeline script to the `Jenkinsfile`:

    ```groovy
    pipeline {
        agent any

        stages {
            stage('Build') {
                steps {
                    echo 'Building...'
                    // Add your build steps here
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing...'
                    // Add your test steps here
                }
            }
            stage('Deploy') {
                steps {
                    echo 'Deploying...'
                    // Add your deploy steps here
                }
            }
        }
    }
    ```

3. **Commit and Push**: Commit and push the `Jenkinsfile` to your repository.

### Step 5: Run the Pipeline

1. **Build Now**: Go back to your Jenkins job and click "Build Now".
2. **View Console Output**: Click on the build number in the "Build History" and then "Console Output" to see the logs.

### Step 6: Customize Your Pipeline

- **Add Steps**: Add specific build, test, and deploy steps to the respective stages in your `Jenkinsfile`.
- **Environment Variables**: Use environment variables to manage sensitive data and configurations.

    ```groovy
    environment {
        MY_VAR = 'value'
    }
    ```

- **Post Actions**: Add actions to be performed after each stage or the entire pipeline.

    ```groovy
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if the stage succeeds'
        }
        failure {
            echo 'This will run only if the stage fails'
        }
    }
    ```

### Step 7: Advanced Configurations

- **Parallel Stages**: Run multiple stages in parallel.

    ```groovy
    stage('Parallel Stage') {
        parallel {
            stage('Branch 1') {
                steps {
                    echo 'Running Branch 1'
                }
            }
            stage('Branch 2') {
                steps {
                    echo 'Running Branch 2'
                }
            }
        }
    }
    ```

- **Using Libraries**: Use shared libraries for reusable code.

    ```groovy
    @Library('my-shared-library') _
    ```

This tutorial covers the basics of creating and running a Jenkins pipeline. For more advanced usage, refer to the official Jenkins documentation.