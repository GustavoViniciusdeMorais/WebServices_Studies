# Jenkins

### Install
```sh
apt update

apt install wget -y

apt install fontconfig openjdk-17-jre

java -version

wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update

apt-get install jenkins
```

## How to Start and Access the Jenkins Dashboard on Debian

### Prerequisites
- Jenkins installed on your Debian system
- Web browser to access the Jenkins Dashboard

### Step 1: Start Jenkins Service

1. **Start Jenkins**:
    ```bash
    sudo systemctl start jenkins
    ```

2. **Enable Jenkins to Start on Boot**:
    ```bash
    sudo systemctl enable jenkins
    ```

3. **Check Jenkins Status**:
    ```bash
    sudo systemctl status jenkins
    ```

### Step 2: Change Jenkins Default Port

1. **Open the Jenkins Configuration File**:
    ```bash
    sudo nano /etc/default/jenkins
    ```

2. **Modify the HTTP Port**:
    - Find the line that specifies the HTTP port:
        ```plaintext
        HTTP_PORT=8080
        ```
    - Change `8080` to your desired port number, for example:
        ```plaintext
        HTTP_PORT=8090
        ```

3. **Save and Close**: Save the file and exit the editor (Ctrl + O, Enter, Ctrl + X).

4. **Restart Jenkins**:
    ```bash
    sudo systemctl restart jenkins
    ```

### Step 3: Access Jenkins Dashboard

1. **Open Browser**: Open your preferred web browser.
2. **Navigate to Jenkins**: Enter the following URL in the address bar:
    ```plaintext
    http://your_server_ip_or_domain:8090
    ```
    Replace `your_server_ip_or_domain` with your server's IP address or domain name. If you are running Jenkins locally, use:
    ```plaintext
    http://localhost:8090
    ```

### Step 4: Unlock Jenkins

1. **Locate the Initial Admin Password**:
    - The password is stored in `/var/lib/jenkins/secrets/initialAdminPassword`.
    - Use the following command to display the password:
        ```bash
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
        ```

2. **Enter the Password**: Copy the password from the terminal and paste it into the "Administrator password" field on the Jenkins setup page in your browser.

3. **Continue**: Click "Continue" to proceed.

### Step 5: Customize Jenkins

1. **Install Suggested Plugins**:
    - On the "Customize Jenkins" page, select "Install suggested plugins". Jenkins will automatically install commonly used plugins.
    
2. **Create First Admin User**:
    - Fill out the form to create your first admin user and click "Save and Finish".
    
3. **Instance Configuration**:
    - Confirm the Jenkins URL and click "Save and Finish".

4. **Start Using Jenkins**:
    - Click on "Start using Jenkins" to access the Jenkins Dashboard.

### Step 6: Jenkins Dashboard Overview

- **Main Dashboard**: The main dashboard provides an overview of your Jenkins setup, showing existing jobs and their statuses.
- **New Item**: Click this to create a new job or pipeline.
- **Manage Jenkins**: Access various administrative options, such as managing plugins, configuring the system, and viewing Jenkins' status.
- **Credentials**: Manage credentials securely for your jobs.
- **Build History**: View the history of all builds and their statuses.
- **People**: Manage users and their permissions.

Now you have successfully started Jenkins, changed its default port, and accessed the Jenkins Dashboard. You can begin creating jobs, configuring pipelines, and managing your Jenkins environment. For more advanced configurations and usage, refer to the [official Jenkins documentation](https://www.jenkins.io/doc/).